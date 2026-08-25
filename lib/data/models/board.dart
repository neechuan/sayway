import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'board.g.dart';

@HiveType(typeId: 2)
class Board extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String profileId;

  @HiveField(3)
  int columns; // grid columns (2–6)

  @HiveField(4)
  int rows; // grid rows (2–6)

  @HiveField(5)
  bool isDefault;

  @HiveField(6)
  DateTime createdAt;

  Board({
    String? id,
    required this.name,
    required this.profileId,
    this.columns = 4,
    this.rows = 4,
    this.isDefault = false,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();
}
