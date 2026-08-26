import 'package:flutter/material.dart';
import '../../data/models/symbol_card.dart';
import '../theme/app_theme.dart';

/// Pre-seeded core vocabulary — 80 high-frequency AAC words.
/// Uses emojis as fallback/Communication symbols, and supports local/remote ARASAAC pictograms.
class SeedVocabulary {
  static const Set<String> _localAssetKeys = {
    'yes', 'no', 'help', 'more', 'stop', 'go', 'please', 'thank_you', 'i_want', 'i_like',
    'water', 'milk', 'juice', 'food', 'snack', 'hungry', 'full',
    'happy', 'sad', 'angry', 'scared', 'tired', 'hurt',
    'mum', 'dad', 'me', 'friend', 'teacher',
    'play', 'sleep', 'read', 'watch', 'listen', 'walk',
    'home', 'school', 'toilet', 'outside',
    'book', 'toy', 'music'
  };

  static List<SymbolCard> coreWords(String boardId) => [
    // ── Core / Social ─────────────────────────────────────────────────────
    _card(boardId, 'Yes', '✅', CardCategory.core, AppColors.catCore),
    _card(boardId, 'No', '❌', CardCategory.core, AppColors.catCore),
    _card(boardId, 'Help', '🆘', CardCategory.core, AppColors.catCore),
    _card(boardId, 'More', '➕', CardCategory.core, AppColors.catCore),
    _card(boardId, 'Stop', '🛑', CardCategory.core, AppColors.catCore),
    _card(boardId, 'Go', '🚦', CardCategory.core, AppColors.catCore),
    _card(boardId, 'Please', '🙏', CardCategory.core, AppColors.catCore),
    _card(boardId, 'Thank you', '😊', CardCategory.core, AppColors.catCore),
    _card(boardId, 'I want', '🙋', CardCategory.core, AppColors.catCore),
    _card(boardId, 'I like', '❤️', CardCategory.core, AppColors.catCore),
    _card(boardId, 'Hello', '👋', CardCategory.core, AppColors.catCore),
    _card(boardId, 'Goodbye', '👋', CardCategory.core, AppColors.catCore),
    _card(boardId, 'Look', '👀', CardCategory.core, AppColors.catCore),
    _card(boardId, 'Wait', '⏳', CardCategory.core, AppColors.catCore),
    _card(boardId, 'Different', '🔄', CardCategory.core, AppColors.catCore),
    _card(boardId, 'Same', '🟰', CardCategory.core, AppColors.catCore),
    _card(boardId, 'Good', '👍', CardCategory.core, AppColors.catCore),
    _card(boardId, 'Bad', '👎', CardCategory.core, AppColors.catCore),
    _card(boardId, "Don't want", '🙅', CardCategory.core, AppColors.catCore),
    _card(boardId, 'Mine', '🙋‍♂️', CardCategory.core, AppColors.catCore),

    // ── Food & Drink ──────────────────────────────────────────────────────
    _card(boardId, 'Water', '💧', CardCategory.food, AppColors.catFood),
    _card(boardId, 'Milk', '🥛', CardCategory.food, AppColors.catFood),
    _card(boardId, 'Juice', '🧃', CardCategory.food, AppColors.catFood),
    _card(boardId, 'Food', '🍽️', CardCategory.food, AppColors.catFood),
    _card(boardId, 'Snack', '🍎', CardCategory.food, AppColors.catFood),
    _card(boardId, 'Hungry', '😋', CardCategory.food, AppColors.catFood),
    _card(boardId, 'Full', '🤰', CardCategory.food, AppColors.catFood),
    _card(boardId, 'Apple', '🍎', CardCategory.food, AppColors.catFood),
    _card(boardId, 'Banana', '🍌', CardCategory.food, AppColors.catFood),
    _card(boardId, 'Cookie', '🍪', CardCategory.food, AppColors.catFood),
    _card(boardId, 'Bread', '🍞', CardCategory.food, AppColors.catFood),
    _card(boardId, 'Ice Cream', '🍦', CardCategory.food, AppColors.catFood),
    _card(boardId, 'Drink', '🥤', CardCategory.food, AppColors.catFood),
    _card(boardId, 'Eat', '🍽️', CardCategory.food, AppColors.catFood),
    _card(boardId, 'Hot', '🔥', CardCategory.food, AppColors.catFood),
    _card(boardId, 'Cold', '❄️', CardCategory.food, AppColors.catFood),

    // ── Feelings ──────────────────────────────────────────────────────────
    _card(boardId, 'Happy', '😄', CardCategory.feelings, AppColors.catFeelings),
    _card(boardId, 'Sad', '😢', CardCategory.feelings, AppColors.catFeelings),
    _card(boardId, 'Angry', '😡', CardCategory.feelings, AppColors.catFeelings),
    _card(boardId, 'Scared', '😨', CardCategory.feelings, AppColors.catFeelings),
    _card(boardId, 'Tired', '😴', CardCategory.feelings, AppColors.catFeelings),
    _card(boardId, 'Hurt', '🤕', CardCategory.feelings, AppColors.catFeelings),
    _card(boardId, 'Excited', '🤩', CardCategory.feelings, AppColors.catFeelings),
    _card(boardId, 'Silly', '😜', CardCategory.feelings, AppColors.catFeelings),
    _card(boardId, 'Surprised', '😲', CardCategory.feelings, AppColors.catFeelings),
    _card(boardId, 'Sick', '🤢', CardCategory.feelings, AppColors.catFeelings),
    _card(boardId, 'Bored', '🥱', CardCategory.feelings, AppColors.catFeelings),
    _card(boardId, 'Proud', '😌', CardCategory.feelings, AppColors.catFeelings),

    // ── People ────────────────────────────────────────────────────────────
    _card(boardId, 'Mum', '👩', CardCategory.people, AppColors.catPeople),
    _card(boardId, 'Dad', '👨', CardCategory.people, AppColors.catPeople),
    _card(boardId, 'Me', '🧒', CardCategory.people, AppColors.catPeople),
    _card(boardId, 'Friend', '🤝', CardCategory.people, AppColors.catPeople),
    _card(boardId, 'Teacher', '🧑‍🏫', CardCategory.people, AppColors.catPeople),
    _card(boardId, 'Brother', '👦', CardCategory.people, AppColors.catPeople),
    _card(boardId, 'Sister', '👧', CardCategory.people, AppColors.catPeople),
    _card(boardId, 'Baby', '👶', CardCategory.people, AppColors.catPeople),
    _card(boardId, 'Doctor', '🩺', CardCategory.people, AppColors.catPeople),
    _card(boardId, 'Family', '👨‍👩‍👧‍👦', CardCategory.people, AppColors.catPeople),

    // ── Actions ───────────────────────────────────────────────────────────
    _card(boardId, 'Play', '🎮', CardCategory.actions, AppColors.catActions),
    _card(boardId, 'Sleep', '😴', CardCategory.actions, AppColors.catActions),
    _card(boardId, 'Read', '📖', CardCategory.actions, AppColors.catActions),
    _card(boardId, 'Watch', '📺', CardCategory.actions, AppColors.catActions),
    _card(boardId, 'Listen', '🎧', CardCategory.actions, AppColors.catActions),
    _card(boardId, 'Walk', '🚶', CardCategory.actions, AppColors.catActions),
    _card(boardId, 'Run', '🏃', CardCategory.actions, AppColors.catActions),
    _card(boardId, 'Jump', '🦘', CardCategory.actions, AppColors.catActions),
    _card(boardId, 'Draw', '🎨', CardCategory.actions, AppColors.catActions),
    _card(boardId, 'Write', '✍️', CardCategory.actions, AppColors.catActions),
    _card(boardId, 'Clean', '🧹', CardCategory.actions, AppColors.catActions),
    _card(boardId, 'Wash', '🧼', CardCategory.actions, AppColors.catActions),
    _card(boardId, 'Give', '🤲', CardCategory.actions, AppColors.catActions),
    _card(boardId, 'Take', '🤚', CardCategory.actions, AppColors.catActions),

    // ── Places ────────────────────────────────────────────────────────────
    _card(boardId, 'Home', '🏠', CardCategory.places, AppColors.catPlaces),
    _card(boardId, 'School', '🏫', CardCategory.places, AppColors.catPlaces),
    _card(boardId, 'Toilet', '🚽', CardCategory.places, AppColors.catPlaces),
    _card(boardId, 'Outside', '🌳', CardCategory.places, AppColors.catPlaces),
    _card(boardId, 'Park', '🛝', CardCategory.places, AppColors.catPlaces),
    _card(boardId, 'Shop', '🛒', CardCategory.places, AppColors.catPlaces),
    _card(boardId, 'Bed', '🛏️', CardCategory.places, AppColors.catPlaces),
    _card(boardId, 'Kitchen', '🍳', CardCategory.places, AppColors.catPlaces),
    _card(boardId, 'Bathroom', '🛁', CardCategory.places, AppColors.catPlaces),
    _card(boardId, 'Hospital', '🏥', CardCategory.places, AppColors.catPlaces),

    // ── Things ────────────────────────────────────────────────────────────
    _card(boardId, 'Book', '📚', CardCategory.things, AppColors.catThings),
    _card(boardId, 'Toy', '🧸', CardCategory.things, AppColors.catThings),
    _card(boardId, 'Music', '🎵', CardCategory.things, AppColors.catThings),
    _card(boardId, 'Ball', '⚽', CardCategory.things, AppColors.catThings),
    _card(boardId, 'Car', '🚗', CardCategory.things, AppColors.catThings),
    _card(boardId, 'Phone', '📱', CardCategory.things, AppColors.catThings),
    _card(boardId, 'Computer', '💻', CardCategory.things, AppColors.catThings),
    _card(boardId, 'Clothes', '👕', CardCategory.things, AppColors.catThings),
    _card(boardId, 'Shoes', '👟', CardCategory.things, AppColors.catThings),
    _card(boardId, 'Pencil', '✏️', CardCategory.things, AppColors.catThings),
    _card(boardId, 'Paper', '📄', CardCategory.things, AppColors.catThings),
  ];

  static SymbolCard _card(
    String boardId,
    String label,
    String emoji,
    CardCategory category,
    Color bgColor,
  ) {
    final assetKey = label.toLowerCase().replaceAll(' ', '_');
    final hasLocal = _localAssetKeys.contains(assetKey);
    return SymbolCard(
      label: label,
      emoji: emoji,
      symbolPath: hasLocal ? 'assets/symbols/$assetKey.png' : null,
      category: category,
      backgroundColor: bgColor.toARGB32(),
      boardId: boardId,
    );
  }
}
