import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'symbol_card.g.dart';

@HiveType(typeId: 0)
enum CardCategory {
  @HiveField(0)
  core,
  @HiveField(1)
  food,
  @HiveField(2)
  feelings,
  @HiveField(3)
  people,
  @HiveField(4)
  actions,
  @HiveField(5)
  places,
  @HiveField(6)
  things,
  @HiveField(7)
  time,
}

@HiveType(typeId: 1)
class SymbolCard extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String label;

  @HiveField(2)
  String? symbolPath; // local asset path or file path

  @HiveField(3)
  String? customImagePath; // user photo

  @HiveField(4)
  String? emoji; // fallback emoji if no image

  @HiveField(5)
  CardCategory category;

  @HiveField(6)
  int backgroundColor; // ARGB color int

  @HiveField(7)
  int sortOrder;

  @HiveField(8)
  bool isVisible;

  @HiveField(9)
  String boardId;

  SymbolCard({
    String? id,
    required this.label,
    this.symbolPath,
    this.customImagePath,
    this.emoji,
    required this.category,
    required this.backgroundColor,
    this.sortOrder = 0,
    this.isVisible = true,
    required this.boardId,
  }) : id = id ?? const Uuid().v4();
}
