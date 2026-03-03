import 'package:habitly_mission/domain/entities/app_user.dart';
import 'package:habitly_mission/domain/entities/auth_credentials.dart';

abstract class AuthRepositories {
  Future<AppUser> login(AuthCredentials authcredentials);
  Future<AppUser> register (AuthCredentials authcredentials);
  Future<void> logout();
}