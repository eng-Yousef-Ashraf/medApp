import 'package:my_flutter_app/data/datasources/local_data_source.dart';
import 'package:my_flutter_app/domain/entities/doctor.dart';
import 'package:my_flutter_app/domain/repositories/doctor_repository.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final LocalDataSource localDataSource;

  DoctorRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Doctor>> getDoctors() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return localDataSource.getDoctors();
  }

  @override
  Future<List<Doctor>> getDoctorsBySpecialty(String specialty) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final doctors = localDataSource.getDoctors();
    if (specialty == 'All') return doctors;
    return doctors.where((d) => d.specialty == specialty).toList();
  }

  @override
  Future<Doctor> getDoctorById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return localDataSource.getDoctors().firstWhere((d) => d.id == id);
  }

  @override
  Future<List<Doctor>> searchDoctors(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final lowerQuery = query.toLowerCase();
    return localDataSource.getDoctors().where((d) =>
      d.name.toLowerCase().contains(lowerQuery) ||
      d.specialty.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}
