import 'package:habitly_mission/screen/controller/user_credentials.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserController extends Notifier<List<UserCredentials>> {
  @override
  List<UserCredentials> build() {
   return[UserCredentials(email: 'a@gmail.com', password: '123456')];
  }

  void addUser(Map<String,String> userData){
    final newUser = UserCredentials.fromMap(userData);
    state = [...state,newUser];// this is the way to updating a list we have.
  }


}

final userProvider = NotifierProvider<UserController, List<UserCredentials>>(
  UserController.new,
);
