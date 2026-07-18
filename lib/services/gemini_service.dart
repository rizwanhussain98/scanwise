import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static const _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  static Future<String> enhanceReport({
    required String rawReport,
    required String apiKey,
  }) async {
    debugPrint("Enhance report clicked");
    final prompt =
        '''
You are an expert Radiologist Assistant.

You will be given a raw technical finding from a chest X-ray AI model.

Your task:
1. Parse the raw text (may contain noise).
2. Create a clean report with "Findings" and "Impression".
3. If no acute complication is reported, assume rest is unremarkable.
4. The "Findings" and "Impression" words should be bold.

Raw Model Output:
$rawReport

Detailed Report:
''';

    final res = await http.post(
      Uri.parse('$_endpoint?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {'temperature': 0.2},
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('Gemini error: ${res.body}');
    }

    final data = jsonDecode(res.body);
    return data['candidates'][0]['content']['parts'][0]['text'];
  }
}
