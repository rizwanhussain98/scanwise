// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// import 'package:onnxruntime/onnxruntime.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class HomeView extends StatefulWidget {
//   const HomeView({super.key});
//
//   @override
//   State<HomeView> createState() => _HomeViewState();
// }
//
// class _HomeViewState extends State<HomeView> {
//   final _picker = ImagePicker();
//
//   File? _imageFile;
//   String _report = '';
//   bool _busy = false;
//
//   // Model assets
//   OrtSession? _session;
//   int _h = 224;
//   int _w = 224;
//   List<double> _mean = const [0.485, 0.456, 0.406];
//   List<double> _std = const [0.229, 0.224, 0.225];
//
//   late Float32List _trainEmbs; // length = n*d
//   int _n = 0;
//   int _d = 0;
//   late List<String> _trainReports;
//
//   @override
//   void initState() {
//     super.initState();
//     _initAll();
//   }
//
//   Future<void> _initAll() async {
//     setState(() => _busy = true);
//     try {
//       await _ensurePerms();
//       await _loadMeta();
//       await _loadOnnx();
//       await _loadRetrievalDb();
//     } catch (e) {
//       setState(() => _report = 'Init error: $e');
//     } finally {
//       setState(() => _busy = false);
//     }
//   }
//
//   Future<void> _ensurePerms() async {
//     await Permission.camera.request();
//     await Permission.photos.request();
//     await Permission.storage.request();
//   }
//
//   Future<File> _assetToFile(String assetPath, String outName) async {
//     final bytes = await rootBundle.load(assetPath);
//     final dir = await getApplicationSupportDirectory();
//     final file = File('${dir.path}/$outName');
//     await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
//     return file;
//   }
//
//   Future<void> _loadMeta() async {
//     final metaStr = await rootBundle.loadString(
//       'assets/models/preprocess_meta.json',
//     );
//     final meta = jsonDecode(metaStr) as Map<String, dynamic>;
//     final inputSize = (meta['input_size'] as List).cast<num>();
//     _h = inputSize[1].toInt();
//     _w = inputSize[2].toInt();
//     _mean = (meta['mean'] as List)
//         .cast<num>()
//         .map((e) => e.toDouble())
//         .toList();
//     _std = (meta['std'] as List).cast<num>().map((e) => e.toDouble()).toList();
//   }
//
//   Future<void> _loadOnnx() async {
//     final onnxFile = await _assetToFile(
//       'assets/models/embedder.onnx',
//       'embedder.onnx',
//     );
//     final opts = OrtSessionOptions();
//     _session = OrtSession.fromFile(File(onnxFile.path), opts);
//   }
//
//   Future<void> _loadRetrievalDb() async {
//     final metaStr = await rootBundle.loadString(
//       'assets/models/train_embs_meta.json',
//     );
//     final meta = jsonDecode(metaStr) as Map<String, dynamic>;
//     _n = (meta['n'] as num).toInt();
//     _d = (meta['d'] as num).toInt();
//
//     final reportsStr = await rootBundle.loadString(
//       'assets/models/train_reports.json',
//     );
//     final reportsList = (jsonDecode(reportsStr) as List).cast<String>();
//     _trainReports = reportsList;
//
//     final embsBytes = await rootBundle.load('assets/models/train_embs.f32');
//     final bb = embsBytes.buffer;
//     _trainEmbs = bb.asFloat32List();
//
//     final expected = _n * _d;
//     if (_trainEmbs.length != expected) {
//       throw StateError(
//         'Embedding size mismatch. Got ${_trainEmbs.length}, expected $expected',
//       );
//     }
//     if (_trainReports.length != _n) {
//       throw StateError(
//         'Reports size mismatch. Got ${_trainReports.length}, expected $_n',
//       );
//     }
//   }
//
//   Future<void> _pickFromGallery() async {
//     final x = await _picker.pickImage(source: ImageSource.gallery);
//     if (x == null) return;
//     setState(() {
//       _imageFile = File(x.path);
//       _report = '';
//     });
//   }
//
//   Future<void> _pickFromCamera() async {
//     final x = await _picker.pickImage(source: ImageSource.camera);
//     if (x == null) return;
//     setState(() {
//       _imageFile = File(x.path);
//       _report = '';
//     });
//   }
//
//   Float32List _preprocessToNchwFloat32(Uint8List imageBytes) {
//     final decoded = img.decodeImage(imageBytes);
//     if (decoded == null) {
//       throw StateError('Could not decode image.');
//     }
//
//     // Resize to model input.
//     final resized = img.copyResize(
//       decoded,
//       width: _w,
//       height: _h,
//       interpolation: img.Interpolation.linear,
//     );
//
//     // timm default expects RGB float in [0..1], then (x-mean)/std
//     final out = Float32List(1 * 3 * _h * _w);
//     int idxR = 0;
//     int idxG = _h * _w;
//     int idxB = 2 * _h * _w;
//
//     for (int y = 0; y < _h; y++) {
//       for (int x = 0; x < _w; x++) {
//         final p = resized.getPixel(x, y);
//         final r = p.r / 255.0;
//         final g = p.g / 255.0;
//         final b = p.b / 255.0;
//
//         out[idxR++] = ((r - _mean[0]) / _std[0]).toDouble();
//         out[idxG++] = ((g - _mean[1]) / _std[1]).toDouble();
//         out[idxB++] = ((b - _mean[2]) / _std[2]).toDouble();
//       }
//     }
//     return out;
//   }
//
//   Float32List _runEmbedder(Float32List nchw) {
//     final session = _session;
//     if (session == null) throw StateError('ONNX session not loaded.');
//
//     final inputTensor = OrtValueTensor.createTensorWithDataList(nchw, [
//       1,
//       3,
//       _h,
//       _w,
//     ]);
//
//     final outputs = session.run(OrtRunOptions(), {'image': inputTensor});
//
//     final out0 = outputs.first as OrtValueTensor;
//
//     final raw = out0.value as List;
//     final row = raw[0] as List;
//
//     final emb = Float32List.fromList(row.cast<double>());
//     print(out0.value.runtimeType);
//
//     // Output is already L2-normalized by export.
//     if (emb.length != _d) {
//       throw StateError(
//         'Embedding dim mismatch. Got ${emb.length}, expected $_d',
//       );
//     }
//     return emb;
//   }
//
//   int _argmaxCosine(Float32List queryEmb) {
//     double best = -1e9;
//     int bestIdx = 0;
//
//     // Since both are normalized, cosine = dot product.
//     for (int i = 0; i < _n; i++) {
//       final base = i * _d;
//       double dot = 0.0;
//       for (int j = 0; j < _d; j++) {
//         dot += _trainEmbs[base + j] * queryEmb[j];
//       }
//       if (dot > best) {
//         best = dot;
//         bestIdx = i;
//       }
//     }
//     return bestIdx;
//   }
//
//   Future<void> _run() async {
//     final f = _imageFile;
//     if (f == null) return;
//
//     setState(() => _busy = true);
//     try {
//       final bytes = await f.readAsBytes();
//       final input = _preprocessToNchwFloat32(bytes);
//       final emb = _runEmbedder(input);
//
//       final bestIdx = _argmaxCosine(emb);
//       final bestReport = _trainReports[bestIdx];
//
//       setState(() {
//         _report = bestReport.trim().isEmpty
//             ? 'No report text found for nearest match.'
//             : bestReport.trim();
//       });
//     } catch (e) {
//       setState(() => _report = 'Run error: $e');
//     } finally {
//       setState(() => _busy = false);
//     }
//   }
//
//   @override
//   void dispose() {
//     _session?.release();
//     OrtEnv.instance.release();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final imgFile = _imageFile;
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('ScanWise')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: _busy ? null : _pickFromCamera,
//                     child: const Text('Camera'),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: _busy ? null : _pickFromGallery,
//                     child: const Text('Gallery'),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             if (imgFile != null)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.file(imgFile, height: 220, fit: BoxFit.cover),
//               )
//             else
//               Container(
//                 height: 220,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(),
//                 ),
//                 child: const Text('Pick an image.'),
//               ),
//             const SizedBox(height: 12),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: (_busy || imgFile == null) ? null : _run,
//                 child: Text(_busy ? 'Running...' : 'Generate report'),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Text(
//                   _report.isEmpty ? 'Report will show here.' : _report,
//                   style: const TextStyle(fontSize: 14),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
