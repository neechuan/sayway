import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_profile.dart';
import '../../data/services/hive_service.dart';
import '../../data/models/board.dart';
import '../../data/repositories/board_repository.dart';

// ── Active Profile ─────────────────────────────────────────────────────────

final activeProfileProvider =
    StateNotifierProvider<ActiveProfileNotifier, UserProfile?>((ref) {
  return ActiveProfileNotifier();
});

class ActiveProfileNotifier extends StateNotifier<UserProfile?> {
  final _repo = BoardRepository();

  ActiveProfileNotifier() : super(null) {
    _loadActiveProfile();
  }

  void _loadActiveProfile() {
    final profiles = HiveService.profiles.values.toList();
    if (profiles.isEmpty) return;
    final active = profiles.where((p) => p.isActive).firstOrNull ?? profiles.first;
    state = active;
  }

  Future<void> switchProfile(UserProfile profile) async {
    for (final p in HiveService.profiles.values) {
      p.isActive = false;
      await p.save();
    }
    profile.isActive = true;
    await profile.save();
    state = profile;
  }

  Future<UserProfile> createProfile(
      String name, ProfileType type, String emoji) async {
    final profile = UserProfile(name: name, type: type, avatarEmoji: emoji);

    // Create a default board for this profile
    final board = Board(
      name: 'My Board',
      profileId: profile.id,
      isDefault: true,
    );
    await HiveService.boards.put(board.id, board);
    profile.defaultBoardId = board.id;
    await HiveService.profiles.put(profile.id, profile);

    // Seed vocabulary
    await _repo.seedDefaultBoard(board.id);

    return profile;
  }
}

final allProfilesProvider = Provider<List<UserProfile>>((ref) {
  return HiveService.profiles.values.toList();
});
