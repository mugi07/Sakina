import 'dart:convert';
import 'dart:io';

import 'package:home_widget/home_widget.dart';

import '../../core/calendar/hijri_date.dart';
import '../../core/location/saved_location.dart';
import '../../l10n/app_localizations.dart';
import '../prayer_times/domain/prayer_calculator.dart';
import '../prayer_times/presentation/prayer_labels.dart';

/// Classe du widget Android (PrayerTimesWidgetProvider.kt), avec son nom
/// complet : l'identifiant de l'app (com.mugi07.sakinah) diffère de
/// l'espace de noms du code Kotlin (com.sakinaapp.sakina).
const _androidWidget = 'com.sakinaapp.sakina.PrayerTimesWidgetProvider';
const _dataKey = 'prayer_widget';

/// Données du widget « Horaires de prière » : horaires des [days] prochains
/// jours, déjà traduits et formatés ; le widget choisit la prochaine prière.
Map<String, dynamic> buildPrayerWidgetData({
  required PrayerCalculator? calculator,
  required SavedLocation? location,
  required AppLocalizations l,
  required String locale,
  required int hijriAdjustment,
  required DateTime now,
  int days = 7,
}) {
  if (calculator == null || location == null) return {'message': l.widgetNoLocation};
  final lang = locale.split('-').first;
  final today = calculator.localToday(now);
  return {
    'city': location.cityName(lang) ?? l.myPosition,
    'nextLabel': l.nextPrayer,
    'staleMessage': l.appTitle,
    'days': [
      for (var d = 0; d < days; d++)
        () {
          final date = DateTime(today.year, today.month, today.day + d);
          final day = calculator.forDay(date);
          return {
            'hijri': HijriDate.fromGregorian(date, adjustmentDays: hijriAdjustment).format(locale),
            'prayers': [
              for (final s in Salah.values.where((s) => s.isPrayer))
                {
                  'name': l.salahName(s),
                  'time': formatTime(day[s], locale),
                  'at': day[s].millisecondsSinceEpoch,
                },
            ],
          };
        }(),
    ],
  };
}

/// Met à jour le widget Android et programme son rafraîchissement à chaque
/// heure de prière (sans ouvrir l'app). Sans effet ailleurs qu'Android :
/// le widget iOS demande une extension WidgetKit (voir README).
Future<void> syncPrayerWidget(Map<String, dynamic> data) async {
  if (!Platform.isAndroid) return;
  await HomeWidget.saveWidgetData<String>(_dataKey, jsonEncode(data));
  await HomeWidget.updateWidget(qualifiedAndroidName: _androidWidget);
  final times = [
    for (final day in (data['days'] as List<dynamic>? ?? const []).cast<Map<String, dynamic>>())
      for (final p in (day['prayers'] as List<dynamic>).cast<Map<String, dynamic>>())
        DateTime.fromMillisecondsSinceEpoch(p['at'] as int),
  ].where((t) => t.isAfter(DateTime.now())).toList();
  if (times.isEmpty) {
    await HomeWidget.cancelScheduledWidgetUpdates(qualifiedAndroidName: _androidWidget);
  } else {
    await HomeWidget.scheduleWidgetUpdates(times, qualifiedAndroidName: _androidWidget);
  }
}

/// Le lanceur permet-il d'ajouter le widget depuis l'app (Android 8+) ?
Future<bool> canPinPrayerWidget() async =>
    Platform.isAndroid && (await HomeWidget.isRequestPinWidgetSupported() ?? false);

Future<void> pinPrayerWidget() => HomeWidget.requestPinWidget(qualifiedAndroidName: _androidWidget);
