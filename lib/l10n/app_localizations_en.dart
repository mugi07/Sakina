// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sakinah';

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
  String get qiblaHint => 'Find north, then turn clockwise by this angle. Or open the compass.';

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

  @override
  String get tabSurahs => 'Surahs';

  @override
  String get tabJuz => 'Juz';

  @override
  String get tabHizb => 'Hizb';

  @override
  String juzLabel(int n) {
    return 'Juz $n';
  }

  @override
  String hizbLabel(int n) {
    return 'Hizb $n';
  }

  @override
  String pageLabel(int n) {
    return 'Page $n';
  }

  @override
  String get goToPage => 'Go to page';

  @override
  String get go => 'Go';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Verse copied';

  @override
  String continueReadingPage(int page, String surah) {
    return 'Page $page · $surah';
  }

  @override
  String surahTitle(String name) {
    return 'Surah $name';
  }

  @override
  String ayahReference(String surah, int ayah) {
    return '$surah, verse $ayah';
  }

  @override
  String adhanTitle(String prayer, String time) {
    return '$prayer — $time';
  }

  @override
  String adhanBody(String prayer) {
    return 'It is time for $prayer prayer.';
  }

  @override
  String reminderTitle(String prayer, int minutes) {
    return '$prayer in $minutes min';
  }

  @override
  String get reminderBody => 'Get ready for prayer, in sha Allah.';

  @override
  String get adhanChannelName => 'Prayer times';

  @override
  String get adhanChannelDescription => 'Notification at the time of each prayer';

  @override
  String get sectionAdhan => 'Prayer notifications';

  @override
  String get adhanNotifications => 'Notify at prayer time';

  @override
  String get adhanPrayersTitle => 'Prayers';

  @override
  String get reminderBefore => 'Reminder before prayer';

  @override
  String reminderValue(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min before',
      zero: 'None',
    );
    return '$_temp0';
  }

  @override
  String get notificationsDenied =>
      'Notifications are blocked. Allow them to receive prayer times.';

  @override
  String get allow => 'Allow';

  @override
  String get welcomeTagline => 'Quran, prayer, Qibla and remembrance. Free, no ads, no account.';

  @override
  String get welcomeLanguage => 'Choose your language';

  @override
  String get continueLabel => 'Continue';

  @override
  String get later => 'Later';

  @override
  String get start => 'Get started';

  @override
  String get welcomeLocationTitle => 'Your city';

  @override
  String get welcomeLocationBody =>
      'To calculate prayer times and the Qibla direction. Your location stays on your phone.';

  @override
  String get welcomeNotifTitle => 'Prayer notifications';

  @override
  String get welcomeNotifBody =>
      'Get a notification at the time of each prayer. You can choose the prayers in settings.';

  @override
  String get notificationsAllowed => 'Notifications allowed';

  @override
  String get monthlyTimetable => 'Monthly timetable';

  @override
  String get dayColumn => 'Day';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get exactAlarmsDenied =>
      'Notifications may arrive late: allow “Alarms & reminders” for exact timing.';

  @override
  String get openCompass => 'Open compass';

  @override
  String get qiblaCompassTitle => 'Qibla compass';

  @override
  String get qiblaAligned => 'You are facing the Qibla';

  @override
  String turnRight(String deg) {
    return 'Turn right: $deg°';
  }

  @override
  String turnLeft(String deg) {
    return 'Turn left: $deg°';
  }

  @override
  String get compassUnavailable =>
      'No compass on this device. Use the angle above with a regular compass.';

  @override
  String get calibrateTip =>
      'Low accuracy: move your phone in a figure-8 to calibrate the compass.';

  @override
  String get metalWarning =>
      'Hold the phone flat, away from metal objects, magnets and electrical devices.';

  @override
  String declinationNote(String deg) {
    return 'Magnetic declination corrected: $deg°';
  }

  @override
  String get compassNeedsLocation => 'Allow location access to enable the compass.';

  @override
  String get hadithSearchHint => 'Search hadith…';

  @override
  String hadithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hadith',
      one: '1 hadith',
    );
    return '$_temp0';
  }

  @override
  String chapterLabel(int n) {
    return 'Book $n';
  }

  @override
  String get translationMissing => 'Translation not available for this hadith in this language.';

  @override
  String hadithNumber(String number) {
    return 'Hadith $number';
  }

  @override
  String get sahihCollection => 'Authentic collection (sahih)';

  @override
  String get hadithOfTheDay => 'Hadith of the day';

  @override
  String get preparingHadiths => 'Preparing hadith (first opening)…';

  @override
  String get noResults => 'No results.';

  @override
  String get search => 'Search';

  @override
  String get tasbihTarget => 'Target';

  @override
  String get tasbihFree => 'Free';

  @override
  String tasbihToday(int count) {
    return 'Today: $count';
  }

  @override
  String get tasbihReset => 'Reset';

  @override
  String get tasbihCompleted => 'Target reached, may Allah accept it';

  @override
  String get tasbihTapHint => 'Tap the circle to count';

  @override
  String get phraseSubhanallah => 'Glory be to Allah';

  @override
  String get phraseAlhamdulillah => 'Praise be to Allah';

  @override
  String get phraseAllahuakbar => 'Allah is the Greatest';

  @override
  String get phraseLailaha => 'There is no god but Allah';

  @override
  String get phraseAstaghfirullah => 'I seek forgiveness from Allah';

  @override
  String get phraseSalawat => 'O Allah, send blessings upon Muhammad';
}
