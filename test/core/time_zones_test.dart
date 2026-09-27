import 'package:flutter_test/flutter_test.dart';
import 'package:sakina/core/location/saved_location.dart';
import 'package:sakina/core/settings/app_settings.dart';
import 'package:sakina/core/time/time_zones.dart';
import 'package:sakina/features/prayer_times/domain/prayer_calculator.dart';
import 'package:timezone/timezone.dart' as tz;

void main() {
  setUpAll(initTimeZones);

  Duration offset(String zone, DateTime utc) =>
      tz.getLocation(zone).timeZone(utc.millisecondsSinceEpoch).offset;

  test('Maroc : GMT+1 jusqu\'au 20 septembre 2026 à 02:00, puis GMT pour de bon', () {
    for (final zone in ['Africa/Casablanca', 'Africa/El_Aaiun']) {
      // Historique conservé : +01, et +00 pendant le Ramadan 2026.
      expect(offset(zone, DateTime.utc(2026, 1, 10)), const Duration(hours: 1));
      expect(offset(zone, DateTime.utc(2026, 3, 1)), Duration.zero);
      expect(offset(zone, DateTime.utc(2026, 9, 20, 0, 59)), const Duration(hours: 1));
      // Retour à GMT, sans plus aucun changement (ni été, ni Ramadan).
      expect(offset(zone, DateTime.utc(2026, 9, 20, 1)), Duration.zero);
      for (final month in [1, 3, 6, 9, 12]) {
        expect(offset(zone, DateTime.utc(2027, month, 15)), Duration.zero);
        expect(offset(zone, DateTime.utc(2030, month, 15)), Duration.zero);
      }
    }
    // Les autres fuseaux ne bougent pas.
    expect(offset('Europe/Paris', DateTime.utc(2027, 6, 15)), const Duration(hours: 2));
    expect(offset('Africa/Algiers', DateTime.utc(2027, 6, 15)), const Duration(hours: 1));
  });

  test('une deuxième initialisation ne change rien', () {
    initTimeZones();
    expect(offset('Africa/Casablanca', DateTime.utc(2027, 6, 15)), Duration.zero);
    expect(offset('Africa/Casablanca', DateTime.utc(2026, 9, 1)), const Duration(hours: 1));
  });

  test('Casablanca, 27 septembre 2026 : horaires en heure GMT', () {
    const casablanca = SavedLocation(
      latitude: 33.5883,
      longitude: -7.6114,
      timezone: 'Africa/Casablanca',
      countryCode: 'MA',
      name: 'Casablanca',
    );
    final calculator = PrayerCalculator(
      casablanca,
      PrayerConfig.resolve(const AppSettings(), casablanca),
    );
    final day = calculator.forDay(DateTime(2026, 9, 27));
    // Dhuhr à 12:26 heure locale (et non plus 13:26), à la même seconde UTC.
    expect((day[Salah.dhuhr].hour, day[Salah.dhuhr].minute), (12, 26));
    expect(day[Salah.dhuhr].timeZoneOffset, Duration.zero);
    expect(day[Salah.fajr].hour, 4);
  });
}
