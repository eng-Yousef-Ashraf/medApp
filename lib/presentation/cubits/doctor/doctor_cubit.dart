import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/domain/usecases/doctor_usecases.dart';
import 'package:my_flutter_app/presentation/cubits/doctor/doctor_state.dart';

class DoctorCubit extends Cubit<DoctorState> {
  final GetDoctorsUseCase getDoctorsUseCase;
  final GetDoctorsBySpecialtyUseCase getDoctorsBySpecialtyUseCase;
  final GetDoctorByIdUseCase getDoctorByIdUseCase;
  final SearchDoctorsUseCase searchDoctorsUseCase;

  DoctorCubit({
    required this.getDoctorsUseCase,
    required this.getDoctorsBySpecialtyUseCase,
    required this.getDoctorByIdUseCase,
    required this.searchDoctorsUseCase,
  }) : super(DoctorInitial());

  Future<void> loadDoctors() async {
    emit(DoctorLoading());
    try {
      final doctors = await getDoctorsUseCase();
      emit(DoctorLoaded(doctors: doctors));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> filterBySpecialty(String specialty) async {
    emit(DoctorLoading());
    try {
      final doctors = await getDoctorsBySpecialtyUseCase(specialty);
      emit(DoctorLoaded(doctors: doctors, selectedSpecialty: specialty));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> searchDoctors(String query) async {
    if (query.isEmpty) {
      loadDoctors();
      return;
    }
    emit(DoctorLoading());
    try {
      final doctors = await searchDoctorsUseCase(query);
      emit(DoctorLoaded(doctors: doctors));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> loadDoctorDetail(String id) async {
    emit(DoctorLoading());
    try {
      final doctor = await getDoctorByIdUseCase(id);
      emit(DoctorDetailLoaded(doctor));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }
}
