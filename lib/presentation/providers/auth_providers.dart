import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly_mission/datasources/auth_datasource.dart';
import 'package:habitly_mission/datasources/firebase_auth_datasource.dart';
import 'package:habitly_mission/domain/entities/app_user.dart';
import 'package:habitly_mission/domain/repositories/auth_repositories.dart';
import 'package:habitly_mission/presentation/providers/auth_notifier.dart';
import 'package:habitly_mission/repositories/auth_repo_impl.dart';


// 1 - Firebase Instance
final firebaseAuthProvider = Provider<FirebaseAuth>((ref){
  return FirebaseAuth.instance;
});

// 2 - Datasource
final authDataSourceAuthProvider = Provider<AuthDatasource>((ref){
return FirebaseAuthDatasource(ref.watch(firebaseAuthProvider));
});

// 3 - Repository
final authRepositoryProvider = Provider<AuthRepositories>((ref){
  return AuthRepoImpl(ref.watch(authDataSourceAuthProvider));
});

// 4 - Notifier (login/logout state/register)
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier,AppUser?>((){
  return AuthNotifier();
});

final currentUserProvider = Provider<AppUser?>((ref){
  final authState = ref.watch(authNotifierProvider);
  return authState.when(data: (user)=> user, error: (_,__)=>null, loading: ()=> null);
});

final currentUidProvider = Provider<String?>((ref){
  return ref.watch(currentUserProvider)?.id;
});