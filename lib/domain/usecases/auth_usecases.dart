import 'package:my_flutter_app/domain/entities/user.dart';
import 'package:my_flutter_app/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);
  Future<AppUser> call(String email, String password) => repository.login(email, password);
}

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);
  Future<AppUser> call(String name, String email, String password) => repository.register(name, email, password);
}

class LoginWithGoogleUseCase {
  final AuthRepository repository;
  LoginWithGoogleUseCase(this.repository);
  Future<AppUser> call() => repository.loginWithGoogle();
}

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);
  Future<void> call() => repository.logout();
}

class GetCurrentUserUseCase {
  final AuthRepository repository;
  GetCurrentUserUseCase(this.repository);
  AppUser? call() => repository.getCurrentUser();
}
