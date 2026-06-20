import 'package:equatable/equatable.dart';

enum BookingStatus { pending, confirmed, completed, cancelled }

class Booking extends Equatable {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final DateTime date;
  final String timeSlot;
  final String reason;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.date,
    required this.timeSlot,
    required this.reason,
    required this.status,
  });

  Booking copyWith({
    String? id,
    String? doctorId,
    String? doctorName,
    String? doctorSpecialty,
    DateTime? date,
    String? timeSlot,
    String? reason,
    BookingStatus? status,
  }) {
    return Booking(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialty: doctorSpecialty ?? this.doctorSpecialty,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      reason: reason ?? this.reason,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id];
}
