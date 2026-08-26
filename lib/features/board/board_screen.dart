import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import 'providers/board_providers.dart';
import 'widgets/symbol_card_widget.dart';
import 'widgets/sentence_bar.dart';
import 'widgets/category_filter_bar.dart';
import '../profile/profile_providers.dart';
import '../../data/models/symbol_card.dart';
import '../../data/models/board.dart';
import '../../data/models/user_profile.dart';
import '../../data/services/hive_service.dart';

class BoardScreen extends ConsumerStatefulWidget {
  const BoardScreen({super.key});

  @override
  ConsumerState<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends ConsumerState<BoardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(boardCardsProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(activeProfileProvider);
    final board = ref.watch(activeBoardProvider);
    final cards = ref.watch(filteredCardsProvider);
    final editMode = ref.watch(editModeProvider);

    if (profile == null) {
      return const _OnboardingView();
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top AppBar ────────────────────────────────────────────
            _TopBar(profile: profile, editMode: editMode, board: board),

            // ── Sentence Builder Bar ──────────────────────────────────
            const SentenceBar(),

            // ── Category Filter ───────────────────────────────────────
            const CategoryFilterBar(),

            // ── Symbol Grid ───────────────────────────────────────────
            Expanded(
              child: cards.isEmpty
                  ? _EmptyState(editMode: editMode)
                  : _SymbolGrid(
                      cards: cards,
                      columns: board?.columns ?? 4,
                      editMode: editMode,
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: editMode
          ? FloatingActionButton.extended(
              onPressed: () => _showAddCardDialog(context),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Card',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            )
          : null,
    );
  }

  void _showAddCardDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _AddCardSheet(),
    );
  }
}

// ── Top App Bar ─────────────────────────────────────────────────────────────

class _TopBar extends ConsumerWidget {
  final dynamic profile;
  final bool editMode;
  final Board? board;

