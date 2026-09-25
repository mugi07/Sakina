import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/method_defaults.dart';
import '../domain/prayer_calculator.dart';

extension PrayerLabels on AppLocalizations {
  String salahName(Salah salah) => switch (salah) {
    Salah.fajr => prayerFajr,
    Salah.sunrise => prayerSunrise,
    Salah.dhuhr => prayerDhuhr,
    Salah.asr => prayerAsr,
    Salah.maghrib => prayerMaghrib,
    Salah.isha => prayerIsha,
  };

  String methodName(CalculationMethod method) => calcMethodName(method.name);

  /// « Fajr 19° · Isha 17° » ou « Fajr 19,5° · Isha 90 min après le Maghrib ».
  String methodAngles(CalculationMethod method, String locale) {
    final p = parametersFor(method);
    final n = NumberFormat.decimalPattern(locale);
    final interval = p.ishaInterval ?? 0;
    return interval > 0
        ? anglesFajrIshaInterval(n.format(p.fajrAngle), interval)
        : anglesFajrIsha(n.format(p.fajrAngle), n.format(p.ishaAngle));
  }

  String madhabName(Madhab madhab) => switch (madhab) {
    Madhab.shafi => asrStandard,
    Madhab.hanafi => asrHanafi,
  };

  String highLatitudeRuleName(HighLatitudeRule rule) => switch (rule) {
    HighLatitudeRule.middleOfTheNight => hlrMiddleOfTheNight,
    HighLatitudeRule.seventhOfTheNight => hlrSeventhOfTheNight,
    HighLatitudeRule.twilightAngle => hlrTwilightAngle,
  };
}

IconData salahIcon(Salah salah) => switch (salah) {
  Salah.fajr => Icons.nights_stay_outlined,
  Salah.sunrise => Icons.wb_twilight,
  Salah.dhuhr => Icons.wb_sunny_outlined,
  Salah.asr => Icons.sunny_snowing,
  Salah.maghrib => Icons.wb_twilight_outlined,
  Salah.isha => Icons.dark_mode_outlined,
};

/// Heure au format 24 h de la langue (« 05:12 », « ٠٥:١٢ »).
String formatTime(DateTime time, String locale) => DateFormat.Hm(locale).format(time);

/// Compte à rebours « 01:23:45 ».
String formatCountdown(Duration d, String locale) {
  final n = NumberFormat('00', locale);
  final s = d.isNegative ? Duration.zero : d;
  return '${n.format(s.inHours)}:${n.format(s.inMinutes % 60)}:${n.format(s.inSeconds % 60)}';
}
