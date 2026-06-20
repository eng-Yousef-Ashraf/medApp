import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/core/config/api_config.dart';
import 'package:my_flutter_app/domain/entities/message.dart';

/// Remote data source that calls the Ollama REST API.
///
/// Ollama exposes an OpenAI-compatible `/api/chat` endpoint.
/// No API key is required – Ollama runs fully locally / for free.
class OllamaDataSource {
  static String get _chatUrl =>
      '${ApiConfig.ollamaBaseUrl}/api/chat';

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

  // Keeps conversation context as a list of {role, content} maps
  // (OpenAI-compatible format used by Ollama).
  final List<Map<String, String>> _history = [];

  bool _sessionStarted = false;

  /// Sends [userText] to Ollama and returns a parsed [Message].
  Future<Message> generateResponse(String userText) async {
    // Initialise with system prompt on first call.
    if (!_sessionStarted) {
      _history.add({'role': 'system', 'content': _systemPrompt});
      _sessionStarted = true;
    }

    // Add the user turn.
    _history.add({'role': 'user', 'content': userText});

    final body = jsonEncode({
      'model': ApiConfig.ollamaModel,
      'messages': _history,
      'stream': false,
      'options': {
        'temperature': 0.4,
        'num_predict': 800,
      },
    });

    late http.Response response;
    try {
      response = await http
          .post(
            Uri.parse(_chatUrl),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 60));
    } catch (e) {
      // ignore: avoid_print
      print('❌ Ollama connection error: $e');
      throw Exception(
        'Could not connect to Ollama at ${ApiConfig.ollamaBaseUrl}.\n'
        'Make sure Ollama is running: ollama serve\n'
        'Error: $e',
      );
    }

    if (response.statusCode != 200) {
      final errorBody = response.body;
      // ignore: avoid_print
      print('❌ Ollama HTTP ${response.statusCode}: $errorBody');
      throw Exception('Ollama API error ${response.statusCode}: $errorBody');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    // Ollama /api/chat response shape:
    //   { "message": { "role": "assistant", "content": "..." }, ... }
    final rawText =
        json['message']?['content'] as String? ?? '';

    // Add assistant reply to history for multi-turn context.
    if (rawText.isNotEmpty) {
      _history.add({'role': 'assistant', 'content': rawText});
    }

    return _parseOllamaResponse(rawText);
  }

  /// Parses the JSON response from Ollama into a [Message].
  Message _parseOllamaResponse(String rawText) {
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
  void resetSession() {
    _history.clear();
    _sessionStarted = false;
  }
}
