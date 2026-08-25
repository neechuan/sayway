import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/board_providers.dart';
import '../../../data/models/symbol_card.dart';

class SentenceBar extends ConsumerWidget {
  const SentenceBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(sentenceProvider);

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Scrollable word chips
          Expanded(
            child: words.isEmpty
                ? Center(
                    child: Text(
                      'Tap a symbol to start speaking…',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    itemCount: words.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (_, i) => _WordChip(card: words[i], index: i),
                  ),
          ),
          // Action buttons
          if (words.isNotEmpty) ...[
            _BarButton(
              icon: Icons.backspace_outlined,
              color: AppColors.textMuted,
              tooltip: 'Remove last word',
              onTap: () {
                HapticFeedback.selectionClick();
                ref.read(sentenceProvider.notifier).removeLastWord();
              },
            ),
            _BarButton(
              icon: Icons.volume_up_rounded,
              color: AppColors.primary,
              tooltip: 'Speak sentence',
              onTap: () {
                HapticFeedback.mediumImpact();
                ref.read(sentenceProvider.notifier).speakSentence();
              },
            ),
            _BarButton(
              icon: Icons.clear_all,
              color: AppColors.error,
              tooltip: 'Clear all',
              onTap: () {
                HapticFeedback.lightImpact();
                ref.read(sentenceProvider.notifier).clear();
              },
            ),
          ],
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _WordChip extends StatelessWidget {
  final SymbolCard card;
  final int index;

  const _WordChip({required this.card, required this.index});

  @override
  Widget build(BuildContext context) {
    final bgColor = Color(card.backgroundColor);
    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: bgColor.withValues(alpha: 0.5), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (card.symbolPath != null) ...[
              Image.asset(card.symbolPath!, width: 20, height: 20, fit: BoxFit.contain),
              const SizedBox(width: 6),
            ] else if (card.emoji != null) ...[
              Text(card.emoji!, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
            ],
            Text(
              card.label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _BarButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}