  const _TopBar({required this.profile, required this.editMode, required this.board});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          // App logo + name
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('💬', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'SayMyWay',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${profile.avatarEmoji ?? '👤'} ${profile.name}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
          const Spacer(),
          // Edit Mode Toggle
          GestureDetector(
            onTap: () {
              ref.read(editModeProvider.notifier).state = !editMode;
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: editMode
                    ? AppColors.accent.withValues(alpha: 0.2)
                    : AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: editMode ? AppColors.accent : AppColors.border,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    editMode ? Icons.lock_open_rounded : Icons.lock_rounded,
                    size: 14,
                    color: editMode ? AppColors.accent : AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    editMode ? 'Editing' : 'Edit',
                    style: TextStyle(
                      color: editMode ? AppColors.accent : AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Grid size control
          if (editMode) ...[
            _GridSizeButton(board: board),
            const SizedBox(width: 8),
          ],
          // Profile
          GestureDetector(
            onTap: () => _showProfileSheet(context),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: Text(
                profile.avatarEmoji ?? '👤',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _ProfileSheet(),
    );
  }
}

// ── Grid Size Button ────────────────────────────────────────────────────────

class _GridSizeButton extends ConsumerWidget {
  final Board? board;
  const _GridSizeButton({required this.board});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cols = board?.columns ?? 4;
    return GestureDetector(
      onTap: () {
        final next = cols < 6 ? cols + 1 : 2;
        if (board != null) {
          board!.columns = next;
          board!.rows = next;
          HiveService.boards.put(board!.id, board!);
          ref.invalidate(activeBoardProvider);
          ref.read(boardCardsProvider.notifier).refresh();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Text(
          '${cols}×${cols}',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Symbol Grid ─────────────────────────────────────────────────────────────

class _SymbolGrid extends StatelessWidget {
  final List<SymbolCard> cards;
  final int columns;
  final bool editMode;

  const _SymbolGrid({
    required this.cards,
    required this.columns,
    required this.editMode,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: cards.length,
      itemBuilder: (_, i) => SymbolCardWidget(
        card: cards[i],
        editMode: editMode,
      ),
    );
  }
}

// ── Empty State ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool editMode;
  const _EmptyState({required this.editMode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🫙', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            editMode ? 'Tap + Add Card to add symbols' : 'No symbols yet',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// ── Add Card Sheet ──────────────────────────────────────────────────────────

class _AddCardSheet extends ConsumerStatefulWidget {
  const _AddCardSheet();

  @override
  ConsumerState<_AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends ConsumerState<_AddCardSheet> {
  final _labelCtrl = TextEditingController();
  final _emojiCtrl = TextEditingController();
  CardCategory _selectedCategory = CardCategory.core;

  @override
  void dispose() {
    _labelCtrl.dispose();
    _emojiCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final label = _labelCtrl.text.trim();
    if (label.isEmpty) return;

    final board = ref.read(activeBoardProvider);
    if (board == null) return;

    final card = SymbolCard(
      label: label,
      emoji: _emojiCtrl.text.trim().isNotEmpty ? _emojiCtrl.text.trim() : '🔷',
      category: _selectedCategory,
      backgroundColor: _catColor(_selectedCategory).toARGB32(),
      boardId: board.id,
      sortOrder: ref.read(boardCardsProvider).length,
    );

    ref.read(boardCardsProvider.notifier).addCard(card);
    Navigator.pop(context);
  }

  Color _catColor(CardCategory cat) => switch (cat) {
        CardCategory.food => AppColors.catFood,
        CardCategory.feelings => AppColors.catFeelings,
        CardCategory.people => AppColors.catPeople,
        CardCategory.actions => AppColors.catActions,
        CardCategory.places => AppColors.catPlaces,
        CardCategory.things => AppColors.catThings,
        CardCategory.time => AppColors.catTime,
        _ => AppColors.catCore,
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add New Card',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          Row(
            children: [
              // Emoji picker
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: TextField(
                    controller: _emojiCtrl,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '🔷',
                      hintStyle: TextStyle(fontSize: 28),
                    ),
                    maxLength: 2,
                    buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
                        null,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _labelCtrl,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Word or phrase',
                    labelStyle: const TextStyle(color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.surfaceElevated,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Category selector
          const Text('Category',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: CardCategory.values.map((cat) {
              final isSelected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? _catColor(cat).withValues(alpha: 0.25) : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? _catColor(cat) : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    cat.name[0].toUpperCase() + cat.name.substring(1),
                    style: TextStyle(
                      color: isSelected ? _catColor(cat) : AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Add Card',
                  style: TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile Sheet ───────────────────────────────────────────────────────────

class _ProfileSheet extends ConsumerWidget {
  const _ProfileSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = HiveService.profiles.values.toList();
    final active = ref.watch(activeProfileProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Switch Profile',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            ...profiles.map((p) {
              final isActive = p.id == active?.id;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                  child: Text(p.avatarEmoji ?? '👤', style: const TextStyle(fontSize: 20)),
                ),
                title: Text(p.name,
                    style: TextStyle(
                        color: isActive ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: FontWeight.w700)),
                subtitle: Text(p.type.name,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                trailing: isActive
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () {
                  ref.read(activeProfileProvider.notifier).switchProfile(p);
                  ref.read(boardCardsProvider.notifier).refresh();
                  Navigator.pop(context);
                },
              );
            }),
            const Divider(color: AppColors.border),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: AppColors.surfaceElevated,
                child: Icon(Icons.add, color: AppColors.textSecondary),
              ),
              title: const Text('Add Profile',
                  style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _showCreateProfile(context, ref);
              },
            ),
            const Divider(color: AppColors.border),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: ref.watch(useCommunicationSymbolsProvider),
              onChanged: (val) {
                ref.read(useCommunicationSymbolsProvider.notifier).state = val;
              },
              title: const Text('Use Communication Symbols',
                  style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 15)),
              subtitle: const Text('Use emojis instead of ARASAAC pictograms',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            ),
            const Divider(color: AppColors.border),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: AppColors.surfaceElevated,
                child: Icon(Icons.exit_to_app_rounded, color: Colors.redAccent),
              ),
              title: const Text('Exit App',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
              onTap: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateProfile(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => const _CreateProfileDialog(),
    );
  }
}

// ── Create Profile Dialog ───────────────────────────────────────────────────

class _CreateProfileDialog extends ConsumerStatefulWidget {
  const _CreateProfileDialog();

  @override
  ConsumerState<_CreateProfileDialog> createState() => _CreateProfileDialogState();
}

class _CreateProfileDialogState extends ConsumerState<_CreateProfileDialog> {
  final _nameCtrl = TextEditingController();
  String _emoji = '🧒';
  // ignore: unused_field
  final _type = 'child';

  final _emojis = ['🧒', '👦', '👧', '🧑', '👩', '👨', '🧓', '👴', '👵'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('New Profile',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar picker
          Wrap(
            spacing: 8,
            children: _emojis.map((e) {
              return GestureDetector(
                onTap: () => setState(() => _emoji = e),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _emoji == e ? AppColors.primary.withValues(alpha: 0.3) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _emoji == e ? AppColors.primary : Colors.transparent,
                    ),
                  ),
                  child: Text(e, style: const TextStyle(fontSize: 24)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: const TextStyle(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.surfaceElevated,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
        ),
        FilledButton(
          onPressed: () async {
            final name = _nameCtrl.text.trim();
            if (name.isEmpty) return;
            final profile = await ref
                .read(activeProfileProvider.notifier)
                .createProfile(name, ProfileType.child, _emoji);
            await ref.read(activeProfileProvider.notifier).switchProfile(profile);
            ref.read(boardCardsProvider.notifier).refresh();
            if (context.mounted) Navigator.pop(context);
          },
          style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Create', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }
}

// ── Onboarding View ─────────────────────────────────────────────────────────

class _OnboardingView extends ConsumerStatefulWidget {
  const _OnboardingView();

  @override
  ConsumerState<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<_OnboardingView> {
  final _nameCtrl = TextEditingController();
  String _emoji = '🧒';

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text('💬', style: TextStyle(fontSize: 40)),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to SayMyWay',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap symbols to speak. Build sentences.\nCommunicate freely.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 15, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Avatar row
                Wrap(
                  spacing: 8,
                  children: ['🧒', '👦', '👧', '🧑', '👩', '👨'].map((e) {
                    return GestureDetector(
                      onTap: () => setState(() => _emoji = e),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _emoji == e
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _emoji == e ? AppColors.primary : AppColors.border,
                            width: 2,
                          ),
                        ),
                        child: Text(e, style: const TextStyle(fontSize: 28)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameCtrl,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 18),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: const TextStyle(color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.surfaceCard,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      final name = _nameCtrl.text.trim();
                      if (name.isEmpty) return;
                      final profile = await ref
                          .read(activeProfileProvider.notifier)
                          .createProfile(name, ProfileType.child, _emoji);
                      await ref.read(activeProfileProvider.notifier).switchProfile(profile);
                      ref.read(boardCardsProvider.notifier).refresh();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      "Let's go! 🚀",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final profile = await ref
                              .read(activeProfileProvider.notifier)
                              .createProfile('Guest', ProfileType.child, _emoji);
                          await ref.read(activeProfileProvider.notifier).switchProfile(profile);
                          ref.read(boardCardsProvider.notifier).refresh();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: const Icon(Icons.fast_forward_rounded, color: AppColors.textSecondary, size: 20),
                        label: const Text(
                          'Skip',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.redAccent, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: const Icon(Icons.exit_to_app_rounded, color: Colors.redAccent, size: 20),
                        label: const Text(
                          'Exit App',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }
}
