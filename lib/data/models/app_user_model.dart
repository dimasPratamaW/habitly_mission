import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../domain/entities/user_entity.dart';

class AppUserModel extends UserEntity {
  const AppUserModel({
    required super.id,
    required super.email,
    super.displayName,
  });

  static AppUserModel fromFirebaseUser(fb.User user) {
    return AppUserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  factory AppUserModel.fromMap(Map<String, dynamic> data, String id) {
    return AppUserModel(
      id: id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String?,
    );
  }
}
