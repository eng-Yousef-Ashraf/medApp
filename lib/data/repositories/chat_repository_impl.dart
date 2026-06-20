import 'package:my_flutter_app/data/datasources/local_data_source.dart';
import 'package:my_flutter_app/domain/entities/message.dart';
import 'package:my_flutter_app/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final LocalDataSource localDataSource;

  ChatRepositoryImpl({required this.localDataSource});

  @override
  Future<Message> sendMessage(String text) async {
    final userMessage = Message(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    localDataSource.addMessage(userMessage);

    final aiResponse = await localDataSource.generateAiResponse(text);
    localDataSource.addMessage(aiResponse);

    return aiResponse;
  }

  @override
  List<Message> getMessageHistory() {
    return localDataSource.getChatHistory();
  }

  @override
  void clearHistory() {
    localDataSource.clearChatHistory();
  }
}
