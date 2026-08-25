import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/symbol_card.dart';
import '../providers/board_providers.dart';

class SymbolCardWidget extends ConsumerStatefulWidget {
  final SymbolCard card;
  final bool editMode;

  const SymbolCardWidget({
    super.key,
    required this.card,
    this.editMode = false,
  });

  @override
  ConsumerState<SymbolCardWidget> createState() => _SymbolCardWidgetState();
}

class _SymbolCardWidgetState extends ConsumerState<SymbolCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (widget.editMode) {
      _showEditMenu();
      return;
    }
    HapticFeedback.lightImpact();
    _controller.forward().then((_) => _controller.reverse());
    ref.read(sentenceProvider.notifier).addWord(widget.card);
  }

  void _showEditMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _EditCardSheet(card: widget.card),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Color(widget.card.backgroundColor);

    return Semantics(
      label: widget.card.label,
      button: true,
      child: GestureDetector(
        onTap: _onTap,
        child: AnimatedBuilder(
          animation: _scaleAnim,
          builder: (_, child) => Transform.scale(
            scale: _scaleAnim.value,
            child: child,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: bgColor.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: bgColor.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.editMode)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, right: 4),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.edit, size: 12, color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                const Spacer(),
                // Symbol (emoji or image)
                _buildSymbol(bgColor),
                const SizedBox(height: 6),
                // Label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    widget.card.label,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSymbol(Color bgColor) {
    final useCommunicationSymbols = ref.watch(useCommunicationSymbolsProvider);

    if (widget.card.customImagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          widget.card.customImagePath!,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _emojiWidget(bgColor),
        ),
      );
    } else if (widget.card.symbolPath != null && !useCommunicationSymbols) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          widget.card.symbolPath!,
          width: 44,
          height: 44,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _emojiWidget(bgColor),
        ),
      );
    }
    return _emojiWidget(bgColor);
  }

  Widget _emojiWidget(Color bgColor) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          widget.card.emoji ?? '🔷',
          style: const TextStyle(fontSize: 26),
        ),
      ),
    );
  }
}

// ── Edit Card Bottom Sheet ─────────────────────────────────────────────────

class _EditCardSheet extends ConsumerWidget {
  final SymbolCard card;
  const _EditCardSheet({required this.card});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(card.emoji ?? '🔷', style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Text(card.label,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    )),
              ],
            ),
            const SizedBox(height: 20),
            _sheetAction(
              context,
              icon: Icons.edit_outlined,
              label: 'Edit card',
              color: AppColors.primary,
              onTap: () {
                Navigator.pop(context);
                // TODO: navigate to edit card screen
              },
            ),
            const SizedBox(height: 8),
            _sheetAction(
              context,
              icon: Icons.delete_outline,
              label: 'Delete card',
              color: AppColors.error,
              onTap: () {
                Navigator.pop(context);
                ref.read(boardCardsProvider.notifier).deleteCard(card.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
