import 'package:my_flutter_app/domain/entities/doctor.dart';

abstract class DoctorRepository {
  Future<List<Doctor>> getDoctors();
  Future<List<Doctor>> getDoctorsBySpecialty(String specialty);
  Future<Doctor> getDoctorById(String id);
  Future<List<Doctor>> searchDoctors(String query);
}
