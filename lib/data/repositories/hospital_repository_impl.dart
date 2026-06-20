import 'package:my_flutter_app/data/datasources/local_data_source.dart';
import 'package:my_flutter_app/domain/entities/hospital.dart';
import 'package:my_flutter_app/domain/repositories/hospital_repository.dart';

class HospitalRepositoryImpl implements HospitalRepository {
  final LocalDataSource localDataSource;

  HospitalRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Hospital>> getHospitals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return localDataSource.getHospitals();
  }

  @override
  Future<List<Hospital>> getNearbyHospitals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final hospitals = localDataSource.getHospitals();
    hospitals.sort((a, b) => a.distance.compareTo(b.distance));
    return hospitals;
  }
}
