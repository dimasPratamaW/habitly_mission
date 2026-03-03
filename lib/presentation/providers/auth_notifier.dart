import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly_mission/domain/entities/app_user.dart';
import 'package:habitly_mission/domain/entities/auth_credentials.dart';
import 'package:habitly_mission/presentation/providers/auth_providers.dart';

import '../../models/app_user_model.dart';

class AuthNotifier extends AsyncNotifier<AppUser?>{

  @override
  Future<AppUser?> build() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      return AppUserModel.fromFirebaseUser(firebaseUser);
    }
    return null;
  }

  Future<void> login(AuthCredentials credentials) async{
    state = const AsyncLoading();
    try {
      final user = await ref.read(authRepositoryProvider).login(credentials);
      state = AsyncData(user);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> register (AuthCredentials credentials) async{
    state = const AsyncLoading();
    try {
      final user = await ref.read(authRepositoryProvider).register(credentials);
      state = AsyncData(user);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }



  Future<void> logout() async{
    state = const AsyncLoading();
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }


}