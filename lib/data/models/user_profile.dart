import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 3)
enum ProfileType {
  @HiveField(0)
  child,
  @HiveField(1)
  adult,
}

@HiveType(typeId: 4)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  ProfileType type;

  @HiveField(3)
  String? avatarEmoji;

  @HiveField(4)
  String? defaultBoardId;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  bool isActive;

  UserProfile({
    String? id,
    required this.name,
    this.type = ProfileType.child,
    this.avatarEmoji,
    this.defaultBoardId,
    DateTime? createdAt,
    this.isActive = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();
}
