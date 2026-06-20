import 'package:my_flutter_app/domain/entities/hospital.dart';

abstract class HospitalRepository {
  Future<List<Hospital>> getHospitals();
  Future<List<Hospital>> getNearbyHospitals();
}
