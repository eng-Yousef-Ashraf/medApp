import 'package:my_flutter_app/domain/entities/hospital.dart';
import 'package:my_flutter_app/domain/repositories/hospital_repository.dart';

class GetHospitalsUseCase {
  final HospitalRepository repository;
  GetHospitalsUseCase(this.repository);
  Future<List<Hospital>> call() => repository.getHospitals();
}

class GetNearbyHospitalsUseCase {
  final HospitalRepository repository;
  GetNearbyHospitalsUseCase(this.repository);
  Future<List<Hospital>> call() => repository.getNearbyHospitals();
}
