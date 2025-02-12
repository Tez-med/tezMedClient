// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationMessageAdapter extends TypeAdapter<NotificationMessage> {
  @override
  final int typeId = 5;

  @override
  NotificationMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationMessage(
      id: fields[0] as String,
      userId: fields[6] as String,
      title: fields[1] as String?,
      body: fields[2] as String?,
      data: (fields[3] as Map?)?.cast<String, dynamic>(),
      timestamp: fields[4] as DateTime,
      isRead: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationMessage obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.data)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.isRead)
      ..writeByte(6)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
