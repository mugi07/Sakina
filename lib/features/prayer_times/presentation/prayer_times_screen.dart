import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/calendar/hijri_date.dart';
import '../../../core/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../qibla/presentation/qibla_card.dart';
import '../application/prayer_providers.dart';
import '../domain/prayer_calculator.dart';
import 'prayer_labels.dart';
import 'widgets/location_header.dart';
import 'widgets/next_prayer_card.dart';

/// Onglet « Prière » : horaires du jour (ou d'un autre jour), prochaine
/// prière, méthode utilisée et direction de la Qibla.
class PrayerTimesScreen extends ConsumerStatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  ConsumerState<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends ConsumerState<PrayerTimesScreen> {
  /// Décalage en jours par rapport à aujourd'hui.
  int _dayOffset = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final calculator = ref.watch(prayerCalculatorProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.prayerTimesTitle),
        actions: [
          IconButton(
            tooltip: l.qiblaCompassTitle,
            icon: const Icon(Icons.explore_outlined),
            onPressed: () => openQiblaCompass(context),
          ),
          IconButton(
            tooltip: l.monthlyTimetable,
            icon: const Icon(Icons.calendar_view_month),
            onPressed: () => context.go('/prayer/month'),
          ),
          IconButton(
            tooltip: l.settingsTitle,
            icon: const Icon(Icons.tune),
            onPressed: () => context.go('/more/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: calculator == null ? const [NextPrayerCard()] : _content(context, l, calculator),
      ),
    );
  }

  List<Widget> _content(BuildContext context, AppLocalizations l, PrayerCalculator calculator) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final settings = ref.watch(settingsProvider);
    final now = ref.watch(clockProvider).value ?? DateTime.now();
    final today = calculator.localToday(now);
    final date = DateTime(today.year, today.month, today.day + _dayOffset);
    final day = calculator.forDay(date);
    final next = _dayOffset == 0 ? ref.watch(nextPrayerProvider) : null;
    final hijri = HijriDate.fromGregorian(date, adjustmentDays: settings.hijriAdjustment);
    final config = calculator.config;
    final scheme = Theme.of(context).colorScheme;

    return [
      const LocationHeader(),
      const SizedBox(height: 12),
      if (_dayOffset == 0) ...[const NextPrayerCard(), const SizedBox(height: 16)],
      Row(
        children: [
          IconButton(
            tooltip: l.previousDay,
            onPressed: () => setState(() => _dayOffset--),
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _dayOffset = 0),
              child: Column(
                children: [
                  Text(
                    _dayOffset == 0 ? l.today : DateFormat.yMMMMEEEEd(locale).format(date),
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (_dayOffset == 0)
                    Text(
                      DateFormat.yMMMMEEEEd(locale).format(date),
                      style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  Text(
                    hijri.format(locale),
                    style: TextStyle(color: scheme.tertiary, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: l.nextDay,
            onPressed: () => setState(() => _dayOffset++),
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Card(
        child: Column(
          children: [
            for (final salah in Salah.values)
              ListTile(
                leading: Icon(
                  salahIcon(salah),
                  color: salah == next?.salah ? scheme.primary : scheme.onSurfaceVariant,
                ),
                title: Text(
                  l.salahName(salah),
                  style: TextStyle(
                    fontWeight: salah == next?.salah ? FontWeight.w700 : FontWeight.w400,
                    color: salah.isPrayer ? null : scheme.onSurfaceVariant,
                  ),
                ),
                trailing: Text(
                  formatTime(day[salah], locale),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: salah == next?.salah ? FontWeight.w700 : FontWeight.w500,
                    color: salah == next?.salah ? scheme.primary : null,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          '${l.methodSummary(l.methodName(config.method))} — ${l.methodAngles(config.method, locale)}\n'
          '${l.asrSummary(l.madhabName(config.madhab))}',
          style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
        ),
      ),
      const SizedBox(height: 16),
      QiblaCard(location: calculator.location),
    ];
  }
}
