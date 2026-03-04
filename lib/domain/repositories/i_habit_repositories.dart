import 'package:habitly_mission/domain/entities/habit_entity.dart';

abstract class IHabitRepositories {
  Stream<List<HabitEntity>>getHabits(String uid);
  Future<void> addHabit(HabitEntity habit);
  Future<void> deleteHabit(String uid, String habitId);

}