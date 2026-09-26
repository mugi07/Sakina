import 'package:flutter_test/flutter_test.dart';
import 'package:sakina/core/calendar/hijri_date.dart';
import 'package:sakina/features/asma_husna/domain/asma_husna.dart';
import 'package:sakina/features/calendar/domain/islamic_events.dart';

void main() {
  group('calendrier hégirien (Umm al-Qura)', () {
    test('conversion aller-retour sur 1447 et 1448, avec ou sans ajustement', () {
      for (final adjustment in [-1, 0, 1]) {
        for (final year in [1447, 1448]) {
          for (var month = 1; month <= 12; month++) {
            for (var day = 1; day <= HijriDate.daysInMonth(year, month); day++) {
              final h = HijriDate(year, month, day);
              final g = h.toGregorian(adjustmentDays: adjustment);
              expect(
                HijriDate.fromGregorian(g, adjustmentDays: adjustment),
                h,
                reason: '$h ajustement $adjustment',
              );
            }
          }
        }
      }
    });

    test('mois de 29 ou 30 jours, année de 354 ou 355 jours', () {
      for (final year in [1447, 1448]) {
        var total = 0;
        for (var month = 1; month <= 12; month++) {
          final days = HijriDate.daysInMonth(year, month);
          expect(days, inInclusiveRange(29, 30));
          total += days;
        }
        expect(total, inInclusiveRange(354, 355));
      }
    });

    test('1er Mouharram 1448 : mi-juin 2026', () {
      final g = const HijriDate(1448, 1, 1).toGregorian();
      expect(g.isAfter(DateTime(2026, 6, 14)) && g.isBefore(DateTime(2026, 6, 18)), isTrue);
    });

    test('addMonths passe d\'une année à l\'autre', () {
      expect(const HijriDate(1447, 12, 20).addMonths(1), const HijriDate(1448, 1, 1));
      expect(const HijriDate(1448, 1, 5).addMonths(-1), const HijriDate(1447, 12, 1));
    });
  });

  group('événements', () {
    test('prochains événements : futurs, dans l\'ordre', () {
      final today = DateTime(2026, 9, 26); // 15 Rabi' ath-thani 1448
      final events = upcomingEvents(today);
      expect(events, hasLength(6));
      expect(events.first.event, IslamicEvent.israMiraj);
      expect(events.first.hijri, const HijriDate(1448, 7, 27));
      for (var i = 0; i < events.length; i++) {
        expect(events[i].date.isBefore(today), isFalse);
        if (i > 0) expect(events[i].date.isBefore(events[i - 1].date), isFalse);
      }
      expect(events.map((e) => e.event), contains(IslamicEvent.ramadanStart));
    });

    test('un événement le jour même est inclus', () {
      final ramadan = const HijriDate(1448, 9, 1).toGregorian();
      expect(upcomingEvents(ramadan).first.event, IslamicEvent.ramadanStart);
    });

    test('jours blancs', () {
      expect(isWhiteDay(const HijriDate(1448, 4, 14)), isTrue);
      expect(isWhiteDay(const HijriDate(1448, 4, 16)), isFalse);
      expect(isWhiteDay(const HijriDate(1448, 12, 13)), isFalse);
      expect(eventsOn(const HijriDate(1448, 12, 9)), [IslamicEvent.arafah]);
    });
  });

  test('99 noms : complets et sans doublon', () {
    expect(asmaUlHusna, hasLength(99));
    expect(asmaUlHusna.map((n) => n.arabic).toSet(), hasLength(99));
    for (final n in asmaUlHusna) {
      expect([n.arabic, n.transliteration, n.fr, n.en].every((s) => s.trim().isNotEmpty), isTrue);
    }
  });
}
