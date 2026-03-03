class UserCredentials {
  final String email;
  final String password;

  const UserCredentials({required this.email, required this.password});

  factory UserCredentials.fromMap(Map<String, String> map){
    return UserCredentials(email: map['username']??'', password: map['password']??'');
  }


}