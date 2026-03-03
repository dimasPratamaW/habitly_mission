import 'package:habitly_mission/datasources/auth_datasource.dart';
import 'package:habitly_mission/domain/entities/auth_credentials.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitly_mission/models/app_user_model.dart';

class AuthException implements Exception {
  final String code;
  final String message;

  AuthException(this.code, this.message);

  @override
  String toString() => message; // ← shows readable message in snackbar
}


class FirebaseAuthDatasource implements AuthDatasource{
  final FirebaseAuth _auth;
  FirebaseAuthDatasource (this._auth);

  @override
  Future<AppUserModel> login (AuthCredentials credentials) async{
    try{
      if(credentials is EmailAuthCredentials){
        final userCredential = await _auth.signInWithEmailAndPassword(email: credentials.email, password: credentials.password);

        return AppUserModel.fromFirebaseUser(userCredential.user!);
      }
      throw UnsupportedError('unsupported credential type:${credentials.runtimeType}');
    }
    on FirebaseAuthException catch(e){
      throw AuthException(e.code, e.message ?? 'Register failed');
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<AppUserModel> register (AuthCredentials credentials)async {
    try{
      if(credentials is EmailAuthCredentials){
        final userCredential = await _auth.createUserWithEmailAndPassword(email: credentials.email, password: credentials.password);

        return AppUserModel.fromFirebaseUser(userCredential.user!);
      }
      throw UnsupportedError('unsupported credential type:${credentials.runtimeType}');
    }
    on FirebaseAuthException catch(e){
      throw AuthException(e.code, e.message ?? 'Register failed');
    }
  }
}
