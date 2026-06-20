import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/domain/entities/message.dart';
import 'package:my_flutter_app/domain/usecases/chat_usecases.dart';
import 'package:my_flutter_app/presentation/cubits/chat/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendMessageUseCase sendMessageUseCase;
  final GetChatHistoryUseCase getChatHistoryUseCase;
  final ClearChatHistoryUseCase clearChatHistoryUseCase;

  ChatCubit({
    required this.sendMessageUseCase,
    required this.getChatHistoryUseCase,
    required this.clearChatHistoryUseCase,
  }) : super(ChatInitial());

  void loadMessages() {
    final messages = getChatHistoryUseCase();
    emit(ChatLoaded(messages: messages));
  }

  Future<void> sendMessage(String text) async {
    final currentMessages = getChatHistoryUseCase();
    
    final userMessage = Message(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    emit(ChatLoaded(
      messages: [...currentMessages, userMessage],
      isAiTyping: true,
    ));

    try {
      await sendMessageUseCase(text);
      final updatedMessages = getChatHistoryUseCase();
      emit(ChatLoaded(messages: updatedMessages, isAiTyping: false));
    } catch (e) {
      // Print actual error to help diagnose issues (remove in production)
      // ignore: avoid_print
      print('❌ Gemini error: $e');
      // Keep existing messages visible and show a friendly error from the AI.
      final messagesWithError = [
        ...getChatHistoryUseCase(),
        Message(
          id: 'ai_error_${DateTime.now().millisecondsSinceEpoch}',
          text: '⚠️ Sorry, I couldn\'t get a response right now. Please check your internet connection and try again.',
          isUser: false,
          timestamp: DateTime.now(),
          urgencyLevel: UrgencyLevel.info,
        ),
      ];
      emit(ChatLoaded(messages: messagesWithError, isAiTyping: false));
    }
  }

  void clearChat() {
    clearChatHistoryUseCase();
    emit(const ChatLoaded(messages: []));
  }
}
