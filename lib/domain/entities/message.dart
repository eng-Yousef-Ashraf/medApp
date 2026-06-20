import 'package:equatable/equatable.dart';

enum UrgencyLevel { none, mild, moderate, critical, info }

class Message extends Equatable {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final UrgencyLevel urgencyLevel;
  final String? firstAidAdvice;
  /// The medical specialty recommended by the AI (e.g. "Psychiatry", "Cardiology").
  /// null if not applicable.
  final String? recommendedSpecialty;

  const Message({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.urgencyLevel = UrgencyLevel.none,
    this.firstAidAdvice,
    this.recommendedSpecialty,
  });

  @override
  List<Object?> get props => [id];
}
