import 'package:equatable/equatable.dart';
import 'package:my_flutter_app/domain/entities/doctor.dart';

abstract class DoctorState extends Equatable {
  const DoctorState();
  @override
  List<Object?> get props => [];
}

class DoctorInitial extends DoctorState {}

class DoctorLoading extends DoctorState {}

class DoctorLoaded extends DoctorState {
  final List<Doctor> doctors;
  final String selectedSpecialty;

  const DoctorLoaded({required this.doctors, this.selectedSpecialty = 'All'});

  @override
  List<Object?> get props => [doctors, selectedSpecialty];
}

class DoctorDetailLoaded extends DoctorState {
  final Doctor doctor;
  const DoctorDetailLoaded(this.doctor);
  @override
  List<Object?> get props => [doctor];
}

class DoctorError extends DoctorState {
  final String message;
  const DoctorError(this.message);
  @override
  List<Object?> get props => [message];
}
