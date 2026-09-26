import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../quran/domain/page_layout.dart';
import '../../quran/presentation/quran_index_screen.dart';
import '../application/khatma_controller.dart';
import '../domain/khatma_plan.dart';

/// Heures proposées pour le rappel quotidien (minutes depuis minuit).
const _reminderChoices = <int?>[null, 6 * 60, 9 * 60, 13 * 60, 17 * 60, 20 * 60, 22 * 60];

String _formatMinutes(BuildContext context, int minutes) => MaterialLocalizations.of(context)
    .formatTimeOfDay(
      TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
      alwaysUse24HourFormat: true,
    );

/// Khatma : lire tout le Coran en un nombre de jours choisi.
class KhatmaScreen extends ConsumerWidget {
  const KhatmaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final plan = ref.watch(khatmaProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.khatmaTitle)),
      body: plan == null || plan.isCompleted
          ? _NewKhatma(completed: plan)
          : _ActiveKhatma(plan: plan),
    );
  }
}

class _NewKhatma extends ConsumerStatefulWidget {
  const _NewKhatma({required this.completed});

  /// Khatma qui vient d'être terminée (pour féliciter), sinon null.
  final KhatmaPlan? completed;

  @override
  ConsumerState<_NewKhatma> createState() => _NewKhatmaState();
}

class _NewKhatmaState extends ConsumerState<_NewKhatma> {
  int _days = 30;
  bool _fromLastRead = false;
  int? _reminder = 20 * 60;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final lastRead = ref.watch(settingsProvider.select((s) => s.lastReadPage));
    final startPage = _fromLastRead && lastRead != null ? lastRead : 1;
    final preview = KhatmaPlan(startDate: DateTime.now(), days: _days, startPage: startPage);
    final done = widget.completed;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        if (done != null) ...[
          Icon(Icons.celebration_outlined, size: 56, color: scheme.tertiary),
          const SizedBox(height: 8),
          Text(
            l.khatmaCompleted,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: scheme.primary),
          ),
          Text(
            l.khatmaCompletedCount(done.completedCount),
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
          const Divider(height: 40),
        ],
        Text(l.khatmaIntro, style: TextStyle(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 20),
        Text(l.khatmaDuration, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final d in khatmaDurations)
              ChoiceChip(
                label: Text(l.khatmaDays(d)),
                selected: _days == d,
                onSelected: (_) => setState(() => _days = d),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Text(l.khatmaStartFrom, style: const TextStyle(fontWeight: FontWeight.w700)),
        RadioGroup<bool>(
          groupValue: _fromLastRead,
          onChanged: (v) => setState(() => _fromLastRead = v ?? false),
          child: Column(
            children: [
              RadioListTile<bool>(value: false, title: Text(l.khatmaFromBeginning)),
              if (lastRead != null && lastRead > 1)
                RadioListTile<bool>(value: true, title: Text(l.khatmaFromPage(lastRead))),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(l.khatmaReminder, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final r in _reminderChoices)
              ChoiceChip(
                label: Text(r == null ? l.khatmaReminderOff : _formatMinutes(context, r)),
                selected: _reminder == r,
                onSelected: (_) => setState(() => _reminder = r),
              ),
          ],
        ),
        const SizedBox(height: 24),
        Card(
          child: ListTile(
            leading: Icon(Icons.menu_book_outlined, color: scheme.primary),
            title: Text(l.khatmaPagesPerDay(preview.pagesPerDay)),
            subtitle: Text(l.khatmaProgress(0, preview.totalPages)),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => ref
              .read(khatmaProvider.notifier)
              .start(days: _days, startPage: startPage, reminderMinutes: _reminder),
          icon: const Icon(Icons.flag_outlined),
          label: Text(done == null ? l.khatmaStart : l.khatmaRestart),
        ),
      ],
    );
  }
}

class _ActiveKhatma extends ConsumerWidget {
  const _ActiveKhatma({required this.plan});

  final KhatmaPlan plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final today = DateTime.now();
    final status = plan.status(today);
    final nextPage = (plan.lastPageRead + 1).clamp(1, mushafPageCount);
    final statusText = switch (status) {
      KhatmaStatus.behind => l.khatmaBehind(plan.pagesBehind(today)),
      KhatmaStatus.ahead => l.khatmaAhead,
      KhatmaStatus.onTrack => l.khatmaOnTrack,
      KhatmaStatus.completed => l.khatmaCompleted,
    };
    final statusColor = status == KhatmaStatus.behind ? scheme.error : scheme.primary;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        Center(
          child: SizedBox.square(
            dimension: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: CircularProgressIndicator(
                    value: plan.progress,
                    strokeWidth: 12,
                    backgroundColor: scheme.primary.withValues(alpha: 0.12),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(plan.progress * 100).round()} %',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                      ),
                    ),
                    Text(
                      l.khatmaProgress(plan.pagesRead, plan.totalPages),
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l.khatmaDayOf(plan.dayNumber(today), plan.days),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          statusText,
          textAlign: TextAlign.center,
          style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: Icon(Icons.today_outlined, color: scheme.tertiary),
            title: Text(l.khatmaTodayGoal(plan.targetPage(today))),
            subtitle: Text(l.khatmaRemainingToday(plan.remainingToday(today))),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => openMushafPage(context, nextPage),
          icon: const Icon(Icons.menu_book),
          label: Text(l.khatmaContinue(nextPage)),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _setLastPage(context, ref),
          icon: const Icon(Icons.edit_outlined),
          label: Text(l.khatmaSetPage),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.alarm),
          title: Text(l.khatmaReminder),
          subtitle: Text(
            plan.reminderMinutes == null
                ? l.khatmaReminderOff
                : _formatMinutes(context, plan.reminderMinutes!),
          ),
          onTap: () => _pickReminder(context, ref),
        ),
        ListTile(
          leading: Icon(Icons.stop_circle_outlined, color: scheme.error),
          title: Text(l.khatmaStop, style: TextStyle(color: scheme.error)),
          onTap: () => _confirmStop(context, ref),
        ),
      ],
    );
  }

  Future<void> _setLastPage(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final input = TextEditingController(text: '${plan.lastPageRead.clamp(1, mushafPageCount)}');
    final page = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.khatmaSetPage),
        content: TextField(
          controller: input,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(helperText: '1 – $mushafPageCount'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.cancel)),
          FilledButton(
            onPressed: () {
              final n = int.tryParse(input.text.trim());
              if (n != null && n >= 1 && n <= mushafPageCount) Navigator.of(context).pop(n);
            },
            child: Text(l.confirm),
          ),
        ],
      ),
    );
    input.dispose();
    if (page != null) ref.read(khatmaProvider.notifier).markReadUpTo(page);
  }

  Future<void> _pickReminder(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final picked = await showDialog<({int? minutes})>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l.khatmaReminder),
        children: [
          for (final r in _reminderChoices)
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop((minutes: r)),
              child: Text(r == null ? l.khatmaReminderOff : _formatMinutes(context, r)),
            ),
        ],
      ),
    );
    if (picked != null) ref.read(khatmaProvider.notifier).setReminder(picked.minutes);
  }

  Future<void> _confirmStop(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l.khatmaStopConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l.confirm)),
        ],
      ),
    );
    if (ok ?? false) ref.read(khatmaProvider.notifier).stop();
  }
}
