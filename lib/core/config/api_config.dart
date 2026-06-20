/// ─────────────────────────────────────────────────────────────────────────────
/// API Configuration – Groq, Gemini & Ollama
/// ─────────────────────────────────────────────────────────────────────────────
class ApiConfig {
  // ---------------------------------------------------------------------------
  // Groq Configuration
  // ---------------------------------------------------------------------------
  static const String groqApiKey = String.fromEnvironment(
    'GROQ_API_KEY',
    defaultValue:
        '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',
  );

  static const String groqModel = String.fromEnvironment(
    'GROQ_MODEL',
    defaultValue: 'llama-3.3-70b-versatile',
  );

  static const String groqBaseUrl = 'https://api.groq.com/openai/v1';

  static bool get isGroqConfigured => groqApiKey.isNotEmpty;

  // ---------------------------------------------------------------------------
  // Gemini Configuration
  // ---------------------------------------------------------------------------
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  static const String geminiModel = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: 'gemini-1.5-flash',
  );

  static bool get isGeminiConfigured => geminiApiKey.isNotEmpty;

  // ---------------------------------------------------------------------------
  // Ollama Configuration (Local)
  // ---------------------------------------------------------------------------
  static const String ollamaBaseUrl = String.fromEnvironment(
    'OLLAMA_BASE_URL',
    defaultValue: 'http://localhost:11434',
  );

  static const String ollamaModel = String.fromEnvironment(
    'OLLAMA_MODEL',
    defaultValue: 'llama3', // or 'gemma', 'mistral', etc.
  );
}
