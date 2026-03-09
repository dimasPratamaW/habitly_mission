import 'package:habitly_mission/data/models/habit_model.dart';

abstract class IHabitRemoteSource{
  Stream<List<HabitModel>> getHabits(String uid);
  Future<void> addHabit(HabitModel habit);
  Future<void> deleteHabit(String uid, String habitId);
  Future<void> updateHabit(String uid, String habitId, HabitModel habit);

}