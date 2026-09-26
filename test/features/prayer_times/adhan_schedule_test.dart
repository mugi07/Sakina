import 'package:flutter_test/flutter_test.dart';
import 'package:sakina/core/location/saved_location.dart';
import 'package:sakina/core/settings/app_settings.dart';
import 'package:sakina/features/prayer_times/domain/adhan_schedule.dart';
import 'package:sakina/features/prayer_times/domain/prayer_calculator.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

void main() {

  const casablanca = SavedLocation(
    latitude: 33.5883,
    longitude: -7.6114,
    timezone: 'Africa/Casablanca',
    countryCode: 'MA',
  );
  final calculator = PrayerCalculator(
    casablanca,
    PrayerConfig.resolve(const AppSettings(), casablanca),
  );
  // 26 septembre 2026, 14:00 à Casablanca (après le Dhuhr, avant l'Asr).
  late tz.TZDateTime now;

  setUpAll(() {
    tzdata.initializeTimeZones();
    now = tz.TZDateTime(tz.getLocation('Africa/Casablanca'), 2026, 9, 26, 14);
  });

  test('uniquement des horaires futurs, triés, sans le lever du soleil', () {
    final schedule = buildAdhanSchedule(calculator: calculator, now: now, muted: const {});
    expect(schedule.first.salah, Salah.asr);
    expect(schedule.every((n) => n.fireAt.isAfter(now)), isTrue);
    expect(schedule.any((n) => n.salah == Salah.sunrise), isFalse);
    for (var i = 1; i < schedule.length; i++) {
      expect(schedule[i].fireAt.isBefore(schedule[i - 1].fireAt), isFalse);
    }
  });

  test('limite iOS : jamais plus que maxCount notifications', () {
    final schedule = buildAdhanSchedule(
      calculator: calculator,
      now: now,
      muted: const {},
      reminderMinutes: 10,
      maxCount: 60,
    );
    expect(schedule, hasLength(60));
  });

  test('une prière désactivée n\'est jamais programmée', () {
    final schedule = buildAdhanSchedule(
      calculator: calculator,
      now: now,
      muted: const {Salah.fajr, Salah.isha},
    );
    expect(schedule.map((n) => n.salah).toSet(), {Salah.dhuhr, Salah.asr, Salah.maghrib});
  });

  test('rappel : X minutes avant, lié à la même prière', () {
    final schedule = buildAdhanSchedule(
      calculator: calculator,
      now: now,
      muted: const {},
      reminderMinutes: 15,
      days: 1,
    );
    final reminder = schedule.firstWhere((n) => n.isReminder);
    expect(reminder.prayerTime.difference(reminder.fireAt), const Duration(minutes: 15));
  });

  test('identifiants uniques et stables', () {
    final a = buildAdhanSchedule(
      calculator: calculator,
      now: now,
      muted: const {},
      reminderMinutes: 5,
    );
    final b = buildAdhanSchedule(
      calculator: calculator,
      now: now,
      muted: const {},
      reminderMinutes: 5,
    );
    expect(a.map((n) => n.id).toSet(), hasLength(a.length));
    expect(a.map((n) => n.id), b.map((n) => n.id));
    expect(a.every((n) => n.id > 0 && n.id < 0x7fffffff), isTrue);
  });
}
