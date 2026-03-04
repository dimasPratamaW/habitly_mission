// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_habit_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListHabitHiveAdapter extends TypeAdapter<ListHabitHive> {
  @override
  final typeId = 0;

  @override
  ListHabitHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListHabitHive(
      id: fields[0] as String,
      title: fields[1] as String,
      desc: fields[2] as String,
      time: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ListHabitHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.desc)
      ..writeByte(3)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListHabitHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
