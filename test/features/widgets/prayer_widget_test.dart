import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sakina/core/location/saved_location.dart';
import 'package:sakina/core/settings/app_settings.dart';
import 'package:sakina/core/time/time_zones.dart';
import 'package:sakina/features/prayer_times/domain/prayer_calculator.dart';
import 'package:sakina/features/widgets/prayer_widget.dart';
import 'package:sakina/l10n/app_localizations.dart';
import 'package:timezone/timezone.dart' as tz;

void main() {
  setUpAll(() async {
    initTimeZones();
    // Dans l'app, les formats de date sont chargés par MaterialApp.
    await initializeDateFormatting('fr');
  });
  final l = lookupAppLocalizations(const Locale('fr'));

  test('sans lieu : un message à la place des horaires', () {
    final data = buildPrayerWidgetData(
      calculator: null,
      location: null,
      l: l,
      locale: 'fr',
      hijriAdjustment: 0,
      now: DateTime(2026, 9, 26),
    );
    expect(data, {'message': l.widgetNoLocation});
  });

  test('7 jours de 5 prières, traduits, dans l\'ordre', () {
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
    final data = buildPrayerWidgetData(
      calculator: calculator,
      location: casablanca,
      l: l,
      locale: 'fr',
      hijriAdjustment: 0,
      now: tz.TZDateTime(tz.getLocation('Africa/Casablanca'), 2026, 9, 26, 14),
    );
    expect(data['city'], 'Casablanca');
    final days = (data['days'] as List<dynamic>).cast<Map<String, dynamic>>();
    expect(days, hasLength(7));
    expect(days.first['hijri'], contains('1448'));
    final prayers = [
      for (final d in days) ...(d['prayers'] as List<dynamic>).cast<Map<String, dynamic>>(),
    ];
    expect(prayers, hasLength(35));
    expect(prayers.take(5).map((p) => p['name']), ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']);
    expect(prayers.first['time'], matches(RegExp(r'^\d\d:\d\d$')));
    for (var i = 1; i < prayers.length; i++) {
      expect((prayers[i]['at'] as int) > (prayers[i - 1]['at'] as int), isTrue);
    }
  });
}
