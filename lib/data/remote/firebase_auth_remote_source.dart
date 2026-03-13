import 'package:habitly_mission/data/remote/i_auth_remote_source.dart';
import 'package:habitly_mission/domain/entities/auth_credentials.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitly_mission/data/models/app_user_model.dart';

class AuthException implements Exception {
  final String code;
  final String message;

  AuthException(this.code, this.message);

  @override
  String toString() => message;
}


class FirebaseAuthRemoteSource implements IAuthRemoteSource{// this is when firebase get called and checking if the user exist
  final FirebaseAuth _auth;
  FirebaseAuthRemoteSource (this._auth);

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
