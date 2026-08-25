import 'package:hive_flutter/hive_flutter.dart';
import '../models/symbol_card.dart';
import '../models/board.dart';
import '../models/user_profile.dart';

class HiveService {
  static const _profilesBox = 'profiles';
  static const _boardsBox = 'boards';
  static const _cardsBox = 'cards';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(CardCategoryAdapter());
    Hive.registerAdapter(SymbolCardAdapter());
    Hive.registerAdapter(BoardAdapter());
    Hive.registerAdapter(ProfileTypeAdapter());
    Hive.registerAdapter(UserProfileAdapter());

    // Open boxes
    await Hive.openBox<UserProfile>(_profilesBox);
    await Hive.openBox<Board>(_boardsBox);
    await Hive.openBox<SymbolCard>(_cardsBox);
  }

  static Box<UserProfile> get profiles => Hive.box<UserProfile>(_profilesBox);
  static Box<Board> get boards => Hive.box<Board>(_boardsBox);
  static Box<SymbolCard> get cards => Hive.box<SymbolCard>(_cardsBox);
}
