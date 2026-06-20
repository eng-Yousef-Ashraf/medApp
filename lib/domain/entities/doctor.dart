import 'package:equatable/equatable.dart';

class Doctor extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final String bio;
  final String address;
  final String phone;
  final String imageUrl;
  final List<String> availableSlots;
  final String education;
  final int experienceYears;
  final List<String> languages;
  final List<DoctorReview> reviews;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.bio,
    required this.address,
    required this.phone,
    required this.imageUrl,
    required this.availableSlots,
    required this.education,
    required this.experienceYears,
    required this.languages,
    required this.reviews,
  });

  @override
  List<Object?> get props => [id];
}

class DoctorReview extends Equatable {
  final String id;
  final String patientName;
  final double rating;
  final String comment;
  final DateTime date;

  const DoctorReview({
    required this.id,
    required this.patientName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  List<Object?> get props => [id];
}
