import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly_mission/domain/entities/habit_entity.dart';
import 'package:habitly_mission/data/models/habit_model.dart';
import 'package:habitly_mission/presentation/state/habit_providers.dart';

class HabitStateNotifier extends AsyncNotifier<List<HabitEntity>> {
  @override
  Future<List<HabitModel>> build() async => [];

  Future<void> addHabit({
    required String title,
    required String desc,
    required String time,
    required String date,
    required String status,
    required String uid,

  }) async {
    final habit = HabitEntity(
      id: '${DateTime.now()}/$uid',
      title: title,
      desc: desc,
      time: time,
      date: date,
      status: status,
      uid: uid,
    );

    await ref.read(habitRepositoryProvider).addHabit(habit);
  }

  Future<void>deleteHabit(String uid, String habitId) async{
    await ref.read(habitRepositoryProvider).deleteHabit(uid, habitId);
  }
}
