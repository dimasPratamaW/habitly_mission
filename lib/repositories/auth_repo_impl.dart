import 'package:habitly_mission/datasources/auth_datasource.dart';
import 'package:habitly_mission/domain/entities/app_user.dart';
import 'package:habitly_mission/domain/entities/auth_credentials.dart';
import 'package:habitly_mission/domain/repositories/auth_repositories.dart';

class AuthRepoImpl implements AuthRepositories{
  final AuthDatasource _datasource;
  AuthRepoImpl(this._datasource);

  @override
  Future<AppUser> login(AuthCredentials authcredentials) async {
    // TODO: implement login
    final model = await _datasource.login(authcredentials);

    return model;
  }

  @override
  Future<void> logout() async {
    await _datasource.logout();
  }

  @override
  Future<AppUser> register(AuthCredentials authcredentials)async {
    // TODO: implement register
    final model = await _datasource.register(authcredentials);

    return model;
  }
}