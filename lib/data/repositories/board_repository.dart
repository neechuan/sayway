import '../../data/models/symbol_card.dart';
import '../../data/models/board.dart';
import '../../data/services/hive_service.dart';
import '../../core/constants/seed_vocabulary.dart';

class BoardRepository {
  // ── Boards ────────────────────────────────────────────────────────────────

  List<Board> getBoardsForProfile(String profileId) {
    return HiveService.boards.values
        .where((b) => b.profileId == profileId)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Board? getBoard(String boardId) {
    return HiveService.boards.values
        .where((b) => b.id == boardId)
        .firstOrNull;
  }

  Future<Board> createBoard(Board board) async {
    await HiveService.boards.put(board.id, board);
    return board;
  }

  Future<void> updateBoard(Board board) async {
    await HiveService.boards.put(board.id, board);
  }

  Future<void> deleteBoard(String boardId) async {
    await HiveService.boards.delete(boardId);
    // Also delete all cards in this board
    final toDelete = HiveService.cards.values
        .where((c) => c.boardId == boardId)
        .map((c) => c.id)
        .toList();
    for (final id in toDelete) {
      await HiveService.cards.delete(id);
    }
  }

  // ── Cards ─────────────────────────────────────────────────────────────────

  List<SymbolCard> getCardsForBoard(String boardId) {
    return HiveService.cards.values
        .where((c) => c.boardId == boardId && c.isVisible)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  Future<SymbolCard> addCard(SymbolCard card) async {
    await HiveService.cards.put(card.id, card);
    return card;
  }

  Future<void> updateCard(SymbolCard card) async {
    await HiveService.cards.put(card.id, card);
  }

  Future<void> deleteCard(String cardId) async {
    await HiveService.cards.delete(cardId);
  }

  Future<void> reorderCards(List<String> cardIds) async {
    for (int i = 0; i < cardIds.length; i++) {
      final card = HiveService.cards.get(cardIds[i]);
      if (card != null) {
        card.sortOrder = i;
        await card.save();
      }
    }
  }

  // ── Seed data ─────────────────────────────────────────────────────────────

  Future<void> seedDefaultBoard(String boardId) async {
    final existing = getCardsForBoard(boardId);
    if (existing.isNotEmpty) return;

    final seeds = SeedVocabulary.coreWords(boardId);
    for (int i = 0; i < seeds.length; i++) {
      seeds[i].sortOrder = i;
      await addCard(seeds[i]);
    }
  }
}
