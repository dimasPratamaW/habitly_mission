
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitly_mission/data/models/app_user_model.dart';
import 'package:habitly_mission/data/remote/i_auth_remote_source.dart';
import 'package:habitly_mission/domain/entities/auth_credentials.dart';
import 'package:habitly_mission/main.dart';
import 'package:habitly_mission/presentation/screens/login_screen.dart';
import 'package:habitly_mission/presentation/screens/register_screen.dart';
import 'package:habitly_mission/presentation/state/auth_providers.dart';

class _FakeAuthRemoteSource implements IAuthRemoteSource{
  @override
  Future<AppUserModel> login(AuthCredentials credentials) async {
    return AppUserModel(id: 'testing_111', email: "testing2@gmail.com") ;
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<AppUserModel> register(AuthCredentials credentials) async {
    return AppUserModel(id: 'testing_111', email: "testing2@gmail.com") ;

  }

}


void main(){
  testWidgets('register success', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authDataSourceAuthProvider.overrideWithValue(_FakeAuthRemoteSource()),
        ],
        child: MaterialApp(
            navigatorKey: navigatorKey,
            home: const RegisterScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), "namaku");
    await tester.enterText(find.byType(TextFormField).at(1), "testing@gmail.com");
    await tester.enterText(find.byType(TextFormField).at(2), "123456");
    await tester.pump();
    await tester.enterText(find.byType(TextFormField).at(3), "123456");
    await tester.pump();
    await tester.pumpAndSettle();

    // TAP save when fields are empty
    await tester.ensureVisible(find.text('Register Account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Register Account'));
    await tester.pumpAndSettle();

    expect(find.text('Register Account'), findsNothing);
  });
}