import 'package:equatable/equatable.dart';
import 'package:my_flutter_app/domain/entities/message.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  final bool isAiTyping;

  const ChatLoaded({required this.messages, this.isAiTyping = false});

  ChatLoaded copyWith({List<Message>? messages, bool? isAiTyping}) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isAiTyping: isAiTyping ?? this.isAiTyping,
    );
  }

  @override
  List<Object?> get props => [messages, isAiTyping];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
  @override
  List<Object?> get props => [message];
}
