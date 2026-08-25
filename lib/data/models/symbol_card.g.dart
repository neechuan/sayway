// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symbol_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SymbolCardAdapter extends TypeAdapter<SymbolCard> {
  @override
  final int typeId = 1;

  @override
  SymbolCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SymbolCard(
      id: fields[0] as String?,
      label: fields[1] as String,
      symbolPath: fields[2] as String?,
      customImagePath: fields[3] as String?,
      emoji: fields[4] as String?,
      category: fields[5] as CardCategory,
      backgroundColor: fields[6] as int,
      sortOrder: fields[7] as int,
      isVisible: fields[8] as bool,
      boardId: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SymbolCard obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.symbolPath)
      ..writeByte(3)
      ..write(obj.customImagePath)
      ..writeByte(4)
      ..write(obj.emoji)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.backgroundColor)
      ..writeByte(7)
      ..write(obj.sortOrder)
      ..writeByte(8)
      ..write(obj.isVisible)
      ..writeByte(9)
      ..write(obj.boardId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SymbolCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CardCategoryAdapter extends TypeAdapter<CardCategory> {
  @override
  final int typeId = 0;

  @override
  CardCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CardCategory.core;
      case 1:
        return CardCategory.food;
      case 2:
        return CardCategory.feelings;
      case 3:
        return CardCategory.people;
      case 4:
        return CardCategory.actions;
      case 5:
        return CardCategory.places;
      case 6:
        return CardCategory.things;
      case 7:
        return CardCategory.time;
      default:
        return CardCategory.core;
    }
  }

  @override
  void write(BinaryWriter writer, CardCategory obj) {
    switch (obj) {
      case CardCategory.core:
        writer.writeByte(0);
        break;
      case CardCategory.food:
        writer.writeByte(1);
        break;
      case CardCategory.feelings:
        writer.writeByte(2);
        break;
      case CardCategory.people:
        writer.writeByte(3);
        break;
      case CardCategory.actions:
        writer.writeByte(4);
        break;
      case CardCategory.places:
        writer.writeByte(5);
        break;
      case CardCategory.things:
        writer.writeByte(6);
        break;
      case CardCategory.time:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
