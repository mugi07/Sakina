// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sakina';

  @override
  String get navHome => 'Home';

  @override
  String get navQuran => 'Quran';

  @override
  String get navPrayer => 'Prayer';

  @override
  String get navAdhkar => 'Adhkar';

  @override
  String get navMore => 'More';

  @override
  String get comingSoon => 'Soon';

  @override
  String get comingSoonBody => 'This section is coming in a future version, in sha Allah.';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get automatic => 'Automatic';

  @override
  String get system => 'System';

  @override
  String get loadError => 'Something went wrong while loading.';

  @override
  String get homeGreeting => 'Assalamu alaykum';

  @override
  String get continueReading => 'Continue reading';

  @override
  String continueReadingSurah(String name) {
    return 'Surah $name';
  }

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerSunrise => 'Sunrise';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get prayerTimesTitle => 'Prayer times';

  @override
  String get nextPrayer => 'Next prayer';

  @override
  String timeRemaining(String duration) {
    return 'in $duration';
  }

  @override
  String get today => 'Today';

  @override
  String get previousDay => 'Previous day';

  @override
  String get nextDay => 'Next day';

  @override
  String get chooseLocation => 'Choose a location';

  @override
  String get changeLocation => 'Change location';

  @override
  String get noLocationTitle => 'Where are you?';

  @override
  String get noLocationBody =>
      'Choose your city to calculate prayer times and the Qibla direction.';

  @override
  String methodSummary(String method) {
    return 'Method: $method';
  }

  @override
  String asrSummary(String madhab) {
    return 'Asr: $madhab';
  }

  @override
  String get qiblaTitle => 'Qibla direction';

  @override
  String qiblaBearing(String degrees) {
    return '$degrees° from north';
  }

  @override
  String qiblaDistance(String km) {
    return '$km km to the Kaaba';
  }

  @override
  String get qiblaHint =>
      'Find north, then turn clockwise by this angle. A live compass is coming soon.';

  @override
  String get locationTitle => 'Choose a location';

  @override
  String get searchCityHint => 'Search for a city…';

  @override
  String get useMyLocation => 'Use my current location';

  @override
  String get locating => 'Getting your location…';

  @override
  String get locationServiceDisabled => 'Location services are turned off on your phone.';

  @override
  String get locationPermissionDenied =>
      'Location access was denied. You can pick a city manually.';

  @override
  String get locationError => 'Could not get your location.';

  @override
  String get myPosition => 'My location';

  @override
  String get noCityFound => 'No city found.';

  @override
  String get searchCityPrompt => 'Type at least 2 letters.';

  @override
  String get quranTitle => 'The Holy Quran';

  @override
  String get meccan => 'Meccan';

  @override
  String get medinan => 'Medinan';

  @override
  String ayahCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verses',
      one: '1 verse',
    );
    return '$_temp0';
  }

  @override
  String get moreTitle => 'More';

  @override
  String get hadith => 'Hadith';

  @override
  String get tasbih => 'Tasbih';

  @override
  String get asmaUlHusna => 'The 99 names of Allah';

  @override
  String get hijriCalendar => 'Hijri calendar';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sourcesTitle => 'Sources & licenses';

  @override
  String get softwareLicenses => 'Software licenses';

  @override
  String get sectionGeneral => 'General';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get sectionPrayer => 'Prayer times';

  @override
  String get calculationMethod => 'Calculation method';

  @override
  String autoMethod(String method) {
    return 'Automatic: $method';
  }

  @override
  String get asrMethod => 'Asr calculation';

  @override
  String get asrStandard => 'Standard (Shafi\'i, Maliki, Hanbali)';

  @override
  String get asrHanafi => 'Hanafi';

  @override
  String get highLatitudeRule => 'High latitudes';

  @override
  String get hlrMiddleOfTheNight => 'Middle of the night';

  @override
  String get hlrSeventhOfTheNight => 'Seventh of the night';

  @override
  String get hlrTwilightAngle => 'Twilight angle';

  @override
  String get hijriAdjustment => 'Hijri calendar adjustment';

  @override
  String hijriAdjustmentValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
      zero: 'None',
    );
    return '$_temp0';
  }

  @override
  String get sectionQuran => 'Quran';

  @override
  String get translation => 'Translation';

  @override
  String get translationAuto => 'Match app language';

  @override
  String get translationNone => 'None';

  @override
  String get arabicFontSize => 'Arabic text size';

  @override
  String anglesFajrIsha(String fajr, String isha) {
    return 'Fajr $fajr° · Isha $isha°';
  }

  @override
  String anglesFajrIshaInterval(String fajr, int minutes) {
    return 'Fajr $fajr° · Isha $minutes min after Maghrib';
  }

  @override
  String calcMethodName(String method) {
    String _temp0 = intl.Intl.selectLogic(method, {
      'algerian': 'Algeria (Ministry of Religious Affairs)',
      'dubai': 'Dubai',
      'egyptian': 'Egyptian General Authority of Survey',
      'france': 'France (UOIF)',
      'gulfRegion': 'Gulf Region',
      'indonesian': 'Indonesia (KEMENAG)',
      'jafari': 'Ja\'fari (Qum)',
      'jordan': 'Jordan',
      'karachi': 'University of Islamic Sciences, Karachi',
      'kuwait': 'Kuwait',
      'moonsightingCommittee': 'Moonsighting Committee',
      'morocco': 'Morocco (Ministry of Habous)',
      'muslimWorldLeague': 'Muslim World League',
      'northAmerica': 'North America (ISNA)',
      'portugal': 'Portugal (Islamic Community of Lisbon)',
      'qatar': 'Qatar',
      'russia': 'Russia',
      'singapore': 'Singapore (MUIS)',
      'tehran': 'Tehran',
      'tunisia': 'Tunisia',
      'turkiye': 'Türkiye (Diyanet)',
      'ummAlQura': 'Umm al-Qura (Makkah)',
      'other': 'Custom',
    });
    return '$_temp0';
  }

  @override
  String get sourcesIntro =>
      'Sakina\'s content comes from recognized sources. The Quran text is reproduced without any modification.';

  @override
  String get privacyNote => 'Sakina runs entirely on your phone: no data is collected or sent.';

  @override
  String get tanzilNoticeTitle => 'Tanzil copyright notice';

  @override
  String get fontsTitle => 'Fonts';
}
