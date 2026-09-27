import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina/core/providers.dart';
import 'package:sakina/core/time/time_zones.dart';
import 'package:sakina/features/khatma/application/khatma_controller.dart';
import 'package:sakina/features/khatma/domain/khatma_plan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

void main() {
  final start = DateTime(2026, 9, 26);
  DateTime day(int n) => DateTime(2026, 9, 25 + n); // day(1) = start

  group('plan', () {
    test('30 jours : 21 pages par jour, objectif cumulé', () {
      final plan = KhatmaPlan(startDate: start, days: 30);
      expect(plan.pagesPerDay, 21); // 604 / 30 = 20,13 → 21
      expect(plan.targetPage(day(1)), 21);
      expect(plan.targetPage(day(10)), 210);
      expect(plan.targetPage(day(30)), 604);
      expect(plan.targetPage(day(45)), 604);
      expect(plan.endDate, DateTime(2026, 10, 25));
    });

    test('en avance, à jour, en retard', () {
      final plan = KhatmaPlan(startDate: start, days: 30);
      expect(plan.status(day(1)), KhatmaStatus.onTrack);
      expect(plan.remainingToday(day(1)), 21);
      expect(plan.copyWith(lastPageRead: 25).status(day(1)), KhatmaStatus.ahead);
      // Jour 3 sans avoir lu : 42 pages de retard sur l'objectif d'hier.
      expect(plan.status(day(3)), KhatmaStatus.behind);
      expect(plan.pagesBehind(day(3)), 42);
      expect(plan.remainingToday(day(3)), 63);
    });

    test('à partir d\'une page donnée', () {
      final plan = KhatmaPlan(startDate: start, days: 10, startPage: 305);
      expect(plan.totalPages, 300);
      expect(plan.pagesPerDay, 30);
      expect(plan.lastPageRead, 304);
      expect(plan.targetPage(day(1)), 334);
    });

    test('aller-retour JSON', () {
      final plan = KhatmaPlan(
        startDate: start,
        days: 15,
        lastPageRead: 100,
        reminderMinutes: 1260,
        completedCount: 2,
      );
      final back = KhatmaPlan.fromJson(plan.toJson());
      expect(
        (back.startDate, back.days, back.lastPageRead, back.reminderMinutes, back.completedCount),
        (start, 15, 100, 1260, 2),
      );
    });
  });

  group('suivi', () {
    late ProviderContainer c;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      c = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
      c.read(khatmaProvider.notifier).now = () => start;
    });
    tearDown(() => c.dispose());

    test('la lecture ne recule jamais, la fin est détectée une seule fois', () {
      final khatma = c.read(khatmaProvider.notifier)..start(days: 30);
      expect(khatma.markReadUpTo(50), isFalse);
      expect(khatma.markReadUpTo(20), isFalse);
      expect(c.read(khatmaProvider)!.lastPageRead, 50);
      expect(khatma.markReadUpTo(604), isTrue);
      expect(c.read(khatmaProvider)!.completedCount, 1);
      expect(khatma.markReadUpTo(604), isFalse);
    });

    test('une nouvelle khatma garde le compteur des précédentes', () {
      final khatma = c.read(khatmaProvider.notifier)..start(days: 7);
      khatma.markReadUpTo(604);
      khatma.start(days: 30);
      final plan = c.read(khatmaProvider)!;
      expect((plan.completedCount, plan.lastPageRead, plan.days), (1, 0, 30));
      khatma.stop();
      expect(c.read(khatmaProvider), isNull);
    });
  });

  test("rappels : à l'heure choisie, jusqu'à la fin du plan, pas après la fin", () {
    initTimeZones();
    final zone = tz.getLocation('Africa/Casablanca');
    final plan = KhatmaPlan(startDate: start, days: 3, reminderMinutes: 20 * 60);
    // 26 septembre, 21 h à Casablanca : le rappel du jour est passé.
    final now = tz.TZDateTime(zone, 2026, 9, 26, 21);
    final times = khatmaReminderTimes(plan, zone, now);
    expect(times.map((t) => (t.day, t.hour, t.minute)), [(27, 20, 0), (28, 20, 0)]);
    expect(khatmaReminderTimes(plan.copyWith(reminderMinutes: null), zone, now), isEmpty);
    expect(khatmaReminderTimes(plan.copyWith(lastPageRead: 604), zone, now), isEmpty);
  });
}
