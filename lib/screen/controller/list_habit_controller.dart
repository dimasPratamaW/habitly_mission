import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:habitly_mission/models/list_habit_hive.dart';

final habitListProvider =
    AsyncNotifierProvider<ListHabitController, List<ListHabitHive>>(() {
      return ListHabitController();
    });

class ListHabitController extends AsyncNotifier<List<ListHabitHive>> {// this getting all the box and store it in list


  late Box<ListHabitHive> _box;

  static const boxName = 'list_habit';

  @override
  Future<List<ListHabitHive>> build() async {
    if (Hive.isBoxOpen(boxName)) {
      _box = Hive.box<ListHabitHive>(boxName);
    } else {
      _box = await Hive.openBox<ListHabitHive>(boxName);
    }
    void listener()=>ref.invalidateSelf();
    _box.listenable().addListener(listener);

    ref.onDispose(() {
      _box.listenable().removeListener(listener);
    });

    return _box.values.toList();
  }

  Future<void>addHabit(String title , String desc, String time)async {
    await _box.add(ListHabitHive(id: _box.length.toString(), title: title, desc: desc, time: time));
  }

  Future<void>deleteHabit(String id)async {
    final entry = _box.toMap().entries.firstWhere((e)=>e.value.id==id,
    orElse: () => throw Exception("habit not found"),
    );

    await _box.delete(entry.key);
  }



}
