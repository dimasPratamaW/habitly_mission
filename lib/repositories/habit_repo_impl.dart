import 'package:habitly_mission/datasources/habit_datasource.dart';
import 'package:habitly_mission/domain/entities/habit_entity.dart';
import 'package:habitly_mission/domain/repositories/habit_repositories.dart';
import 'package:habitly_mission/models/habit_model.dart';

class HabitRepoImpl implements HabitRepositories{
  final HabitDatasource _datasource;
  HabitRepoImpl(this._datasource);

  @override
  Future<void> addHabit(HabitEntity habit) async {
    await _datasource.addHabit(HabitModel(id: habit.id, title: habit.title, desc: habit.desc, time: habit.time,date: habit.date,status: habit.status, uid: habit.uid));
  }

  @override
  Future<void> deleteHabit(String uid, String habitId)async {
    await _datasource.deleteHabit(uid, habitId);
  }

  @override
  Stream<List<HabitEntity>> getHabits(String uid) {
    return _datasource.getHabits(uid);
  }

}