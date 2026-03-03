import 'package:hive_ce/hive_ce.dart';
part 'list_habit_hive.g.dart';

@HiveType(typeId:0)
class ListHabitHive extends HiveObject{
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String desc;
  @HiveField(3)
  final String time;

  ListHabitHive({required this.id, required this.title, required this.desc, required this.time});


}


