import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';

import '../location/saved_location.dart';

enum AppLanguage { system, ar, fr, en }

/// Langue affichée dans le lecteur du Coran : l'arabe (mushaf) ou une
/// traduction, chacune sur ses propres pages.
enum QuranLanguage {
  arabic,
  french('fr.hamidullah'),
  english('en.sahih');

  const QuranLanguage([this.edition]);

  /// Identifiant de l'édition de traduction dans content.sqlite.
  final String? edition;
}

/// Préférences de l'utilisateur. Pour les réglages de prière, null signifie
/// « automatique » : la valeur est déduite du pays du lieu choisi.
@immutable
class AppSettings {
  const AppSettings({
    this.language = AppLanguage.system,
    this.themeMode = ThemeMode.system,
    this.location,
    this.calculationMethod,
    this.madhab,
    this.highLatitudeRule,
    this.hijriAdjustment = 0,
    this.quranLanguage = QuranLanguage.arabic,
    this.arabicFontScale = 1.0,
    this.lastReadPage,
    this.onboardingDone = false,
    this.adhanEnabled = true,
    this.adhanMuted = const {},
    this.adhanReminderMinutes = 0,
    this.hadithLanguage = AppLanguage.system,
    this.adhkarReminders = true,
    this.adhanSound = true,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    T? byName<T extends Enum>(List<T> values, Object? name) =>
        name is String ? values.asNameMap()[name] : null;
    final location = json['location'];
    return AppSettings(
      language: byName(AppLanguage.values, json['language']) ?? AppLanguage.system,
      themeMode: byName(ThemeMode.values, json['themeMode']) ?? ThemeMode.system,
      location: location is Map<String, dynamic> ? SavedLocation.fromJson(location) : null,
      calculationMethod: byName(CalculationMethod.values, json['calculationMethod']),
      madhab: byName(Madhab.values, json['madhab']),
      highLatitudeRule: byName(HighLatitudeRule.values, json['highLatitudeRule']),
      hijriAdjustment: json['hijriAdjustment'] as int? ?? 0,
      quranLanguage: byName(QuranLanguage.values, json['quranLanguage']) ?? QuranLanguage.arabic,
      arabicFontScale: (json['arabicFontScale'] as num?)?.toDouble() ?? 1.0,
      lastReadPage: json['lastReadPage'] as int?,
      onboardingDone: json['onboardingDone'] as bool? ?? false,
      adhanEnabled: json['adhanEnabled'] as bool? ?? true,
      adhanMuted: {...?(json['adhanMuted'] as List<dynamic>?)?.cast<String>()},
      adhanReminderMinutes: json['adhanReminderMinutes'] as int? ?? 0,
      hadithLanguage: byName(AppLanguage.values, json['hadithLanguage']) ?? AppLanguage.system,
      adhkarReminders: json['adhkarReminders'] as bool? ?? true,
      adhanSound: json['adhanSound'] as bool? ?? true,
    );
  }

  final AppLanguage language;
  final ThemeMode themeMode;
  final SavedLocation? location;
  final CalculationMethod? calculationMethod;
  final Madhab? madhab;
  final HighLatitudeRule? highLatitudeRule;

  /// Décalage du calendrier hégirien en jours (−2 à +2), pour s'aligner
  /// sur l'observation locale du croissant.
  final int hijriAdjustment;
  final QuranLanguage quranLanguage;
  final double arabicFontScale;

  /// Dernière page du mushaf lue (1..604), pour « Continuer la lecture ».
  final int? lastReadPage;

  /// Écran de bienvenue (langue, lieu, notifications) terminé.
  final bool onboardingDone;

  /// Notifications à l'heure de chaque prière.
  final bool adhanEnabled;

  /// Prières sans notification (noms : « fajr », « dhuhr »…).
  final Set<String> adhanMuted;

  /// Rappel supplémentaire avant chaque prière, en minutes (0 : aucun).
  final int adhanReminderMinutes;

  /// Langue des hadiths (une seule à la fois) ; system : celle de l'app.
  final AppLanguage hadithLanguage;

  /// Rappels des adhkar du matin (après le Fajr) et du soir (après le Asr).
  final bool adhkarReminders;

  /// Notifications de prière avec le début de l'adhan (« Allahu Akbar,
  /// Allahu Akbar ») au lieu du son du téléphone.
  final bool adhanSound;

  static const _unset = Object();

  /// Pour les champs nullables, passer explicitement null remet la valeur
  /// à « automatique » ; ne rien passer conserve la valeur actuelle.
  AppSettings copyWith({
    AppLanguage? language,
    ThemeMode? themeMode,
    Object? location = _unset,
    Object? calculationMethod = _unset,
    Object? madhab = _unset,
    Object? highLatitudeRule = _unset,
    int? hijriAdjustment,
    QuranLanguage? quranLanguage,
    double? arabicFontScale,
    Object? lastReadPage = _unset,
    bool? onboardingDone,
    bool? adhanEnabled,
    Set<String>? adhanMuted,
    int? adhanReminderMinutes,
    AppLanguage? hadithLanguage,
    bool? adhkarReminders,
    bool? adhanSound,
  }) => AppSettings(
    language: language ?? this.language,
    themeMode: themeMode ?? this.themeMode,
    location: location == _unset ? this.location : location as SavedLocation?,
    calculationMethod: calculationMethod == _unset
        ? this.calculationMethod
        : calculationMethod as CalculationMethod?,
    madhab: madhab == _unset ? this.madhab : madhab as Madhab?,
    highLatitudeRule: highLatitudeRule == _unset
        ? this.highLatitudeRule
        : highLatitudeRule as HighLatitudeRule?,
    hijriAdjustment: hijriAdjustment ?? this.hijriAdjustment,
    quranLanguage: quranLanguage ?? this.quranLanguage,
    arabicFontScale: arabicFontScale ?? this.arabicFontScale,
    lastReadPage: lastReadPage == _unset ? this.lastReadPage : lastReadPage as int?,
    onboardingDone: onboardingDone ?? this.onboardingDone,
    adhanEnabled: adhanEnabled ?? this.adhanEnabled,
    adhanMuted: adhanMuted ?? this.adhanMuted,
    adhanReminderMinutes: adhanReminderMinutes ?? this.adhanReminderMinutes,
    hadithLanguage: hadithLanguage ?? this.hadithLanguage,
    adhkarReminders: adhkarReminders ?? this.adhkarReminders,
    adhanSound: adhanSound ?? this.adhanSound,
  );

  Map<String, dynamic> toJson() => {
    'language': language.name,
    'themeMode': themeMode.name,
    'location': location?.toJson(),
    'calculationMethod': calculationMethod?.name,
    'madhab': madhab?.name,
    'highLatitudeRule': highLatitudeRule?.name,
    'hijriAdjustment': hijriAdjustment,
    'quranLanguage': quranLanguage.name,
    'arabicFontScale': arabicFontScale,
    'lastReadPage': lastReadPage,
    'onboardingDone': onboardingDone,
    'adhanEnabled': adhanEnabled,
    'adhanMuted': adhanMuted.toList()..sort(),
    'adhanReminderMinutes': adhanReminderMinutes,
    'hadithLanguage': hadithLanguage.name,
    'adhkarReminders': adhkarReminders,
    'adhanSound': adhanSound,
  };
}
