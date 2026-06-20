import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/core/config/api_config.dart';
import 'package:my_flutter_app/domain/entities/message.dart';

/// Remote data source that calls the Groq Cloud API.
///
/// Groq uses the OpenAI-compatible /chat/completions endpoint.
/// Get a FREE API key at: https://console.groq.com
class GroqDataSource {
  static String get _chatUrl =>
      '${ApiConfig.groqBaseUrl}/chat/completions';

  // Valid specialties that match our Egyptian doctor list.
  static const List<String> _validSpecialties = [
    'Cardiology',
    'Neurology',
    'Pediatrics',
    'Orthopedics',
    'Dermatology',
    'General Practice',
    'Psychiatry',
    'Emergency Medicine',
  ];

  static const String _systemPrompt =
      'You are MedLink AI, a compassionate and professional medical first-aid assistant built into a healthcare app.\n\n'
      'Your role:\n'
      '1. Assess the urgency of the user\'s described symptoms.\n'
      '2. Give accurate, easy-to-understand first-aid guidance.\n'
      '3. Recommend a relevant medical specialty for the user to consult.\n'
      '4. Always remind users to seek professional medical help for serious issues.\n\n'
      'IMPORTANT: You MUST respond ONLY with valid JSON in this exact structure (no markdown, no extra text):\n'
      '{\n'
      '  "urgency": "<none|mild|moderate|critical|info>",\n'
      '  "response": "<Your conversational reply to the user>",\n'
      '  "firstAid": "<Step-by-step first aid advice, or null if not applicable>",\n'
      '  "recommendedSpecialty": "<One of: Cardiology|Neurology|Pediatrics|Orthopedics|Dermatology|General Practice|Psychiatry|Emergency Medicine — or null if non-medical>"\n'
      '}\n\n'
      'Urgency levels:\n'
      '- "critical" → life-threatening emergencies (chest pain, stroke, severe bleeding, difficulty breathing)\n'
      '- "moderate" → needs medical attention within 24 hours (high fever, burns, vomiting, dizziness)\n'
      '- "mild"     → manageable at home (headache, cold, minor cut, sore throat)\n'
      '- "info"     → general health question, no specific urgency\n'
      '- "none"     → non-medical question or greeting\n\n'
      'Specialty mapping guidance:\n'
      '- Chest pain, palpitations, blood pressure → Cardiology\n'
      '- Headache, dizziness, seizures, memory → Neurology\n'
      '- Children symptoms → Pediatrics\n'
      '- Bone, joint, muscle, back pain → Orthopedics\n'
      '- Skin, hair, nails → Dermatology\n'
      '- Anxiety, panic, depression, stress, mental health → Psychiatry\n'
      '- Emergencies, trauma → Emergency Medicine\n'
      '- General illness, cold, fever, fatigue → General Practice\n\n'
      'Always respond in the language the user writes in.\n'
      'Never diagnose definitively. Always recommend consulting a doctor.';

  // Multi-turn conversation history (OpenAI-compatible format).
  final List<Map<String, String>> _history = [
    {'role': 'system', 'content': _systemPrompt},
  ];

  /// Sends [userText] to Groq and returns a parsed [Message].
  Future<Message> generateResponse(String userText) async {
    // Add the user turn.
    _history.add({'role': 'user', 'content': userText});

    final body = jsonEncode({
      'model': ApiConfig.groqModel,
      'messages': _history,
      'temperature': 0.4,
      'max_tokens': 800,
    });

    late http.Response response;
    try {
      response = await http
          .post(
            Uri.parse(_chatUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${ApiConfig.groqApiKey}',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      // ignore: avoid_print
      print('❌ Groq connection error: $e');
      throw Exception('Could not connect to Groq API.\nError: $e');
    }

    if (response.statusCode != 200) {
      final errorBody = response.body;
      // ignore: avoid_print
      print('❌ Groq HTTP ${response.statusCode}: $errorBody');
      throw Exception('Groq API error ${response.statusCode}: $errorBody');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    // OpenAI-compatible response shape:
    //   { "choices": [ { "message": { "content": "..." } } ] }
    final rawText =
        (json['choices'] as List?)?.firstOrNull?['message']?['content']
            as String? ??
        '';

    // Add assistant reply to history for multi-turn context.
    if (rawText.isNotEmpty) {
      _history.add({'role': 'assistant', 'content': rawText});
    }

    return _parseResponse(rawText);
  }

  /// Parses the JSON response from Groq into a [Message].
  Message _parseResponse(String rawText) {
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
      final specialtyMatch =
          RegExp(r'"recommendedSpecialty"\s*:\s*(?:"([^"]+)"|null)')
              .firstMatch(cleaned);

      final urgencyStr = urgencyMatch?.group(1) ?? 'info';
      final responseText = _unescape(responseMatch?.group(1) ?? rawText);
      final firstAid = firstAidMatch?.group(1) != null
          ? _unescape(firstAidMatch!.group(1)!)
          : null;

      // Validate specialty is one we know about.
      final rawSpecialty = specialtyMatch?.group(1);
      final specialty = (rawSpecialty != null &&
              _validSpecialties.contains(rawSpecialty))
          ? rawSpecialty
          : null;

      return Message(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        text: responseText,
        isUser: false,
        timestamp: DateTime.now(),
        urgencyLevel: _parseUrgency(urgencyStr),
        firstAidAdvice: firstAid,
        recommendedSpecialty: specialty,
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

  /// Reset conversation history (keeps the system prompt).
  void resetSession() {
    _history
      ..clear()
      ..add({'role': 'system', 'content': _systemPrompt});
  }
}
