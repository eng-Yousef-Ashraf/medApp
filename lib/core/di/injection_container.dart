import 'package:get_it/get_it.dart';
import 'package:my_flutter_app/data/datasources/local_data_source.dart';
import 'package:my_flutter_app/data/repositories/auth_repository_impl.dart';
import 'package:my_flutter_app/data/repositories/booking_repository_impl.dart';
import 'package:my_flutter_app/data/repositories/chat_repository_impl.dart';
import 'package:my_flutter_app/data/repositories/doctor_repository_impl.dart';
import 'package:my_flutter_app/data/repositories/hospital_repository_impl.dart';
import 'package:my_flutter_app/domain/repositories/auth_repository.dart';
import 'package:my_flutter_app/domain/repositories/booking_repository.dart';
import 'package:my_flutter_app/domain/repositories/chat_repository.dart';
import 'package:my_flutter_app/domain/repositories/doctor_repository.dart';
import 'package:my_flutter_app/domain/repositories/hospital_repository.dart';
import 'package:my_flutter_app/domain/usecases/auth_usecases.dart';
import 'package:my_flutter_app/domain/usecases/booking_usecases.dart';
import 'package:my_flutter_app/domain/usecases/chat_usecases.dart';
import 'package:my_flutter_app/domain/usecases/doctor_usecases.dart';
import 'package:my_flutter_app/domain/usecases/hospital_usecases.dart';
import 'package:my_flutter_app/presentation/cubits/auth/auth_cubit.dart';
import 'package:my_flutter_app/presentation/cubits/booking/booking_cubit.dart';
import 'package:my_flutter_app/presentation/cubits/chat/chat_cubit.dart';
import 'package:my_flutter_app/presentation/cubits/doctor/doctor_cubit.dart';
import 'package:my_flutter_app/presentation/cubits/hospital/hospital_cubit.dart';
import 'package:my_flutter_app/presentation/cubits/navigation/navigation_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Data Sources ──
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSource());

  // ── Repositories ──
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<DoctorRepository>(
    () => DoctorRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<HospitalRepository>(
    () => HospitalRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(),
  );

  // ── Use Cases ──
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  sl.registerLazySingleton(() => GetDoctorsUseCase(sl()));
  sl.registerLazySingleton(() => GetDoctorsBySpecialtyUseCase(sl()));
  sl.registerLazySingleton(() => GetDoctorByIdUseCase(sl()));
  sl.registerLazySingleton(() => SearchDoctorsUseCase(sl()));

  sl.registerLazySingleton(() => GetHospitalsUseCase(sl()));
  sl.registerLazySingleton(() => GetNearbyHospitalsUseCase(sl()));

  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => GetChatHistoryUseCase(sl()));
  sl.registerLazySingleton(() => ClearChatHistoryUseCase(sl()));

  sl.registerLazySingleton(() => CreateBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetBookingsUseCase(sl()));
  sl.registerLazySingleton(() => CancelBookingUseCase(sl()));

  // ── Cubits ──
  sl.registerFactory(() => AuthCubit(
    loginUseCase: sl(),
    registerUseCase: sl(),
    loginWithGoogleUseCase: sl(),
    logoutUseCase: sl(),
    getCurrentUserUseCase: sl(),
  ));

  sl.registerFactory(() => ChatCubit(
    sendMessageUseCase: sl(),
    getChatHistoryUseCase: sl(),
    clearChatHistoryUseCase: sl(),
  ));

  sl.registerFactory(() => DoctorCubit(
    getDoctorsUseCase: sl(),
    getDoctorsBySpecialtyUseCase: sl(),
    getDoctorByIdUseCase: sl(),
    searchDoctorsUseCase: sl(),
  ));

  sl.registerFactory(() => HospitalCubit(
    getHospitalsUseCase: sl(),
    getNearbyHospitalsUseCase: sl(),
  ));

  sl.registerFactory(() => BookingCubit(
    createBookingUseCase: sl(),
    getBookingsUseCase: sl(),
    cancelBookingUseCase: sl(),
  ));

  sl.registerFactory(() => NavigationCubit());
}
