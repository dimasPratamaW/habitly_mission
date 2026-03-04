import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:habitly_mission/presentation/screens/dashboard/add_habit_screen.dart';
import 'package:habitly_mission/presentation/screens/dashboard/habit_schedule_screen.dart';
import 'package:habitly_mission/presentation/screens/dashboard/account_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  static const routeName = '/main_dashboard';

  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int currentPages = 0;

  List<Widget> pagesWidget() {
    return [
      HabitScheduleScreen(),
      AddHabitScreen(),
      AccountScreen()

    ];
  }

  final List<Widget> _titles = [
    Text(
      DateFormat("MMMM dd").format(DateTime.now()),
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    const Text(
      'Add New Habit',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    const Text(
      'Account',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(child: Text("Today")),
        title: Center(
          child: _titles[currentPages]
        ),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.account_circle))
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPages,
        onDestinationSelected: (int index) {
          setState(() {
            currentPages = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined, size: 20),
            label: 'home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline_rounded, size: 40),
            label: 'Add Habit',
          ),
          NavigationDestination(
            icon: Icon(Icons.person, size: 20),
            label: 'account',
          ),
        ],
      ),
      body: IndexedStack(
          index: currentPages, children: pagesWidget()),
    );
  }
}
