import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitly_mission/main.dart';
import 'package:habitly_mission/presentation/screens/dashboard/add_habit_screen.dart';
import 'package:habitly_mission/presentation/state/auth_providers.dart';
import 'package:habitly_mission/presentation/state/habit_providers.dart';
import 'package:habitly_mission/data/remote/firestore_habit_remote_source.dart';
import 'package:habitly_mission/data/repositories/habit_repositories_implements.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
  });

  testWidgets('should show validation error when fields are empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUidProvider.overrideWith((ref) => 'test_user_1'),
          firestoreProvider.overrideWithValue(fakeFirestore),
          habitDatasourceProvider.overrideWith(
                (ref) => FirestoreHabitRemoteSource(fakeFirestore),
          ),
          habitRepositoryProvider.overrideWith(
                (ref) => HabitRepositoriesImplements(ref.watch(habitDatasourceProvider)),
          ),
        ],
        child: const MaterialApp(
          home: AddHabitScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // TAP save when fields are empty
    await tester.tap(find.text('Save habit'));
    await tester.pumpAndSettle();

    expect(find.text('cant be empty'), findsWidgets);
  });

  testWidgets("should save habit when field is filled", (WidgetTester tester) async{
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUidProvider.overrideWith((ref) => 'test_user_1'),
          firestoreProvider.overrideWithValue(fakeFirestore),
          habitDatasourceProvider.overrideWith(
                (ref) => FirestoreHabitRemoteSource(fakeFirestore),
          ),
          habitRepositoryProvider.overrideWith(
                (ref) => HabitRepositoriesImplements(ref.watch(habitDatasourceProvider)),
          ),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          home: const AddHabitScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    //INPUT Title & Description ----------------------------
    await tester.enterText(find.byType(TextFormField).at(0), "Lari Pagi 5 KM");
    await tester.enterText(find.byType(TextFormField).at(1), "lari pagi disekitar komplek");

    //Input Tanggal 20 pada kalendar
    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();
    await tester.tap(find.text("20"));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // TAP save
    await tester.tap(find.text('Save habit'));
    await tester.pumpAndSettle();

// ASSERT
    final snapshot = await fakeFirestore
        .collection('users')
        .doc('test_user_1')
        .collection('habits')
        .get();

    expect(snapshot.docs.first.data()['title'], 'Lari Pagi 5 KM');
    expect(snapshot.docs.first.data()['desc'], 'lari pagi disekitar komplek');
    expect(snapshot.docs.first.data()['status'], 'Upcoming');
    expect(snapshot.docs.first.data()['date'], isNot('original date'));

  });


}