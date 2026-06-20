import 'package:my_flutter_app/domain/entities/user.dart';

abstract class AuthRepository {
  Future<AppUser> login(String email, String password);
  Future<AppUser> register(String name, String email, String password);
  Future<AppUser> loginWithGoogle();
  Future<void> logout();
  AppUser? getCurrentUser();
}
