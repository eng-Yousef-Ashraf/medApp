import 'package:my_flutter_app/domain/entities/doctor.dart';
import 'package:my_flutter_app/domain/repositories/doctor_repository.dart';

class GetDoctorsUseCase {
  final DoctorRepository repository;
  GetDoctorsUseCase(this.repository);
  Future<List<Doctor>> call() => repository.getDoctors();
}

class GetDoctorsBySpecialtyUseCase {
  final DoctorRepository repository;
  GetDoctorsBySpecialtyUseCase(this.repository);
  Future<List<Doctor>> call(String specialty) => repository.getDoctorsBySpecialty(specialty);
}

class GetDoctorByIdUseCase {
  final DoctorRepository repository;
  GetDoctorByIdUseCase(this.repository);
  Future<Doctor> call(String id) => repository.getDoctorById(id);
}

class SearchDoctorsUseCase {
  final DoctorRepository repository;
  SearchDoctorsUseCase(this.repository);
  Future<List<Doctor>> call(String query) => repository.searchDoctors(query);
}
