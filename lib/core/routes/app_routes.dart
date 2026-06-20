import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/core/di/injection_container.dart';
import 'package:my_flutter_app/domain/entities/doctor.dart';
import 'package:my_flutter_app/presentation/cubits/booking/booking_cubit.dart';
import 'package:my_flutter_app/presentation/cubits/doctor/doctor_cubit.dart';
import 'package:my_flutter_app/presentation/cubits/hospital/hospital_cubit.dart';
import 'package:my_flutter_app/presentation/screens/auth/login_screen.dart';
import 'package:my_flutter_app/presentation/screens/auth/register_screen.dart';
import 'package:my_flutter_app/presentation/screens/booking/booking_screen.dart';
import 'package:my_flutter_app/presentation/screens/chat/chat_screen.dart';
import 'package:my_flutter_app/presentation/screens/doctors/doctor_detail_screen.dart';
import 'package:my_flutter_app/presentation/screens/doctors/doctors_screen.dart';
import 'package:my_flutter_app/presentation/screens/home/home_screen.dart';
import 'package:my_flutter_app/presentation/screens/hospitals/hospitals_screen.dart';
import 'package:my_flutter_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:my_flutter_app/presentation/screens/profile/profile_screen.dart';
import 'package:my_flutter_app/presentation/screens/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String chat = '/chat';
  static const String doctors = '/doctors';
  static const String doctorDetail = '/doctor-detail';
  static const String hospitals = '/hospitals';
  static const String booking = '/booking';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _fadeRoute(const SplashScreen());
      case onboarding:
        return _fadeRoute(const OnboardingScreen());
      case login:
        return _fadeRoute(const LoginScreen());
      case register:
        return _fadeRoute(const RegisterScreen());
      case home:
        return _fadeRoute(const HomeScreen());
      case chat:
        return _slideRoute(const ChatScreen());
      case doctors:
        return _slideRoute(
          BlocProvider(
            create: (_) => sl<DoctorCubit>()..loadDoctors(),
            child: const DoctorsScreen(),
          ),
        );
      case doctorDetail:
        final doctor = settings.arguments as Doctor;
        return _slideRoute(DoctorDetailScreen(doctor: doctor));
      case hospitals:
        return _slideRoute(
          BlocProvider(
            create: (_) => sl<HospitalCubit>()..loadHospitals(),
            child: const HospitalsScreen(),
          ),
        );
      case booking:
        final doctor = settings.arguments as Doctor?;
        return _slideRoute(
          BlocProvider(
            create: (_) => sl<BookingCubit>(),
            child: BookingScreen(preselectedDoctor: doctor),
          ),
        );
      case profile:
        return _slideRoute(const ProfileScreen());
      default:
        return _fadeRoute(const SplashScreen());
    }
  }

  static PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}
