import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitly_mission/domain/entities/habit_entity.dart';

class HabitModel extends HabitEntity {
  const HabitModel({
    required super.id,
    required super.title,
    required super.desc,
    required super.time,
    required super.date,
    required super.status,
    required super.uid,
  });

  factory HabitModel.fromMap(Map<String, dynamic> map, String id) {
    return HabitModel(
      id: id,
      title: map['title'] ?? '',
      desc: map['desc'] ?? '',
      time: map['time'] ?? '',
      date: map['date'] ?? '',
      status: map['status'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'title': title,
      'desc': desc,
      'time': time,
      'date':date,
      'status':status,
      'uid': uid,
    };
  }
}
