// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 4;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String?,
      name: fields[1] as String,
      type: fields[2] as ProfileType,
      avatarEmoji: fields[3] as String?,
      defaultBoardId: fields[4] as String?,
      createdAt: fields[5] as DateTime?,
      isActive: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.avatarEmoji)
      ..writeByte(4)
      ..write(obj.defaultBoardId)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfileTypeAdapter extends TypeAdapter<ProfileType> {
  @override
  final int typeId = 3;

  @override
  ProfileType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProfileType.child;
      case 1:
        return ProfileType.adult;
      default:
        return ProfileType.child;
    }
  }

  @override
  void write(BinaryWriter writer, ProfileType obj) {
    switch (obj) {
      case ProfileType.child:
        writer.writeByte(0);
        break;
      case ProfileType.adult:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
