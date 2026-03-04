import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly_mission/data/remote/i_auth_remote_source.dart';
import 'package:habitly_mission/data/remote/firebase_auth_remote_source.dart';
import 'package:habitly_mission/domain/entities/user_entity.dart';
import 'package:habitly_mission/domain/repositories/i_auth_repositories.dart';
import 'package:habitly_mission/presentation/state/auth_state_notifier.dart';
import 'package:habitly_mission/data/repositories/auth_repository_implements.dart';


// 1 - Firebase Instance
final firebaseAuthProvider = Provider<FirebaseAuth>((ref){
  return FirebaseAuth.instance;
});

// 2 - Datasource
final authDataSourceAuthProvider = Provider<IAuthRemoteSource>((ref){
return FirebaseAuthRemoteSource(ref.watch(firebaseAuthProvider));
});

// 3 - Repository
final authRepositoryProvider = Provider<IAuthRepositories>((ref){
  return AuthRepositoryImplements(ref.watch(authDataSourceAuthProvider));
});

// 4 - Notifier (login/logout state/register)
final authNotifierProvider = AsyncNotifierProvider<AuthStateNotifier,UserEntity?>((){
  return AuthStateNotifier();
});

final currentUserProvider = Provider<UserEntity?>((ref){
  final authState = ref.watch(authNotifierProvider);
  return authState.when(data: (user)=> user, error: (_,__)=>null, loading: ()=> null);
});

final currentUidProvider = Provider<String?>((ref){
  return ref.watch(currentUserProvider)?.id;
});