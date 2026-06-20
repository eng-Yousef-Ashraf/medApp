import 'package:my_flutter_app/data/datasources/local_data_source.dart';
import 'package:my_flutter_app/domain/entities/user.dart';
import 'package:my_flutter_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<AppUser> login(String email, String password) {
    return localDataSource.login(email, password);
  }

  @override
  Future<AppUser> register(String name, String email, String password) {
    return localDataSource.register(name, email, password);
  }

  @override
  Future<AppUser> loginWithGoogle() {
    return localDataSource.loginWithGoogle();
  }

  @override
  Future<void> logout() {
    return localDataSource.logout();
  }

  @override
  AppUser? getCurrentUser() {
    return localDataSource.getCurrentUser();
  }
}
