import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitly_mission/presentation/screens/dashboard/detail_all_habit.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:habitly_mission/firebase_options.dart';
import 'package:habitly_mission/data/models/list_habit_hive.dart';
import 'package:habitly_mission/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:habitly_mission/presentation/screens/initiate_pages/dashboard_habit.dart';
import 'package:habitly_mission/presentation/screens/initiate_pages/dashboard_time.dart';
import 'package:habitly_mission/presentation/screens/login_screen.dart';
import 'package:habitly_mission/presentation/screens/register_screen.dart';
import 'package:habitly_mission/presentation/screens/dashboard/update_habit_screen.dart';
import 'presentation/screens/splash_screen.dart';
import 'package:hive_ce/hive_ce.dart';



final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
      navigatorKey: navigatorKey,
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
        DashboardScreen.routeName: (_) => const DashboardScreen(),
        UpdateHabitScreen.routeName: (_) => const UpdateHabitScreen(),
        DetailAllHabit.routeName: (_) => const DetailAllHabit(),
      },
    );
  }
}
