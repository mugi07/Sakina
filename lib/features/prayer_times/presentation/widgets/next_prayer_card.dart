import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/prayer_providers.dart';
import '../../domain/prayer_calculator.dart';
import '../prayer_labels.dart';

/// Carte « Prochaine prière » avec compte à rebours et frise des cinq prières.
/// Affiche une invitation à choisir un lieu s'il n'y en a pas encore.
class NextPrayerCard extends ConsumerWidget {
  const NextPrayerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculator = ref.watch(prayerCalculatorProvider);
    if (calculator == null) return const _NoLocationCard();

    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final now = ref.watch(clockProvider).value ?? DateTime.now();
    final next = ref.watch(nextPrayerProvider)!;
    final day = calculator.forDay(calculator.localToday(now));
    final scheme = Theme.of(context).colorScheme;
    final onPrimary = scheme.onPrimary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [scheme.primary, Color.lerp(scheme.primary, Colors.black, 0.35)!],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.nextPrayer, style: TextStyle(color: onPrimary.withValues(alpha: 0.8))),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                l.salahName(next.salah),
                style: TextStyle(color: onPrimary, fontSize: 30, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                formatTime(next.time, locale),
                style: TextStyle(color: onPrimary, fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text(
            l.timeRemaining(formatCountdown(next.time.difference(now), locale)),
            style: TextStyle(
              color: onPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (final salah in Salah.values.where((s) => s.isPrayer))
                Expanded(
                  child: _PrayerChip(
                    label: l.salahName(salah),
                    time: formatTime(day[salah], locale),
                    highlighted: salah == next.salah,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrayerChip extends StatelessWidget {
  const _PrayerChip({required this.label, required this.time, required this.highlighted});

  final String label;
  final String time;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: highlighted ? onPrimary.withValues(alpha: 0.18) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: onPrimary.withValues(alpha: 0.85), fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            time,
            style: TextStyle(color: onPrimary, fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _NoLocationCard extends StatelessWidget {
  const _NoLocationCard();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.noLocationTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(l.noLocationBody),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => context.push('/location'),
              icon: const Icon(Icons.location_on_outlined),
              label: Text(l.chooseLocation),
            ),
          ],
        ),
      ),
    );
  }
}
