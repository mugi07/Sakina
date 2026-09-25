import 'package:adhan_dart/adhan_dart.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/location/saved_location.dart';
import '../../../core/settings/app_settings.dart';
import 'method_defaults.dart';

/// Les six horaires affichés (le lever du soleil n'est pas une prière,
/// mais il marque la fin du temps du Fajr).
enum Salah {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha;

  bool get isPrayer => this != sunrise;
}

/// Réglages de calcul effectifs, une fois les valeurs « automatiques »
/// résolues à partir du pays et de la latitude.
class PrayerConfig {
  const PrayerConfig({
    required this.method,
    required this.madhab,
    required this.highLatitudeRule,
    required this.methodIsAuto,
    required this.madhabIsAuto,
  });

  factory PrayerConfig.resolve(AppSettings settings, SavedLocation location) => PrayerConfig(
    method: settings.calculationMethod ?? defaultMethodForCountry(location.countryCode),
    madhab: settings.madhab ?? defaultMadhabForCountry(location.countryCode),
    highLatitudeRule:
        settings.highLatitudeRule ??
        HighLatitudeRule.recommended(Coordinates(location.latitude, location.longitude)),
    methodIsAuto: settings.calculationMethod == null,
    madhabIsAuto: settings.madhab == null,
  );

  final CalculationMethod method;
  final Madhab madhab;
  final HighLatitudeRule highLatitudeRule;
  final bool methodIsAuto;
  final bool madhabIsAuto;

  CalculationParameters get parameters => parametersFor(method)
    ..madhab = madhab
    ..highLatitudeRule = highLatitudeRule;
}

/// Horaires d'une journée civile, dans le fuseau horaire du lieu.
class DayPrayerTimes {
  const DayPrayerTimes(this.date, this.times);

  /// Jour civil (année, mois, jour) dans le fuseau du lieu.
  final DateTime date;
  final Map<Salah, tz.TZDateTime> times;

  tz.TZDateTime operator [](Salah salah) => times[salah]!;
}

class NextPrayer {
  const NextPrayer(this.salah, this.time);

  final Salah salah;
  final tz.TZDateTime time;
}

class PrayerCalculator {
  const PrayerCalculator(this.location, this.config);

  final SavedLocation location;
  final PrayerConfig config;

  tz.Location get _zone => tz.getLocation(location.timezone);

  /// Jour civil courant dans le fuseau du lieu (qui peut différer de celui
  /// du téléphone si l'utilisateur a choisi une ville lointaine).
  DateTime localToday(DateTime now) {
    final local = tz.TZDateTime.from(now, _zone);
    return DateTime(local.year, local.month, local.day);
  }

  DayPrayerTimes forDay(DateTime civilDate) {
    // adhan_dart ne lit que l'année, le mois et le jour ; midi évite qu'un
    // changement d'heure ou un fuseau négatif fasse glisser le jour.
    final times = PrayerTimes(
      date: DateTime(civilDate.year, civilDate.month, civilDate.day, 12),
      coordinates: Coordinates(location.latitude, location.longitude),
      calculationParameters: config.parameters,
    );
    final zone = _zone;
    tz.TZDateTime local(DateTime utc) => tz.TZDateTime.from(utc, zone);
    return DayPrayerTimes(DateTime(civilDate.year, civilDate.month, civilDate.day), {
      Salah.fajr: local(times.fajr),
      Salah.sunrise: local(times.sunrise),
      Salah.dhuhr: local(times.dhuhr),
      Salah.asr: local(times.asr),
      Salah.maghrib: local(times.maghrib),
      Salah.isha: local(times.isha),
    });
  }

  /// Prochaine prière strictement après [now] (le lever du soleil est ignoré).
  NextPrayer nextPrayer(DateTime now) {
    final today = localToday(now);
    final day = forDay(today);
    for (final salah in Salah.values.where((s) => s.isPrayer)) {
      if (day[salah].isAfter(now)) return NextPrayer(salah, day[salah]);
    }
    final tomorrow = forDay(DateTime(today.year, today.month, today.day + 1));
    return NextPrayer(Salah.fajr, tomorrow[Salah.fajr]);
  }
}
