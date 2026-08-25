// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardAdapter extends TypeAdapter<Board> {
  @override
  final int typeId = 2;

  @override
  Board read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Board(
      id: fields[0] as String?,
      name: fields[1] as String,
      profileId: fields[2] as String,
      columns: fields[3] as int,
      rows: fields[4] as int,
      isDefault: fields[5] as bool,
      createdAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Board obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.profileId)
      ..writeByte(3)
      ..write(obj.columns)
      ..writeByte(4)
      ..write(obj.rows)
      ..writeByte(5)
      ..write(obj.isDefault)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
