import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:onnxruntime/onnxruntime.dart';
import 'package:path_provider/path_provider.dart';

import 'package:scanwise/res/color.dart';
import '../services/gemini_service.dart';
import '../services/pdf_export_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // UI state
  File? _imageFile;
  bool _busy = false;
  bool _aiEnhance = false;

  String _findings = '';
  String _impression = '';
  double _confidence = 0.0;

  final ImagePicker _picker = ImagePicker();

  // ---------------- ML STATE ----------------

  OrtSession? _session;

  int _h = 224;
  int _w = 224;
  List<double> _mean = const [0.485, 0.456, 0.406];
  List<double> _std = const [0.229, 0.224, 0.225];

  late Float32List _trainEmbs;
  late List<String> _trainReports;
  int _n = 0;
  int _d = 0;

  // ---------------- INIT ----------------

  @override
  void initState() {
    super.initState();
    _initAll();
  }

  Future<void> _initAll() async {
    setState(() => _busy = true);
    try {
      await _loadMeta();
      await _loadOnnx();
      await _loadRetrievalDb();
    } finally {
      setState(() => _busy = false);
    }
  }

  // ---------------- ASSET LOADING ----------------

  Future<File> _assetToFile(String assetPath, String outName) async {
    final bytes = await rootBundle.load(assetPath);
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/$outName');
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    return file;
  }

  Future<void> _loadMeta() async {
    final metaStr = await rootBundle.loadString(
      'assets/models/preprocess_meta.json',
    );
    final meta = jsonDecode(metaStr) as Map<String, dynamic>;
    final inputSize = (meta['input_size'] as List).cast<num>();
    _h = inputSize[1].toInt();
    _w = inputSize[2].toInt();
    _mean = (meta['mean'] as List)
        .cast<num>()
        .map((e) => e.toDouble())
        .toList();
    _std = (meta['std'] as List).cast<num>().map((e) => e.toDouble()).toList();
  }

  Future<void> _loadOnnx() async {
    final onnxFile = await _assetToFile(
      'assets/models/embedder.onnx',
      'embedder.onnx',
    );
    final opts = OrtSessionOptions();
    _session = OrtSession.fromFile(File(onnxFile.path), opts);
  }

  Future<void> _loadRetrievalDb() async {
    final metaStr = await rootBundle.loadString(
      'assets/models/train_embs_meta.json',
    );
    final meta = jsonDecode(metaStr) as Map<String, dynamic>;
    _n = (meta['n'] as num).toInt();
    _d = (meta['d'] as num).toInt();

    final reportsStr = await rootBundle.loadString(
      'assets/models/train_reports.json',
    );
    final reportsList = (jsonDecode(reportsStr) as List).cast<String>();
    _trainReports = reportsList;

    final embsBytes = await rootBundle.load('assets/models/train_embs.f32');
    final bb = embsBytes.buffer;
    _trainEmbs = bb.asFloat32List();

    final expected = _n * _d;
    if (_trainEmbs.length != expected) {
      throw StateError(
        'Embedding size mismatch. Got ${_trainEmbs.length}, expected $expected',
      );
    }
    if (_trainReports.length != _n) {
      throw StateError(
        'Reports size mismatch. Got ${_trainReports.length}, expected $_n',
      );
    }
  }

  // ---------------- IMAGE PICK ----------------

  Future<void> _pick(ImageSource source) async {
    if (_busy) return;

    final x = await _picker.pickImage(source: source);
    if (x == null) return;

    final bytes = await x.readAsBytes();
    if (!_looksLikeXray(bytes)) {
      _showInvalidDialog();
      return;
    }

    setState(() {
      _imageFile = File(x.path);
      _findings = '';
      _impression = '';
      _confidence = 0;
    });
  }

  // ---------------- XRAY HEURISTIC ----------------

  bool _looksLikeXray(Uint8List bytes) {
    final image = img.decodeImage(bytes);
    if (image == null) return false;

    int gray = 0;
    final total = image.width * image.height;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final p = image.getPixel(x, y);
        if ((p.r - p.g).abs() < 6 && (p.r - p.b).abs() < 6) {
          gray++;
        }
      }
    }
    return gray / total > 0.85;
  }

  // ---------------- CORE PIPELINE ----------------

  Future<void> _generateReport() async {
    if (_busy || _imageFile == null) {
      _showSnack('Scan an X-ray first.');
      return;
    }

    setState(() {
      _busy = true;
      _aiEnhance = false;
    });

    try {
      final bytes = await _imageFile!.readAsBytes();
      final input = _preprocessToNchwFloat32(bytes);
      final emb = _runEmbedder(input);

      final bestIdx = _argmaxCosine(emb);
      final report = _trainReports[bestIdx];

      if (report.trim().isEmpty) {
        _showSnack('No report found.');
        return;
      }

      setState(() {
        _splitReport(report);
        _confidence = 0.9;
      });
    } finally {
      setState(() => _busy = false);
    }
  }

  void _splitReport(String r) {
    final lower = r.toLowerCase();
    final f = lower.indexOf('findings');
    final i = lower.indexOf('impression');

    if (f != -1 && i != -1 && i > f) {
      _findings = r.substring(f, i).trim();
      _impression = r.substring(i).trim();
    } else {
      _findings = r.trim();
      _impression = '';
    }
  }

  // ---------------- ML FUNCTIONS ----------------

  Float32List _preprocessToNchwFloat32(Uint8List imageBytes) {
    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      throw StateError('Could not decode image.');
    }

    // Resize to model input.
    final resized = img.copyResize(
      decoded,
      width: _w,
      height: _h,
      interpolation: img.Interpolation.linear,
    );

    // timm default expects RGB float in [0..1], then (x-mean)/std
    final out = Float32List(1 * 3 * _h * _w);
    int idxR = 0;
    int idxG = _h * _w;
    int idxB = 2 * _h * _w;

    for (int y = 0; y < _h; y++) {
      for (int x = 0; x < _w; x++) {
        final p = resized.getPixel(x, y);
        final r = p.r / 255.0;
        final g = p.g / 255.0;
        final b = p.b / 255.0;

        out[idxR++] = ((r - _mean[0]) / _std[0]).toDouble();
        out[idxG++] = ((g - _mean[1]) / _std[1]).toDouble();
        out[idxB++] = ((b - _mean[2]) / _std[2]).toDouble();
      }
    }
    return out;
  }

  Float32List _runEmbedder(Float32List nchw) {
    final session = _session;
    if (session == null) throw StateError('ONNX session not loaded.');

    final inputTensor = OrtValueTensor.createTensorWithDataList(nchw, [
      1,
      3,
      _h,
      _w,
    ]);

    final outputs = session.run(OrtRunOptions(), {'image': inputTensor});

    final out0 = outputs.first as OrtValueTensor;

    final raw = out0.value as List;
    final row = raw[0] as List;

    final emb = Float32List.fromList(row.cast<double>());
    print(out0.value.runtimeType);

    // Output is already L2-normalized by export.
    if (emb.length != _d) {
      throw StateError(
        'Embedding dim mismatch. Got ${emb.length}, expected $_d',
      );
    }
    return emb;
  }

  int _argmaxCosine(Float32List queryEmb) {
    double best = -1e9;
    int bestIdx = 0;

    // Since both are normalized, cosine = dot product.
    for (int i = 0; i < _n; i++) {
      final base = i * _d;
      double dot = 0.0;
      for (int j = 0; j < _d; j++) {
        dot += _trainEmbs[base + j] * queryEmb[j];
      }
      if (dot > best) {
        best = dot;
        bestIdx = i;
      }
    }
    return bestIdx;
  }

  Future<void> _enhanceWithAI() async {
    if (_busy || _findings.isEmpty) return;

    setState(() => _busy = true);
    try {
      final enhanced = await GeminiService.enhanceReport(
        rawReport: '$_findings\n$_impression',
        apiKey: '',
      );
      setState(() {
        _aiEnhance = true;
        _findings = enhanced;
        _impression = '';
      });
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _exportPdf() async {
    if (_busy || _findings.isEmpty) return;

    setState(() {
      _busy = true;
      _aiEnhance = false;
    });
    try {
      await PdfExportService.exportReport(
        findings: _findings,
        impression: _impression,
        confidence: _confidence,
      );
    } finally {
      setState(() => _busy = false);
    }
  }

  Widget buildFormattedReport(String text) {
    final spans = <TextSpan>[];

    final lines = text.split('\n');
    for (final line in lines) {
      if (line.trim().startsWith('Findings') ||
          line.trim().startsWith('Impression')) {
        spans.add(
          TextSpan(
            text: '$line\n',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      } else {
        spans.add(TextSpan(text: '$line\n'));
      }
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 14),
        children: spans,
      ),
    );
  }


  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: const Text('ScanWise', style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: [
          _buildBody(),
          if (_busy)
            Container(
              color: Colors.black12,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildBody() => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        _buildFeatureGrid(),
        const SizedBox(height: 24),
        _buildScannerCard(),
        if (_findings.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildReportCard(),
        ],
      ],
    ),
  );

  // ---------------- HELPERS ----------------

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showInvalidDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.whiteColor,
        title: const Text('Invalid Image'),
        content: const Text('Please upload a valid X-ray image.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() => GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 3,
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    children: [
      _FeatureTile(
        Icons.medical_services,
        'Diagnosis',
        _busy ? null : _generateReport,
      ),
      _FeatureTile(
        Icons.description,
        'Reports',
        _busy ? null : _generateReport,
      ),
      _FeatureTile(
        Icons.auto_fix_high,
        'AI Enhance',
        _busy ? null : _enhanceWithAI,
      ),
      _FeatureTile(
        Icons.picture_as_pdf,
        'Export PDF',
        _busy ? null : _exportPdf,
      ),
      _FeatureTile(Icons.analytics, 'Insights', null),
      _FeatureTile(Icons.health_and_safety, 'Monitoring', null),
    ],
  );

  Widget _buildScannerCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        const Text('Scanner', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 1,
          child: _imageFile == null
              ? _EmptyScanner()
              : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(_imageFile!, fit: BoxFit.cover),
                ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _ScanButton(
              Icons.camera_alt,
              'Camera',
              _busy ? null : () => _pick(ImageSource.camera),
            ),
            const SizedBox(width: 12),
            _ScanButton(
              Icons.photo_library,
              'Gallery',
              _busy ? null : () => _pick(ImageSource.gallery),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildReportCard() => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text('Confidence ${(100 * _confidence).toStringAsFixed(1)}%'),
          // const SizedBox(height: 8),
          if (_aiEnhance == false)
            const Text(
              'Findings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          // Text(_findings),
          MarkdownBody(
            data: _findings,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(fontSize: 14),
              strong: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_aiEnhance == false && _impression.isNotEmpty)
            const Text(
              'Impression',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          Text(_impression),
        ],
      ),
    ),
  );
}

// ---------------- COMPONENTS ----------------

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _FeatureTile(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Opacity(
        opacity: disabled ? 0.4 : 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ScanButton(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 18),
        label: Text(label),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _EmptyScanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.camera_alt, color: Colors.white54, size: 40),
    );
  }
}
