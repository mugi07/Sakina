import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/calendar/hijri_date.dart';
import '../../../core/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../application/prayer_providers.dart';
import '../domain/prayer_calculator.dart';
import 'prayer_labels.dart';

/// Horaires de tous les jours d'un mois, avec la date hégirienne.
class MonthlyTimetableScreen extends ConsumerStatefulWidget {
  const MonthlyTimetableScreen({super.key});

  @override
  ConsumerState<MonthlyTimetableScreen> createState() => _MonthlyTimetableScreenState();
}

class _MonthlyTimetableScreenState extends ConsumerState<MonthlyTimetableScreen> {
  int _monthOffset = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final calculator = ref.watch(prayerCalculatorProvider);
    final hijriAdjustment = ref.watch(settingsProvider.select((s) => s.hijriAdjustment));
    final scheme = Theme.of(context).colorScheme;

    if (calculator == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.monthlyTimetable)),
        body: Center(child: Text(l.noLocationBody, textAlign: TextAlign.center)),
      );
    }

    final today = calculator.localToday(DateTime.now());
    final month = DateTime(today.year, today.month + _monthOffset);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final hijriFirst = HijriDate.fromGregorian(month, adjustmentDays: hijriAdjustment);
    final hijriLast = HijriDate.fromGregorian(
      DateTime(month.year, month.month, daysInMonth),
      adjustmentDays: hijriAdjustment,
    );
    final lang = locale.split('-').first;
    final hijriRange = hijriFirst.month == hijriLast.month
        ? '${hijriFirst.monthName(lang)} ${hijriFirst.year}'
        : '${hijriFirst.monthName(lang)} – ${hijriLast.monthName(lang)} ${hijriLast.year}';

    const columns = [Salah.fajr, Salah.sunrise, Salah.dhuhr, Salah.asr, Salah.maghrib, Salah.isha];
    final headerStyle = TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.w700,
      color: scheme.primary,
    );
    const cellStyle = TextStyle(fontSize: 12.5, fontFeatures: [FontFeature.tabularFigures()]);

    return Scaffold(
      appBar: AppBar(title: Text(l.monthlyTimetable)),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: l.previousMonth,
                onPressed: () => setState(() => _monthOffset--),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      DateFormat.yMMMM(locale).format(month),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(hijriRange, style: TextStyle(color: scheme.tertiary, fontSize: 13)),
                  ],
                ),
              ),
              IconButton(
                tooltip: l.nextMonth,
                onPressed: () => setState(() => _monthOffset++),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          Container(
            color: scheme.primary.withValues(alpha: 0.08),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text(l.dayColumn, style: headerStyle)),
                for (final s in columns)
                  Expanded(
                    flex: 2,
                    child: Text(
                      l.salahName(s),
                      style: headerStyle,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: daysInMonth,
              itemBuilder: (context, i) {
                final date = DateTime(month.year, month.month, i + 1);
                final day = calculator.forDay(date);
                final hijri = HijriDate.fromGregorian(date, adjustmentDays: hijriAdjustment);
                final isToday = date == today;
                return Container(
                  color: isToday
                      ? scheme.primary.withValues(alpha: 0.14)
                      : (i.isOdd ? scheme.surfaceContainerHighest.withValues(alpha: 0.3) : null),
                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          '${DateFormat.E(locale).format(date)} ${i + 1} · ${hijri.day}',
                          style: cellStyle.copyWith(
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                      ),
                      for (final s in columns)
                        Expanded(
                          flex: 2,
                          child: Text(
                            formatTime(day[s], locale),
                            textAlign: TextAlign.center,
                            style: cellStyle.copyWith(
                              color: s == Salah.sunrise ? scheme.onSurfaceVariant : null,
                              fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
