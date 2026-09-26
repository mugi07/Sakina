import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../application/tasbih_controller.dart';

extension DhikrLabels on AppLocalizations {
  String dhikrMeaning(DhikrPhrase phrase) => switch (phrase) {
    DhikrPhrase.subhanallah => phraseSubhanallah,
    DhikrPhrase.alhamdulillah => phraseAlhamdulillah,
    DhikrPhrase.allahuakbar => phraseAllahuakbar,
    DhikrPhrase.lailaha => phraseLailaha,
    DhikrPhrase.astaghfirullah => phraseAstaghfirullah,
    DhikrPhrase.salawat => phraseSalawat,
  };
}

/// Compteur de dhikr : un grand cercle à toucher, avec vibration à chaque
/// compte et plus forte quand l'objectif est atteint.
class TasbihScreen extends ConsumerWidget {
  const TasbihScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final state = ref.watch(tasbihProvider);
    final controller = ref.read(tasbihProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final isArabicUi = Localizations.localeOf(context).languageCode == 'ar';
    final progress = state.target == 0 ? null : (state.count / state.target).clamp(0.0, 1.0);

    void tap() {
      final reached = state.target > 0 && state.count + 1 == state.target;
      controller.increment();
      if (reached) {
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.selectionClick();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.tasbih),
        actions: [
          IconButton(
            tooltip: l.tasbihReset,
            icon: const Icon(Icons.restart_alt),
            onPressed: controller.reset,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  for (final p in DhikrPhrase.values)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(p.arabic, textDirection: TextDirection.rtl),
                        selected: p == state.phrase,
                        onSelected: (_) => controller.setPhrase(p),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.phrase.arabic,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontFamily: quranFontFamily, fontSize: 34, color: scheme.primary),
            ),
            if (!isArabicUi) ...[
              Text(
                state.phrase.transliteration,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              Text(l.dhikrMeaning(state.phrase), style: TextStyle(color: scheme.onSurfaceVariant)),
            ],
            Expanded(
              child: Center(
                child: Semantics(
                  button: true,
                  label: '${state.phrase.transliteration} ${state.count}',
                  child: GestureDetector(
                    onTap: tap,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: CircularProgressIndicator(
                                value: progress ?? 0,
                                strokeWidth: 10,
                                backgroundColor: scheme.primary.withValues(alpha: 0.12),
                                color: state.targetReached ? scheme.tertiary : scheme.primary,
                              ),
                            ),
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: scheme.primary.withValues(alpha: 0.06),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${state.count}',
                                  style: TextStyle(
                                    fontSize: 72,
                                    fontWeight: FontWeight.w700,
                                    color: scheme.primary,
                                    fontFeatures: const [FontFeature.tabularFigures()],
                                  ),
                                ),
                                if (state.target > 0)
                                  Text(
                                    '/ ${state.target}',
                                    style: TextStyle(fontSize: 18, color: scheme.onSurfaceVariant),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              state.targetReached ? l.tasbihCompleted : l.tasbihTapHint,
              style: TextStyle(
                color: state.targetReached ? scheme.tertiary : scheme.onSurfaceVariant,
                fontWeight: state.targetReached ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${l.tasbihTarget} : '),
                SegmentedButton<int>(
                  showSelectedIcon: false,
                  segments: [
                    for (final t in tasbihTargets)
                      ButtonSegment(value: t, label: Text(t == 0 ? l.tasbihFree : '$t')),
                  ],
                  selected: {state.target},
                  onSelectionChanged: (s) => controller.setTarget(s.first),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l.tasbihToday(state.todayTotal),
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
