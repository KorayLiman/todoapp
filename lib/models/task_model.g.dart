// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 1;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      category: fields[4] as Category?,
      Id: fields[0] as String,
      EndDate: fields[2] as DateTime,
      Name: fields[1] as String,
      NotificationId: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.Id)
      ..writeByte(1)
      ..write(obj.Name)
      ..writeByte(2)
      ..write(obj.EndDate)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.NotificationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 2;

  @override
  Category read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Category.Business;
      case 1:
        return Category.School;
      case 2:
        return Category.Payments;
      case 3:
        return Category.Other;
      default:
        return Category.Business;
    }
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    switch (obj) {
      case Category.Business:
        writer.writeByte(0);
        break;
      case Category.School:
        writer.writeByte(1);
        break;
      case Category.Payments:
        writer.writeByte(2);
        break;
      case Category.Other:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
