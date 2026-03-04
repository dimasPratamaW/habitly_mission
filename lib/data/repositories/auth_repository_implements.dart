import 'package:habitly_mission/data/remote/i_auth_remote_source.dart';
import 'package:habitly_mission/domain/entities/user_entity.dart';
import 'package:habitly_mission/domain/entities/auth_credentials.dart';
import 'package:habitly_mission/domain/repositories/i_auth_repositories.dart';

class AuthRepositoryImplements implements IAuthRepositories{
  final IAuthRemoteSource _datasource;
  AuthRepositoryImplements(this._datasource);

  @override
  Future<UserEntity> login(AuthCredentials authcredentials) async {
    // TODO: implement login
    final model = await _datasource.login(authcredentials);

    return model;
  }

  @override
  Future<void> logout() async {
    await _datasource.logout();
  }

  @override
  Future<UserEntity> register(AuthCredentials authcredentials)async {
    // TODO: implement register
    final model = await _datasource.register(authcredentials);

    return model;
  }
}