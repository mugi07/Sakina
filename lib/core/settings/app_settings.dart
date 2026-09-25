import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';

import '../location/saved_location.dart';

enum AppLanguage { system, ar, fr, en }

/// Traduction du Coran affichée sous le texte arabe.
enum QuranTranslation {
  /// Français si l'app est en français, anglais si elle est en anglais,
  /// aucune si elle est en arabe.
  auto,
  none,
  frHamidullah('fr.hamidullah'),
  enSahih('en.sahih');

  const QuranTranslation([this.edition]);

  /// Identifiant de l'édition dans content.sqlite.
  final String? edition;

  String? editionFor(String languageCode) => switch (this) {
    auto => switch (languageCode) {
      'fr' => frHamidullah.edition,
      'en' => enSahih.edition,
      _ => null,
    },
    _ => edition,
  };
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
    this.quranTranslation = QuranTranslation.auto,
    this.arabicFontScale = 1.0,
    this.lastReadSurah,
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
      quranTranslation:
          byName(QuranTranslation.values, json['quranTranslation']) ?? QuranTranslation.auto,
      arabicFontScale: (json['arabicFontScale'] as num?)?.toDouble() ?? 1.0,
      lastReadSurah: json['lastReadSurah'] as int?,
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
  final QuranTranslation quranTranslation;
  final double arabicFontScale;
  final int? lastReadSurah;

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
    QuranTranslation? quranTranslation,
    double? arabicFontScale,
    Object? lastReadSurah = _unset,
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
    quranTranslation: quranTranslation ?? this.quranTranslation,
    arabicFontScale: arabicFontScale ?? this.arabicFontScale,
    lastReadSurah: lastReadSurah == _unset ? this.lastReadSurah : lastReadSurah as int?,
  );

  Map<String, dynamic> toJson() => {
    'language': language.name,
    'themeMode': themeMode.name,
    'location': location?.toJson(),
    'calculationMethod': calculationMethod?.name,
    'madhab': madhab?.name,
    'highLatitudeRule': highLatitudeRule?.name,
    'hijriAdjustment': hijriAdjustment,
    'quranTranslation': quranTranslation.name,
    'arabicFontScale': arabicFontScale,
    'lastReadSurah': lastReadSurah,
  };
}
