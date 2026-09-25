import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

/// Date hégirienne (calendrier Umm al-Qura), avec un décalage manuel
/// en jours pour s'aligner sur l'observation locale du croissant.
class HijriDate {
  const HijriDate(this.year, this.month, this.day);

  factory HijriDate.fromGregorian(DateTime date, {int adjustmentDays = 0}) {
    final h = HijriCalendar.fromDate(DateTime(date.year, date.month, date.day + adjustmentDays));
    return HijriDate(h.hYear, h.hMonth, h.hDay);
  }

  final int year;
  final int month;
  final int day;

  String monthName(String languageCode) =>
      (_monthNames[languageCode] ?? _monthNames['en']!)[month - 1];

  /// « 4 Rabi' ath-thani 1448 », « ٤ ربيع الآخر ١٤٤٨ »…
  String format(String locale) {
    final languageCode = locale.split(RegExp('[-_]')).first;
    final n = NumberFormat.decimalPattern(locale)..turnOffGrouping();
    final suffix = switch (languageCode) {
      'ar' => ' هـ',
      'fr' => ' H',
      _ => ' AH',
    };
    return '${n.format(day)} ${monthName(languageCode)} ${n.format(year)}$suffix';
  }
}

const _monthNames = {
  'ar': [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ],
  'fr': [
    'Mouharram',
    'Safar',
    "Rabi' al-awwal",
    "Rabi' ath-thani",
    'Joumada al-oula',
    'Joumada ath-thania',
    'Rajab',
    "Cha'bane",
    'Ramadan',
    'Chawwal',
    "Dhou al-qi'da",
    'Dhou al-hijja',
  ],
  'en': [
    'Muharram',
    'Safar',
    "Rabi' al-Awwal",
    "Rabi' al-Thani",
    'Jumada al-Ula',
    'Jumada al-Akhirah',
    'Rajab',
    "Sha'ban",
    'Ramadan',
    'Shawwal',
    "Dhu al-Qi'dah",
    'Dhu al-Hijjah',
  ],
};
