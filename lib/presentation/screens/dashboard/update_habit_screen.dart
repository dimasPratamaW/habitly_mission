import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly_mission/presentation/state/habit_providers.dart';

class UpdateHabitScreen extends ConsumerStatefulWidget {
  static const routeName = '/update_habit_screen';
  const UpdateHabitScreen({
    super.key,
  });

  @override
  ConsumerState<UpdateHabitScreen> createState() => _UpdateHabitScreenState();
}

class _UpdateHabitScreenState extends ConsumerState<UpdateHabitScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final pullData = ref.watch(habitStreamProvider(args['uid']!));
    final getHabitDetail = pullData.when(
      data: (choosenHabit) =>
          choosenHabit.firstWhere((h) => h.id == args['habitId']!),
      error: (err, stack) => null,
      loading: () => null,
    );
    return Scaffold(body: Column(children: [
      Text(getHabitDetail!.status),
      ]));
  }
}
