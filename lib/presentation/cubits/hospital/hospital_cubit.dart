import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/domain/usecases/hospital_usecases.dart';
import 'package:my_flutter_app/presentation/cubits/hospital/hospital_state.dart';

class HospitalCubit extends Cubit<HospitalState> {
  final GetHospitalsUseCase getHospitalsUseCase;
  final GetNearbyHospitalsUseCase getNearbyHospitalsUseCase;

  HospitalCubit({
    required this.getHospitalsUseCase,
    required this.getNearbyHospitalsUseCase,
  }) : super(HospitalInitial());

  Future<void> loadHospitals() async {
    emit(HospitalLoading());
    try {
      final hospitals = await getHospitalsUseCase();
      emit(HospitalLoaded(hospitals));
    } catch (e) {
      emit(HospitalError(e.toString()));
    }
  }

  Future<void> loadNearbyHospitals() async {
    emit(HospitalLoading());
    try {
      final hospitals = await getNearbyHospitalsUseCase();
      emit(HospitalLoaded(hospitals));
    } catch (e) {
      emit(HospitalError(e.toString()));
    }
  }
}
