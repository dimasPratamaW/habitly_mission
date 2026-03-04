import 'package:flutter/material.dart';
import 'package:habitly_mission/presentation/screens/initiate_pages/dashboard_time.dart';
import 'package:habitly_mission/style/app_color.dart';

class DashboardHabit extends StatelessWidget {
  static const routeName = '/dashboard_habit';


  const DashboardHabit({super.key});

  final List<Map<String, dynamic>> listHabit = const [
    {
      'habit': 'taking picture',
      'icon': Icons.camera_alt_rounded,
    },
    {'habit': 'Exercise', 'icon': Icons.nordic_walking},
    {'habit': 'Reading', 'icon': Icons.book},
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          const Text('What habit you want to do?'),
          const SizedBox(height: 10),
          const Text('Select One'),
          const SizedBox(height: 16),

          // ⚠️ IMPORTANT
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: listHabit.length,
              itemBuilder: (context, index) {
                final habit = listHabit[index];

                return Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        DashboardTime.routeName,
                        arguments: {'title' :habit['habit']}
                      );
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(habit['icon'], size: 60,),
                          Text(habit['habit'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),

                        ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
