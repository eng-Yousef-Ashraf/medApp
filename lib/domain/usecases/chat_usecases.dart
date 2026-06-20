import 'package:my_flutter_app/domain/entities/message.dart';
import 'package:my_flutter_app/domain/repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;
  SendMessageUseCase(this.repository);
  Future<Message> call(String text) => repository.sendMessage(text);
}

class GetChatHistoryUseCase {
  final ChatRepository repository;
  GetChatHistoryUseCase(this.repository);
  List<Message> call() => repository.getMessageHistory();
}

class ClearChatHistoryUseCase {
  final ChatRepository repository;
  ClearChatHistoryUseCase(this.repository);
  void call() => repository.clearHistory();
}
