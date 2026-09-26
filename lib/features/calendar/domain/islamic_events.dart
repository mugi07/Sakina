import '../../../core/calendar/hijri_date.dart';

/// Dates marquantes du calendrier hégirien (jour et mois fixes).
enum IslamicEvent {
  newYear(1, 1),
  ashura(1, 10, fasting: true),
  mawlid(3, 12),
  israMiraj(7, 27),
  ramadanStart(9, 1),
  lastTenNights(9, 21),
  eidAlFitr(10, 1),
  dhulHijjahTenDays(12, 1),
  arafah(12, 9, fasting: true),
  eidAlAdha(12, 10);

  const IslamicEvent(this.month, this.day, {this.fasting = false});

  final int month;
  final int day;

  /// Jour où le jeûne volontaire est recommandé.
  final bool fasting;
}

/// Jours blancs (13, 14, 15 de chaque mois) : jeûne volontaire recommandé,
/// sauf le 13 Dhou al-hijja (jour de Tashriq).
bool isWhiteDay(HijriDate date) =>
    date.day >= 13 && date.day <= 15 && !(date.month == 12 && date.day == 13);

List<IslamicEvent> eventsOn(HijriDate date) => [
  for (final e in IslamicEvent.values)
    if (e.month == date.month && e.day == date.day) e,
];

typedef UpcomingEvent = ({IslamicEvent event, HijriDate hijri, DateTime date});

/// Prochaines occurrences des événements à partir d'aujourd'hui (inclus),
/// dans l'ordre chronologique.
List<UpcomingEvent> upcomingEvents(DateTime today, {int adjustmentDays = 0, int count = 6}) {
  final day = DateTime(today.year, today.month, today.day);
  final year = HijriDate.fromGregorian(day, adjustmentDays: adjustmentDays).year;
  final result = <UpcomingEvent>[
    for (final y in [year, year + 1])
      for (final e in IslamicEvent.values)
        (
          event: e,
          hijri: HijriDate(y, e.month, e.day),
          date: HijriDate(y, e.month, e.day).toGregorian(adjustmentDays: adjustmentDays),
        ),
  ]..removeWhere((u) => u.date.isBefore(day));
  result.sort((a, b) => a.date.compareTo(b.date));
  return result.take(count).toList();
}
