import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/symbol_card.dart';
import '../../../data/models/board.dart';
import '../../../data/repositories/board_repository.dart';
import '../../../data/services/tts_service.dart';
import '../../profile/profile_providers.dart';
import '../../../data/services/hive_service.dart';

// ── Repository ─────────────────────────────────────────────────────────────

final boardRepositoryProvider = Provider<BoardRepository>((ref) {
  return BoardRepository();
});

// ── Active Board ───────────────────────────────────────────────────────────

final activeBoardProvider = Provider<Board?>((ref) {
  final profile = ref.watch(activeProfileProvider);
  if (profile == null || profile.defaultBoardId == null) return null;
  return ref.read(boardRepositoryProvider).getBoard(profile.defaultBoardId!);
});

// ── Cards on current board ─────────────────────────────────────────────────

final boardCardsProvider =
    StateNotifierProvider<BoardCardsNotifier, List<SymbolCard>>((ref) {
  return BoardCardsNotifier(ref);
});

class BoardCardsNotifier extends StateNotifier<List<SymbolCard>> {
  final Ref _ref;
  final Set<String> _resolvingIds = {};

  BoardCardsNotifier(this._ref) : super([]) {
    _load();
  }

  void _load() {
    final board = _ref.read(activeBoardProvider);
    if (board == null) {
      state = [];
      return;
    }
    final cards = _ref.read(boardRepositoryProvider).getCardsForBoard(board.id);
    state = cards;

    // Check if there are any cards missing a symbolPath and try to resolve them in the background
    final missing = cards
        .where((c) => c.symbolPath == null && c.customImagePath == null && !_resolvingIds.contains(c.id))
        .toList();
    if (missing.isNotEmpty) {
      _resolveMissingArasaacUrls(missing);
    }
  }

  void refresh() => _load();

  Future<void> _resolveMissingArasaacUrls(List<SymbolCard> missing) async {
    for (final card in missing) {
      _resolvingIds.add(card.id);
    }

    final client = HttpClient();
    bool updatedAny = false;
    try {
      for (final card in missing) {
        try {
          final uri = Uri.parse('https://api.arasaac.org/api/pictograms/en/search/${Uri.encodeComponent(card.label.toLowerCase())}');
          final request = await client.getUrl(uri);
          final response = await request.close();
          if (response.statusCode == HttpStatus.ok) {
            final responseBody = await response.transform(utf8.decoder).join();
            final List data = jsonDecode(responseBody);
            if (data.isNotEmpty) {
              final id = data[0]['_id'];
              card.symbolPath = 'https://static.arasaac.org/pictograms/$id/${id}_300.png';
              await _ref.read(boardRepositoryProvider).updateCard(card);
              updatedAny = true;
            }
          }
        } catch (e) {
          // Fail silently for individual cards
        }
      }
    } catch (e) {
      // Fail silently
    } finally {
      client.close();
    }

    if (updatedAny) {
      _load();
    }
  }

  Future<void> addCard(SymbolCard card) async {
    await _ref.read(boardRepositoryProvider).addCard(card);
    _load();
  }

  Future<void> updateCard(SymbolCard card) async {
    await _ref.read(boardRepositoryProvider).updateCard(card);
    _load();
  }

  Future<void> deleteCard(String cardId) async {
    await _ref.read(boardRepositoryProvider).deleteCard(cardId);
    _load();
  }
}

// ── Sentence Builder ───────────────────────────────────────────────────────

final sentenceProvider =
    StateNotifierProvider<SentenceNotifier, List<SymbolCard>>((ref) {
  return SentenceNotifier();
});

class SentenceNotifier extends StateNotifier<List<SymbolCard>> {
  final _tts = TtsService();

  SentenceNotifier() : super([]);

  void addWord(SymbolCard card) {
    state = [...state, card];
    _tts.speak(card.label);
  }

  void removeLastWord() {
    if (state.isEmpty) return;
    state = state.sublist(0, state.length - 1);
  }

  void clear() => state = [];

  Future<void> speakSentence() async {
    if (state.isEmpty) return;
    final words = state.map((c) => c.label).toList();
    await _tts.speakSentence(words);
  }
}

// ── Edit Mode ──────────────────────────────────────────────────────────────

final editModeProvider = StateProvider<bool>((ref) => false);

// ── Category Filter ────────────────────────────────────────────────────────

final categoryFilterProvider = StateProvider<CardCategory?>((ref) => null);

final filteredCardsProvider = Provider<List<SymbolCard>>((ref) {
  final cards = ref.watch(boardCardsProvider);
  final filter = ref.watch(categoryFilterProvider);
  if (filter == null) return cards;
  return cards.where((c) => c.category == filter).toList();
});

// ── Settings ───────────────────────────────────────────────────────────────

final useCommunicationSymbolsProvider = StateProvider<bool>((ref) => false);
