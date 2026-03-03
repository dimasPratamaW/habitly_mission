import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:habitly_mission/firebase_options.dart';
import 'package:habitly_mission/models/list_habit_hive.dart';
import 'package:habitly_mission/screen/dashboard/main_dashboard.dart';
import 'package:habitly_mission/screen/initiate_pages/dashboard_habit.dart';
import 'package:habitly_mission/screen/initiate_pages/dashboard_time.dart';
import 'package:habitly_mission/screen/login.dart';
import 'package:habitly_mission/screen/register.dart';
import 'screen/splash_screen.dart';
import 'package:hive_ce/hive_ce.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ListHabitHiveAdapter());

  await Hive.openBox<ListHabitHive>('list_habit');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(

      const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme:ThemeData(
          brightness: Brightness.dark,
          textTheme: GoogleFonts.urbanistTextTheme(Theme.of(context).textTheme)) ,
      theme: ThemeData(
          brightness: Brightness.light,
          textTheme: GoogleFonts.urbanistTextTheme(Theme.of(context).textTheme)),
      themeMode: ThemeMode.system,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterView.routeName: (_) => const RegisterScreen(),
        DashboardHabit.routeName: (_) => const DashboardHabit(),
        DashboardTime.routeName: (_) => const DashboardTime(),
        MainDashboard.routeName: (_) => const MainDashboard()
      },
    );
  }
}
