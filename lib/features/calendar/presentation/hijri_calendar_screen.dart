import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/calendar/hijri_date.dart';
import '../../../core/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/islamic_events.dart';

/// Calendrier hégirien (Umm al-Qura, avec l'ajustement des réglages) :
/// grille du mois, événements et jours de jeûne recommandés.
class HijriCalendarScreen extends ConsumerStatefulWidget {
  const HijriCalendarScreen({super.key});

  @override
  ConsumerState<HijriCalendarScreen> createState() => _HijriCalendarScreenState();
}

class _HijriCalendarScreenState extends ConsumerState<HijriCalendarScreen> {
  int _monthOffset = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final lang = Localizations.localeOf(context).languageCode;
    final adjustment = ref.watch(settingsProvider.select((s) => s.hijriOffset));
    final scheme = Theme.of(context).colorScheme;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayHijri = HijriDate.fromGregorian(today, adjustmentDays: adjustment);
    final month = HijriDate(todayHijri.year, todayHijri.month, 1).addMonths(_monthOffset);
    final length = HijriDate.daysInMonth(month.year, month.month);
    final firstGregorian = month.toGregorian(adjustmentDays: adjustment);
    final lastGregorian = HijriDate(
      month.year,
      month.month,
      length,
    ).toGregorian(adjustmentDays: adjustment);

    final monthEvents = [
      for (var d = 1; d <= length; d++)
        for (final e in eventsOn(HijriDate(month.year, month.month, d))) (event: e, day: d),
    ];
    final upcoming = upcomingEvents(today, adjustmentDays: adjustment);

    return Scaffold(
      appBar: AppBar(title: Text(l.hijriCalendar)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: l.previousMonth,
                onPressed: () => setState(() => _monthOffset--),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _monthOffset = 0),
                  child: Column(
                    children: [
                      Text(
                        '${month.monthName(lang)} ${month.year}',
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(color: scheme.primary),
                      ),
                      Text(
                        _gregorianSpan(firstGregorian, lastGregorian, locale),
                        style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                tooltip: l.nextMonth,
                onPressed: () => setState(() => _monthOffset++),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _MonthGrid(month: month, length: length, adjustment: adjustment, today: todayHijri),
          const SizedBox(height: 8),
          Row(
            children: [
              _Dot(color: scheme.tertiary),
              const SizedBox(width: 6),
              Expanded(child: Text(l.whiteDays, style: const TextStyle(fontSize: 12))),
            ],
          ),
          if (monthEvents.isNotEmpty) ...[
            _SectionTitle(l.eventsThisMonth),
            for (final (:event, :day) in monthEvents)
              _EventTile(
                event: event,
                hijri: HijriDate(month.year, month.month, day),
                date: HijriDate(
                  month.year,
                  month.month,
                  day,
                ).toGregorian(adjustmentDays: adjustment),
                today: today,
              ),
          ],
          _SectionTitle(l.upcomingEvents),
          for (final u in upcoming)
            _EventTile(event: u.event, hijri: u.hijri, date: u.date, today: today),
        ],
      ),
    );
  }

  String _gregorianSpan(DateTime first, DateTime last, String locale) {
    if (first.year == last.year) {
      return first.month == last.month
          ? DateFormat.yMMMM(locale).format(first)
          : '${DateFormat.MMMM(locale).format(first)} – ${DateFormat.yMMMM(locale).format(last)}';
    }
    return '${DateFormat.yMMM(locale).format(first)} – ${DateFormat.yMMM(locale).format(last)}';
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.length,
    required this.adjustment,
    required this.today,
  });

  final HijriDate month;
  final int length;
  final int adjustment;
  final HijriDate today;

  @override
  Widget build(BuildContext context) {
    final material = MaterialLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final firstDayIndex = material.firstDayOfWeekIndex; // 0 = dimanche
    final first = month.toGregorian(adjustmentDays: adjustment);
    final leading = (first.weekday % 7 - firstDayIndex + 7) % 7;
    final weekdays = [for (var i = 0; i < 7; i++) material.narrowWeekdays[(firstDayIndex + i) % 7]];
    final cells = <Widget>[
      for (var i = 0; i < leading; i++) const SizedBox.shrink(),
      for (var d = 1; d <= length; d++)
        _DayCell(
          hijri: HijriDate(month.year, month.month, d),
          gregorianDay: HijriDate(
            month.year,
            month.month,
            d,
          ).toGregorian(adjustmentDays: adjustment).day,
          isToday: HijriDate(month.year, month.month, d) == today,
        ),
    ];
    while (cells.length % 7 != 0) {
      cells.add(const SizedBox.shrink());
    }

    return Column(
      children: [
        Row(
          children: [
            for (final w in weekdays)
              Expanded(
                child: Center(
                  child: Text(
                    w,
                    style: TextStyle(fontWeight: FontWeight.w700, color: scheme.onSurfaceVariant),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        for (var row = 0; row < cells.length ~/ 7; row++)
          Row(
            children: [
              for (var col = 0; col < 7; col++)
                Expanded(child: AspectRatio(aspectRatio: 0.9, child: cells[row * 7 + col])),
            ],
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.hijri, required this.gregorianDay, required this.isToday});

  final HijriDate hijri;
  final int gregorianDay;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final events = eventsOn(hijri);
    final hasEvent = events.isNotEmpty;
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isToday
            ? scheme.primary
            : (hasEvent ? scheme.tertiary.withValues(alpha: 0.18) : null),
        borderRadius: BorderRadius.circular(10),
        border: hasEvent && !isToday ? Border.all(color: scheme.tertiary) : null,
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${hijri.day}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isToday ? scheme.onPrimary : null,
                  ),
                ),
                Text(
                  '$gregorianDay',
                  style: TextStyle(
                    fontSize: 10,
                    color: isToday
                        ? scheme.onPrimary.withValues(alpha: 0.85)
                        : scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (isWhiteDay(hijri))
            PositionedDirectional(
              top: 4,
              end: 4,
              child: _Dot(color: isToday ? scheme.onPrimary : scheme.tertiary),
            ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 6,
    height: 6,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(8, 20, 8, 6),
    child: Text(
      text,
      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
    ),
  );
}

class _EventTile extends StatelessWidget {
  const _EventTile({
    required this.event,
    required this.hijri,
    required this.date,
    required this.today,
  });

  final IslamicEvent event;
  final HijriDate hijri;
  final DateTime date;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final scheme = Theme.of(context).colorScheme;
    final days = date.difference(today).inDays;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          event.fasting ? Icons.nights_stay_outlined : Icons.event_outlined,
          color: scheme.tertiary,
        ),
        title: Text(l.eventName(event.name), style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          [
            hijri.format(locale),
            DateFormat.yMMMEd(locale).format(date),
            if (event.fasting) l.fastingRecommended,
          ].join(' · '),
        ),
        trailing: days >= 0
            ? Text(
                l.inDays(days),
                style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600, fontSize: 12),
              )
            : null,
      ),
    );
  }
}
