import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:habitly_mission/data/remote/firestore_habit_remote_source.dart';
import 'package:habitly_mission/data/remote/i_habit_remote_source.dart';
import 'package:habitly_mission/domain/entities/habit_entity.dart';
import 'package:habitly_mission/domain/repositories/i_habit_repositories.dart';
import 'package:habitly_mission/presentation/state/habit_state_notifier.dart';
import 'package:habitly_mission/data/repositories/habit_repositories_implements.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref){
  return FirebaseFirestore.instance;
});

final habitDatasourceProvider = Provider<IHabitRemoteSource>((ref){
  return FirestoreHabitRemoteSource(ref.watch(firestoreProvider));
});

final habitRepositoryProvider = Provider<IHabitRepositories>((ref){
  return HabitRepositoriesImplements(ref.watch(habitDatasourceProvider));
});


enum HabitSort {dateNewest, dateOldest}
enum HabitFilter {all, upcoming, ongoing, completed}

final habitSortProvider = StateProvider<HabitSort>((ref)=> HabitSort.dateNewest);
final habitFilterProvider = StateProvider<HabitFilter>((ref)=>HabitFilter.all);

final habitStreamProvider = StreamProvider.family<List<HabitEntity>,String>((ref,uid){
  return ref.watch(habitRepositoryProvider).getHabits(uid);
});


// this is for add, updating, and deleting habit
final habitNotifierProvider = AsyncNotifierProvider<HabitStateNotifier,List<HabitEntity>>((){
  return HabitStateNotifier();
});