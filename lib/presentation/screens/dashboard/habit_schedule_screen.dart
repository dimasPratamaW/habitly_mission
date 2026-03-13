import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly_mission/presentation/screens/dashboard/detail_all_habit.dart';
import 'package:habitly_mission/presentation/screens/dashboard/update_habit_screen.dart';
import 'package:habitly_mission/widget/custom_dialog.dart';
import 'package:intl/intl.dart';
import 'package:habitly_mission/presentation/state/auth_providers.dart';
import 'package:habitly_mission/presentation/state/habit_providers.dart';
import 'package:habitly_mission/style/app_color.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitScheduleScreen extends ConsumerStatefulWidget {
  static const routeName = '/habit_schedule_screen';

  const HabitScheduleScreen({super.key});

  @override
  ConsumerState<HabitScheduleScreen> createState() =>
      _HabitScheduleScreenState();
}

class _HabitScheduleScreenState extends ConsumerState<HabitScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  bool _showAll = true;

  Widget _calendarTable(List activities) {
    final total = activities.length;
    final completed =
        activities.where((h) => h.status == 'Completed').length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Row(// ← reset button above calendar
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, DetailAllHabit.routeName);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$completed / $total completed',
                        style:
                        const TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: total == 0 ? 0 : completed / total,
                        backgroundColor: Colors.grey.shade300,
                        color: Colors.blue,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'click here for the detail ...',
                            style:
                            const TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => setState(() => _showAll = true),
                icon: const Icon(Icons.filter_alt_off, size: 16),
                label: Text(
                  _showAll ? 'Showing All' : 'Show All',
                  style: TextStyle(
                    color: _showAll ? Colors.grey : Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2025, 1, 1),
            lastDay: DateTime.utc(2030, 1, 1),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) => setState(() => _calendarFormat = format),
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.week: 'Week',
            },
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                _selectedDay = selectedDay;
                _showAll = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _sortButton(dynamic colors){
    return Column(
      children: [
        SizedBox(height: 5),
        Text('Sort by Date'),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<HabitSort>(
                value: ref.watch(habitSortProvider),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                items: const [
                  DropdownMenuItem(
                    value: HabitSort.dateNewest,
                    child: Text('Newest'),
                  ),
                  DropdownMenuItem(
                    value: HabitSort.dateOldest,
                    child: Text('Oldest'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(habitSortProvider.notifier).state =
                        value;
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _filterButton(dynamic colors){
    return Column(
      children: [
        SizedBox(height: 5),
        Text('Filter by Status'),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<HabitFilter>(
                value: ref.watch(habitFilterProvider),
                padding: const EdgeInsets.symmetric(horizontal: 5),
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
                    ref.read(habitFilterProvider.notifier).state =
                        value;
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(currentUidProvider); // ← get uid
    final colors = AppColors.of(context);
    final sortOption = ref.watch(habitSortProvider);
    final filterOption = ref.watch(habitFilterProvider);
    final selectedDateStr = DateFormat("dd/MM/yyyy").format(_selectedDay);

    if (uid == null) return const Center(child: CircularProgressIndicator());

    final pullData = ref.watch(habitStreamProvider(uid));
    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pullData.when(
            data: (activities) => _calendarTable(activities),
            loading: () => _calendarTable([]),
            error: (_, __) => _calendarTable([]),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //SORT BUTTON
              _sortButton(colors),
              //FILTER BUTTON
              _filterButton(colors)
            ],
          ),
          SizedBox(height: 10),
          Padding(
            // text title my Habit
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  if (!_showAll && habit.date != selectedDateStr) {
                    return false;
                  }
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
                              Expanded(
                                child: InkWell(
                                onTap:(){
                                  Navigator.pushNamed(context,UpdateHabitScreen.routeName,arguments: {
                                    'uid':uid, 'habitId':activity.id
                                  });
                                },
                                  child: Column(
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
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                                backgroundColor: Color(
                                                  0xFFF5F5F5,
                                                ),
                                              ),
                                              onPressed: () {
                                                ref
                                                    .read(
                                                      habitNotifierProvider
                                                          .notifier,
                                                    )
                                                    .deleteHabit(
                                                      uid,
                                                      activity.id,
                                                    );
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
                                ],
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
