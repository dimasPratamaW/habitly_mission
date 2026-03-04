import 'package:habitly_mission/domain/entities/user_entity.dart';
import 'package:habitly_mission/domain/entities/auth_credentials.dart';

abstract class IAuthRepositories {
  Future<UserEntity> login(AuthCredentials authcredentials);
  Future<UserEntity> register (AuthCredentials authcredentials);
  Future<void> logout();
}