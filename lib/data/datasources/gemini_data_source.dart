import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/core/config/api_config.dart';
import 'package:my_flutter_app/domain/entities/message.dart';

/// Remote data source that calls the Gemini REST API directly.
class GeminiDataSource {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  static const String _systemPrompt =
      'You are MedLink AI, a compassionate and professional medical first-aid assistant built into a healthcare app.\n\n'
      'Your role:\n'
      '1. Assess the urgency of the user\'s described symptoms.\n'
      '2. Give accurate, easy-to-understand first-aid guidance.\n'
      '3. Always remind users to seek professional medical help for serious issues.\n\n'
      'IMPORTANT: You MUST respond ONLY with valid JSON in this exact structure (no markdown, no extra text):\n'
      '{\n'
      '  "urgency": "<none|mild|moderate|critical|info>",\n'
      '  "response": "<Your conversational reply to the user>",\n'
      '  "firstAid": "<Step-by-step first aid advice, or null if not applicable>"\n'
      '}\n\n'
      'Urgency levels:\n'
      '- "critical" → life-threatening emergencies (chest pain, stroke, severe bleeding, difficulty breathing)\n'
      '- "moderate" → needs medical attention within 24 hours (high fever, burns, vomiting, dizziness)\n'
      '- "mild"     → manageable at home (headache, cold, minor cut, sore throat)\n'
      '- "info"     → general health question, no specific urgency\n'
      '- "none"     → non-medical question or greeting\n\n'
      'Always respond in the language the user writes in.\n'
      'Never diagnose definitively. Always recommend consulting a doctor.';

  // Keeps conversation context as a list of {role, parts} maps.
  final List<Map<String, dynamic>> _history = [];

  /// Sends [userText] to Gemini and returns a parsed [Message].
  Future<Message> generateResponse(String userText) async {
    // Add user turn to history.
    _history.add({
      'role': 'user',
      'parts': [
        {'text': userText}
      ],
    });

    final url = Uri.parse(
      '$_baseUrl/${ApiConfig.geminiModel}:generateContent',
    );

    final body = jsonEncode({
      'system_instruction': {
        'parts': [
          {'text': _systemPrompt}
        ]
      },
      'contents': _history,
      'generationConfig': {
        'temperature': 0.4,
        'maxOutputTokens': 800,
      },
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': ApiConfig.geminiApiKey,
      },
      body: body,
    );

    if (response.statusCode != 200) {
      // Parse error detail for better logging.
      final errorBody = response.body;
      // ignore: avoid_print
      print('❌ Gemini HTTP ${response.statusCode}: $errorBody');
      throw Exception('Gemini API error ${response.statusCode}: $errorBody');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final rawText = (json['candidates'] as List?)
            ?.firstOrNull?['content']?['parts']
            ?.firstOrNull?['text'] as String? ??
        '';

    // Add model reply to history so multi-turn works.
    if (rawText.isNotEmpty) {
      _history.add({
        'role': 'model',
        'parts': [
          {'text': rawText}
        ],
      });
    }

    return _parseGeminiResponse(rawText);
  }

  /// Parses the JSON response from Gemini into a [Message].
  Message _parseGeminiResponse(String rawText) {
    try {
      final cleaned = rawText
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final urgencyMatch =
          RegExp(r'"urgency"\s*:\s*"([^"]+)"').firstMatch(cleaned);
      final responseMatch =
          RegExp(r'"response"\s*:\s*"((?:[^"\\]|\\.)*)"').firstMatch(cleaned);
      final firstAidMatch =
          RegExp(r'"firstAid"\s*:\s*(?:"((?:[^"\\]|\\.)*)"|null)')
              .firstMatch(cleaned);

      final urgencyStr = urgencyMatch?.group(1) ?? 'info';
      final responseText = _unescape(responseMatch?.group(1) ?? rawText);
      final firstAid = firstAidMatch?.group(1) != null
          ? _unescape(firstAidMatch!.group(1)!)
          : null;

      return Message(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        text: responseText,
        isUser: false,
        timestamp: DateTime.now(),
        urgencyLevel: _parseUrgency(urgencyStr),
        firstAidAdvice: firstAid,
      );
    } catch (_) {
      return Message(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        text: rawText.isNotEmpty
            ? rawText
            : 'Sorry, I encountered an issue. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
        urgencyLevel: UrgencyLevel.info,
      );
    }
  }

  String _unescape(String s) => s
      .replaceAll(r'\n', '\n')
      .replaceAll(r'\t', '\t')
      .replaceAll(r'\"', '"')
      .replaceAll(r'\\', '\\');

  UrgencyLevel _parseUrgency(String value) {
    switch (value.toLowerCase()) {
      case 'critical':
        return UrgencyLevel.critical;
      case 'moderate':
        return UrgencyLevel.moderate;
      case 'mild':
        return UrgencyLevel.mild;
      case 'info':
        return UrgencyLevel.info;
      default:
        return UrgencyLevel.none;
    }
  }

  /// Reset conversation history.
  void resetSession() => _history.clear();
}
