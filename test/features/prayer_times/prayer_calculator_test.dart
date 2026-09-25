import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:sakina/core/location/saved_location.dart';
import 'package:sakina/core/settings/app_settings.dart';
import 'package:sakina/features/prayer_times/domain/method_defaults.dart';
import 'package:sakina/features/prayer_times/domain/prayer_calculator.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

PrayerCalculator _calculator({
  required double lat,
  required double lng,
  required String timezone,
  String country = '',
  CalculationMethod? method,
  Madhab? madhab,
}) {
  final location = SavedLocation(
    latitude: lat,
    longitude: lng,
    timezone: timezone,
    countryCode: country,
  );
  final settings = AppSettings(calculationMethod: method, madhab: madhab);
  return PrayerCalculator(location, PrayerConfig.resolve(settings, location));
}

Map<Salah, String> _hm(DayPrayerTimes day) => {
  for (final s in Salah.values) s: DateFormat('HH:mm').format(day[s]),
};

void main() {
  setUpAll(tzdata.initializeTimeZones);

  // Valeurs de référence de la suite de tests d'Adhan (batoulapps/adhan-js),
  // recoupées avec des calendriers publiés. Elles vérifient aussi que la
  // conversion vers le fuseau du lieu ne dépend pas du fuseau du téléphone.
  group('horaires de référence', () {
    test('Raleigh, Amérique du Nord (ISNA), Asr hanafite, 12 juillet 2015', () {
      final c = _calculator(
        lat: 35.775,
        lng: -78.6336,
        timezone: 'America/New_York',
        method: CalculationMethod.northAmerica,
        madhab: Madhab.hanafi,
      );
      expect(_hm(c.forDay(DateTime(2015, 7, 12))), {
        Salah.fajr: '04:42',
        Salah.sunrise: '06:08',
        Salah.dhuhr: '13:21',
        Salah.asr: '18:22',
        Salah.maghrib: '20:32',
        Salah.isha: '21:57',
      });
    });

    test('Raleigh, Ligue islamique mondiale, 1er décembre 2015', () {
      final c = _calculator(
        lat: 35.775,
        lng: -78.6336,
        timezone: 'America/New_York',
        method: CalculationMethod.muslimWorldLeague,
        madhab: Madhab.shafi,
      );
      expect(_hm(c.forDay(DateTime(2015, 12, 1))), {
        Salah.fajr: '05:35',
        Salah.sunrise: '07:06',
        Salah.dhuhr: '12:05',
        Salah.asr: '14:42',
        Salah.maghrib: '17:01',
        Salah.isha: '18:26',
      });
    });

    test('Le Caire, méthode égyptienne, 1er janvier 2020', () {
      final c = _calculator(
        lat: 30.028703,
        lng: 31.249528,
        timezone: 'Africa/Cairo',
        country: 'EG',
      );
      expect(_hm(c.forDay(DateTime(2020, 1, 1))), {
        Salah.fajr: '05:18',
        Salah.sunrise: '06:51',
        Salah.dhuhr: '11:59',
        Salah.asr: '14:47',
        Salah.maghrib: '17:06',
        Salah.isha: '18:29',
      });
    });

    test('Istanbul, Diyanet, 16 avril 2020', () {
      final c = _calculator(
        lat: 41.005616,
        lng: 28.97638,
        timezone: 'Europe/Istanbul',
        country: 'TR',
      );
      final hm = _hm(c.forDay(DateTime(2020, 4, 16)));
      expect(hm[Salah.fajr], '04:44');
      expect(hm[Salah.sunrise], '06:16');
      expect(hm[Salah.dhuhr], '13:09');
      expect(hm[Salah.maghrib], '19:52');
    });
  });

  group('prochaine prière', () {
    final raleigh = _calculator(
      lat: 35.775,
      lng: -78.6336,
      timezone: 'America/New_York',
      method: CalculationMethod.northAmerica,
      madhab: Madhab.hanafi,
    );
    tz.TZDateTime ny(int h, int m, [int day = 12]) =>
        tz.TZDateTime(tz.getLocation('America/New_York'), 2015, 7, day, h, m);

    test('en milieu de journée, c\'est la prière suivante du jour', () {
      final next = raleigh.nextPrayer(ny(12, 0));
      expect(next.salah, Salah.dhuhr);
      expect(DateFormat('HH:mm').format(next.time), '13:21');
    });

    test('entre le Fajr et le lever du soleil, le lever est ignoré', () {
      expect(raleigh.nextPrayer(ny(5, 0)).salah, Salah.dhuhr);
    });

    test('après l\'Isha, c\'est le Fajr du lendemain', () {
      final next = raleigh.nextPrayer(ny(22, 30));
      expect(next.salah, Salah.fajr);
      expect(next.time.day, 13);
      expect(next.time.isAfter(ny(22, 30)), isTrue);
    });

    test('le jour civil suit le fuseau du lieu, pas celui du téléphone', () {
      // 03:00 UTC le 13 juillet = 23:00 le 12 juillet à New York.
      final now = DateTime.utc(2015, 7, 13, 3);
      expect(raleigh.localToday(now), DateTime(2015, 7, 12));
      expect(raleigh.nextPrayer(now).time.day, 13);
    });
  });

  group('cohérence sur toute l\'année', () {
    const places = [
      ('Casablanca', 33.5883, -7.6114, 'Africa/Casablanca', 'MA'),
      ('Alger', 36.7538, 3.0588, 'Africa/Algiers', 'DZ'),
      ('Paris', 48.8566, 2.3522, 'Europe/Paris', 'FR'),
      ('La Mecque', 21.4225, 39.8262, 'Asia/Riyadh', 'SA'),
      ('Jakarta', -6.2088, 106.8456, 'Asia/Jakarta', 'ID'),
      ('Londres', 51.5074, -0.1278, 'Europe/London', 'GB'),
      ('Oslo', 59.9139, 10.7522, 'Europe/Oslo', 'NO'),
    ];
    for (final (name, lat, lng, zone, country) in places) {
      test('$name : horaires ordonnés et dans la bonne journée', () {
        final c = _calculator(lat: lat, lng: lng, timezone: zone, country: country);
        for (
          var d = DateTime(2026, 1, 1);
          d.year == 2026;
          d = DateTime(d.year, d.month, d.day + 1)
        ) {
          final day = c.forDay(d);
          final times = [for (final s in Salah.values) day[s]];
          for (var i = 1; i < times.length; i++) {
            expect(times[i].isAfter(times[i - 1]), isTrue, reason: '$name $d ${Salah.values[i]}');
          }
          expect(
            (day[Salah.dhuhr].year, day[Salah.dhuhr].month, day[Salah.dhuhr].day),
            (d.year, d.month, d.day),
            reason: '$name $d : le Dhuhr doit tomber le jour demandé',
          );
        }
      });
    }
  });

  group('méthode par défaut selon le pays', () {
    test('Maghreb, France, Arabie, Turquie', () {
      expect(defaultMethodForCountry('MA'), CalculationMethod.morocco);
      expect(defaultMethodForCountry('DZ'), CalculationMethod.algerian);
      expect(defaultMethodForCountry('TN'), CalculationMethod.tunisia);
      expect(defaultMethodForCountry('FR'), CalculationMethod.france);
      expect(defaultMethodForCountry('SA'), CalculationMethod.ummAlQura);
      expect(defaultMethodForCountry('TR'), CalculationMethod.turkiye);
      expect(defaultMethodForCountry('XX'), CalculationMethod.muslimWorldLeague);
    });

    test('Asr hanafite en Turquie et au Pakistan, standard au Maroc', () {
      expect(defaultMadhabForCountry('TR'), Madhab.hanafi);
      expect(defaultMadhabForCountry('PK'), Madhab.hanafi);
      expect(defaultMadhabForCountry('MA'), Madhab.shafi);
    });

    test('un réglage manuel remplace la valeur automatique', () {
      const location = SavedLocation(
        latitude: 33.5883,
        longitude: -7.6114,
        timezone: 'Africa/Casablanca',
        countryCode: 'MA',
      );
      final auto = PrayerConfig.resolve(const AppSettings(), location);
      expect(auto.method, CalculationMethod.morocco);
      expect(auto.methodIsAuto, isTrue);
      final manual = PrayerConfig.resolve(
        const AppSettings(calculationMethod: CalculationMethod.muslimWorldLeague),
        location,
      );
      expect(manual.method, CalculationMethod.muslimWorldLeague);
      expect(manual.methodIsAuto, isFalse);
    });
  });
}
