import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/symbol_card.dart';
import '../providers/board_providers.dart';

class CategoryFilterBar extends ConsumerWidget {
  const CategoryFilterBar({super.key});

  static const _categories = [
    (null, '⬛', 'All'),
    (CardCategory.core, '⚪', 'Core'),
    (CardCategory.food, '🍽️', 'Food'),
    (CardCategory.feelings, '❤️', 'Feelings'),
    (CardCategory.people, '👥', 'People'),
    (CardCategory.actions, '🎬', 'Actions'),
    (CardCategory.places, '🌍', 'Places'),
    (CardCategory.things, '🧸', 'Things'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(categoryFilterProvider);

    return Container(
      height: 48,
      color: AppColors.surface,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final (cat, emoji, label) = _categories[i];
          final isSelected = selected == cat;
          final catColor = _categoryColor(cat);

          return GestureDetector(
            onTap: () => ref.read(categoryFilterProvider.notifier).state = cat,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? catColor.withValues(alpha: 0.25)
                    : AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? catColor : AppColors.border,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? catColor : AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _categoryColor(CardCategory? cat) {
    return switch (cat) {
      CardCategory.core => AppColors.catCore,
      CardCategory.food => AppColors.catFood,
      CardCategory.feelings => AppColors.catFeelings,
      CardCategory.people => AppColors.catPeople,
      CardCategory.actions => AppColors.catActions,
      CardCategory.places => AppColors.catPlaces,
      CardCategory.things => AppColors.catThings,
      CardCategory.time => AppColors.catTime,
      null => AppColors.primary,
    };
  }
}
