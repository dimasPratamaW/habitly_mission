import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:habitly_mission/data/models/list_habit_hive.dart';
import 'package:habitly_mission/presentation/state/auth_providers.dart';
import 'package:habitly_mission/presentation/state/habit_providers.dart';
import 'package:habitly_mission/style/app_color.dart';

class HabitScheduleScreen extends ConsumerStatefulWidget {
  static const routeName = '/dashboard_schedule';

  const HabitScheduleScreen({super.key});

  @override
  ConsumerState<HabitScheduleScreen> createState() => _HabitScheduleScreenState();
}

class _HabitScheduleScreenState extends ConsumerState<HabitScheduleScreen> {
  static const List<Map<String, String>> days = [
    {'letter': 'M', 'number': '1'},
    {'letter': 'T', 'number': '2'},
    {'letter': 'W', 'number': '3'},
    {'letter': 'T', 'number': '4'},
    {'letter': 'F', 'number': '5'},
    {'letter': 'S', 'number': '6'},
    {'letter': 'S', 'number': '7'},
  ];

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(currentUidProvider); // ← get uid
    final colors = AppColors.of(context);

    final sortOption = ref.watch(habitSortProvider);
    final filterOption = ref.watch(habitFilterProvider);

    if (uid == null) return const Center(child: CircularProgressIndicator());

    final pullData = ref.watch(habitStreamProvider(uid));
    // final pullData = ref.watch(habitListProvider);// this is for hive
    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          SizedBox(
            // tanggal diatas
            height: 80,
            child: Padding(
              padding: EdgeInsetsGeometry.directional(start: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index];
                  return SizedBox(
                    width: 50,
                    child: Column(
                      children: [
                        Text(day['letter']!),
                        SizedBox(height: 10),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Text(day['number']!)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //SORT BUTTON
              Column(
                children:[
                  SizedBox(height: 5,),
                  Text('Sort by Date'),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 16,vertical: 10),
                    child: Container(
                      decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color:colors.border)
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<HabitSort>(
                          value: ref.watch(habitSortProvider),
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 5),
                          items: const [
                            DropdownMenuItem(value: HabitSort.dateNewest, child: Text('Newest')),
                            DropdownMenuItem(value: HabitSort.dateOldest, child: Text('Oldest')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              ref.read(habitSortProvider.notifier).state = value;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //FILTER BUTTON
              Column(
                children:[
                  SizedBox(height: 5,),
                  Text('Filter by Status'),
                  Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 16,vertical: 10),
                  child: Container(
                    decoration:BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color:colors.border)
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<HabitFilter>(
                        value: ref.watch(habitFilterProvider),
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 5),
                        items: const [
                          DropdownMenuItem(
                            value: HabitFilter.all,
                            child: Text('All'),
                          ),
                          DropdownMenuItem(
                            value: HabitFilter.upcoming,
                            child: Text('Upcoming'),
                          ),
                          DropdownMenuItem(
                            value: HabitFilter.ongoing,
                            child: Text('Ongoing'),
                          ),
                          DropdownMenuItem(
                            value: HabitFilter.completed,
                            child: Text('Completed'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(habitFilterProvider.notifier).state = value;
                          }
                        },
                      ),
                    ),
                  ),
                ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            // text title my Habit
            padding: EdgeInsetsGeometry.directional(start: 10),
            child: Text(
              'My Habit',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: pullData.when(
              // used the data FROM pullData
              data: (activities) {
                //FOR FILTER
                var filtered = activities.where((habit) {
                  switch (filterOption) {
                    case HabitFilter.all:
                      return true;
                    case HabitFilter.upcoming:
                      return habit.status == 'Upcoming';
                    case HabitFilter.ongoing:
                      return habit.status == 'Ongoing';
                    case HabitFilter.completed:
                      return habit.status == 'Completed';
                  }
                }).toList();

                switch (sortOption) {
                  case HabitSort.dateNewest:
                    filtered.sort((a, b) {
                      final dateA = DateFormat('dd/MM/yyyy').parse(a.date);
                      final dateB = DateFormat('dd/MM/yyyy').parse(b.date);
                      return dateB.compareTo(dateA);
                    });
                    break;
                  case HabitSort.dateOldest:
                    filtered.sort((a, b) {
                      final dateA = DateFormat('dd/MM/yyyy').parse(a.date);
                      final dateB = DateFormat('dd/MM/yyyy').parse(b.date);
                      return dateA.compareTo(dateB);
                    });
                    break;
                }

                if (filtered.isEmpty) {
                  return const Center(child: Text("No habits yet"));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(habitStreamProvider(uid));
                  },
                  child: Padding(
                    padding: const EdgeInsetsGeometry.symmetric(horizontal: 30),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final activity = filtered[index];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                          width: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  Text('${activity.date} - ${activity.time}'),
                                  SizedBox(height: 5),
                                  Text(
                                    activity.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(activity.desc),
                                  SizedBox(height: 10),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('Status : ${activity.status}'),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (!context.mounted) return;
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text("CAREFUL 🙏"),
                                          content: Text(
                                            "this ${activity.title} habit will be deleted, are you really sure?",
                                          ),
                                          actionsPadding:
                                          EdgeInsetsDirectional.symmetric(
                                            horizontal: 10,
                                            vertical: 10,
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(0xFFF5F5F5),
                                              ),
                                              onPressed: () {
                                                ref
                                                    .read(
                                                  habitNotifierProvider
                                                      .notifier,
                                                )
                                                    .deleteHabit(uid, activity.id);
                                                Navigator.pop(context);
                                              },
                                              child: const Text("YES"),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text(
                                                "NO",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Icon(Icons.delete_forever),
                                  ),
                                ]
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  const Center(child: Text('ERROR please ask developer')),
            ),
          ),
        ],
      ),
    );
  }
}
