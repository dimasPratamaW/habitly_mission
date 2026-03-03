import 'package:habitly_mission/domain/entities/auth_credentials.dart';
import 'package:habitly_mission/models/app_user_model.dart';

abstract class AuthDatasource {
  Future<AppUserModel> login (AuthCredentials credentials);
  Future<AppUserModel> register (AuthCredentials credentials);
  Future<void> logout();
}