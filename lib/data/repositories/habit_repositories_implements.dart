import 'package:habitly_mission/data/remote/i_habit_remote_source.dart';
import 'package:habitly_mission/domain/entities/habit_entity.dart';
import 'package:habitly_mission/domain/repositories/i_habit_repositories.dart';
import 'package:habitly_mission/data/models/habit_model.dart';

class HabitRepositoriesImplements implements IHabitRepositories{
  final IHabitRemoteSource _datasource;
  HabitRepositoriesImplements(this._datasource);

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