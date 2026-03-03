abstract class AuthCredentials {
  const AuthCredentials();
}

class EmailAuthCredentials extends AuthCredentials {
  final String email;
  final String password;

  const EmailAuthCredentials({
    required this.email,
    required this.password,
  });
}