import 'package:my_flutter_app/domain/entities/message.dart';

abstract class ChatRepository {
  Future<Message> sendMessage(String text);
  List<Message> getMessageHistory();
  void clearHistory();
}
