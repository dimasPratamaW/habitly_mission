import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitly_mission/data/models/app_user_model.dart';
import 'package:habitly_mission/data/remote/i_auth_remote_source.dart';
import 'package:habitly_mission/domain/entities/auth_credentials.dart';
import 'package:habitly_mission/main.dart';
import 'package:habitly_mission/presentation/screens/initiate_pages/dashboard_habit.dart';
import 'package:habitly_mission/presentation/screens/login_screen.dart';
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
  Future<AppUserModel> register(AuthCredentials credentials) {
    // TODO: implement register
    throw UnimplementedError();
  }

}


void main() {
  testWidgets('showing validation if textbox is empty',( WidgetTester tester) async{
    await tester.pumpWidget(
      ProviderScope(
        // 🤔 do you need overrides here for a validation test?
        child: MaterialApp(
          home: const LoginScreen(),
        ),
      ),
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Email cannot be empty'),findsWidgets);
    expect(find.text( 'Password cannot be empty'), findsOneWidget);
  });

  testWidgets('showing validation if email input is wrong format', ( WidgetTester tester) async{
    await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authDataSourceAuthProvider.overrideWithValue(_FakeAuthRemoteSource()),
          ],
          child: MaterialApp(
              navigatorKey: navigatorKey,
              home: const LoginScreen(),
              // routes: {
              //   DashboardHabit.routeName: (context) => const DashboardHabit(),
              // }
              ),
        )
    );
    await tester.enterText(find.byType(TextFormField).at(0), "testing2gmail.com");
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email address'),findsWidgets);
  });

  testWidgets('login success in valid text', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authDataSourceAuthProvider.overrideWithValue(_FakeAuthRemoteSource()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          home: const LoginScreen(),
          routes: {
            DashboardHabit.routeName: (context) => const DashboardHabit(),
          }),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), "testing2@gmail.com");
    await tester.enterText(find.byType(TextFormField).at(1), "123456");

    // TAP save when fields are empty
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.byType(DashboardHabit),findsOneWidget);
  });


}