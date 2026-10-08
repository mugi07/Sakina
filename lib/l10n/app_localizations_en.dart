// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Zahrae Noor  —  زهراء نور';

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
      'Zahrae Noor  —  زهراء نور\'s content comes from recognized sources. The Quran text is reproduced without any modification.';

  @override
  String get privacyNote =>
      'Zahrae Noor  —  زهراء نور runs entirely on your phone: no data is collected or sent.';

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
      'No compass on this device. Use the sun (below) or the angle above with a regular compass.';

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

  @override
  String get adhkarEssentials => 'Essentials';

  @override
  String get adhkarAllChapters => 'All chapters';

  @override
  String get adhkarSearchHint => 'Search a chapter…';

  @override
  String repeatTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count times',
      one: 'once',
    );
    return '$_temp0';
  }

  @override
  String get adhkarDone => 'Done';

  @override
  String get adhkarTapHint => 'Tap a remembrance each time you recite it.';

  @override
  String get translationEnglishPending => '';

  @override
  String get restart => 'Start over';

  @override
  String adhkarProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String get verseOfTheDay => 'Verse of the day';

  @override
  String get morningAdhkar => 'Morning adhkar';

  @override
  String get eveningAdhkar => 'Evening adhkar';

  @override
  String get adhkarReminderBodyMorning => 'Take a few minutes for the morning remembrances.';

  @override
  String get adhkarReminderBodyEvening => 'Take a few minutes for the evening remembrances.';

  @override
  String get adhkarReminders => 'Morning and evening adhkar reminders';

  @override
  String get adhkarRemindersHint => '30 min after Fajr and after Asr';

  @override
  String get share => 'Share';

  @override
  String get quranSearchHint => 'Search the Quran…';

  @override
  String get tabBookmarks => 'Bookmarks';

  @override
  String get noBookmarks => 'No bookmarks. Tap a verse in the mushaf, then the bookmark icon.';

  @override
  String get bookmarkAdd => 'Add bookmark';

  @override
  String get bookmarkRemove => 'Remove bookmark';

  @override
  String searchResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verses',
      one: '1 verse',
      zero: 'No results',
    );
    return '$_temp0';
  }

  @override
  String get listen => 'Listen';

  @override
  String get listenFromHere => 'Listen from this verse';

  @override
  String get reciter => 'Reciter';

  @override
  String get repeatVerse => 'Repeat verse';

  @override
  String get stop => 'Stop';

  @override
  String get recitationChannel => 'Quran recitation';

  @override
  String get audioNeedsInternet =>
      'An internet connection is needed the first time you play this verse.';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get pause => 'Pause';

  @override
  String eventName(String event) {
    String _temp0 = intl.Intl.selectLogic(event, {
      'newYear': 'Islamic New Year',
      'ashura': 'Day of Ashura',
      'mawlid': 'Mawlid (birth of the Prophet ﷺ, traditional date)',
      'israMiraj': 'Isra and Mi\'raj (traditional date)',
      'ramadanStart': 'Start of Ramadan',
      'lastTenNights': 'Last ten nights of Ramadan',
      'eidAlFitr': 'Eid al-Fitr',
      'dhulHijjahTenDays': 'First ten days of Dhul-Hijjah',
      'arafah': 'Day of Arafah',
      'eidAlAdha': 'Eid al-Adha',
      'other': 'Event',
    });
    return '$_temp0';
  }

  @override
  String get upcomingEvents => 'Upcoming events';

  @override
  String inDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'In $days days',
      one: 'Tomorrow',
      zero: 'Today',
    );
    return '$_temp0';
  }

  @override
  String get fastingRecommended => 'Fasting recommended';

  @override
  String get whiteDays => 'White days (13, 14, 15): fasting recommended';

  @override
  String get eventsThisMonth => 'This month';

  @override
  String get asmaSearchHint => 'Search a name…';

  @override
  String get asmaReviewNote => 'List narrated by at-Tirmidhi. Translations are indicative.';

  @override
  String get khatmaTitle => 'Khatma';

  @override
  String get khatmaIntro =>
      'Read the whole Quran in a number of days you choose. The app works out your daily goal.';

  @override
  String get khatmaDuration => 'Duration';

  @override
  String khatmaDays(int days) {
    return '$days days';
  }

  @override
  String get khatmaStartFrom => 'Start';

  @override
  String get khatmaFromBeginning => 'From the beginning';

  @override
  String khatmaFromPage(int page) {
    return 'From page $page';
  }

  @override
  String get khatmaStart => 'Start khatma';

  @override
  String get khatmaReminder => 'Daily reminder';

  @override
  String get khatmaReminderOff => 'None';

  @override
  String khatmaDayOf(int day, int days) {
    return 'Day $day of $days';
  }

  @override
  String khatmaPagesPerDay(int pages) {
    return '$pages pages a day';
  }

  @override
  String khatmaTodayGoal(int page) {
    return 'Today\'s goal: up to page $page';
  }

  @override
  String khatmaRemainingToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more pages today',
      one: '1 more page today',
      zero: 'Daily goal reached',
    );
    return '$_temp0';
  }

  @override
  String khatmaBehind(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages behind',
      one: '1 page behind',
    );
    return '$_temp0';
  }

  @override
  String get khatmaAhead => 'Ahead of your goal';

  @override
  String get khatmaOnTrack => 'You are on track';

  @override
  String get khatmaCompleted => 'Khatma completed, may Allah accept it from you!';

  @override
  String khatmaCompletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count khatmas completed',
      one: '1 khatma completed',
    );
    return '$_temp0';
  }

  @override
  String khatmaContinue(int page) {
    return 'Continue at page $page';
  }

  @override
  String get khatmaMarkRead => 'Khatma: read up to here';

  @override
  String khatmaMarkedRead(int page) {
    return 'Khatma: read up to page $page';
  }

  @override
  String get khatmaSetPage => 'Set the last page read';

  @override
  String get khatmaStop => 'Stop khatma';

  @override
  String get khatmaStopConfirm => 'Stop this khatma? Progress will be lost.';

  @override
  String get khatmaRestart => 'New khatma';

  @override
  String khatmaReminderBody(int pages) {
    return 'Read $pages pages today to stay on track.';
  }

  @override
  String khatmaProgress(int read, int total) {
    return '$read / $total pages';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get addWidget => 'Add widget to home screen';

  @override
  String get widgetNoLocation => 'Open Zahrae Noor  —  زهراء نور to choose your city.';

  @override
  String get findQibla => 'Find the Qibla';

  @override
  String get sunMethodTitle => 'Without a compass: use the sun';

  @override
  String sunFaceRight(String deg) {
    return 'Face the sun, then turn $deg° to the right.';
  }

  @override
  String sunFaceLeft(String deg) {
    return 'Face the sun, then turn $deg° to the left.';
  }

  @override
  String get sunFaceAhead => 'Face the sun: the Qibla is straight ahead.';

  @override
  String get sunTooHigh => 'The sun is too high to be a reliable guide. Try again a little later.';

  @override
  String sunBelowHorizon(String time) {
    return 'The sun has set. This method works again from $time.';
  }

  @override
  String get sunCompassCheck =>
      'Check: the sun drawn on the compass should point at the real sun. If not, calibrate the compass.';

  @override
  String kaabaTransit(String date, String time) {
    return 'On $date at $time, the sun will pass directly above the Kaaba: face it and you will be facing the Qibla.';
  }

  @override
  String get qibla => 'Qibla';

  @override
  String get testNotification => 'Test notification';

  @override
  String get testNotificationHint =>
      'Sends a notification in a few seconds to check the sound and display.';

  @override
  String get testNotificationTitle => 'Zahrae Noor  —  زهراء نور: test notification';

  @override
  String get testNotificationBody =>
      'Notifications are working. You will be notified at each prayer time.';

  @override
  String testNotificationScheduled(int seconds) {
    return 'Test notification in $seconds seconds: you can lock your phone.';
  }

  @override
  String get testNotificationSent => 'Test notification sent.';

  @override
  String get adhanSound => 'Adhan sound';

  @override
  String get adhanSoundHint =>
      '“Allahu Akbar, Allahu Akbar” at each prayer time (otherwise, the phone’s sound).';

  @override
  String get remindersChannelName => 'Reminders';

  @override
  String get remindersChannelDescription => 'Reminders before prayer, adhkar and khatma';

  @override
  String get dedicationTitle => 'Sadaqa jariya';

  @override
  String get dedicationBasmala => 'In the name of Allah, the Most Gracious, the Most Merciful.';

  @override
  String get dedicationBody =>
      'This app is completely free, with no ads.\n\nIt is a sadaqa jariya (ongoing charity) for the souls of my aunt Zahra Hafidi, my uncle Mohammed Hafidi and my grandfather Abdellah Hafidi, may Allah have mercy on them.\n\nMay Allah accept it, forgive them and grant them Paradise.\n\nPlease remember them in your du\'a.';
}
