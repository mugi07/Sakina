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

  /// Jour grégorien correspondant, avec le même décalage manuel que
  /// [HijriDate.fromGregorian] (les deux conversions sont réciproques).
  DateTime toGregorian({int adjustmentDays = 0}) {
    final g = HijriCalendar().hijriToGregorian(year, month, day);
    return DateTime(g.year, g.month, g.day - adjustmentDays);
  }

  /// Nombre de jours (29 ou 30) du mois hégirien, selon Umm al-Qura.
  static int daysInMonth(int year, int month) => HijriCalendar().getDaysInMonth(year, month);

  /// Premier jour du mois, [months] mois plus tard (ou plus tôt).
  HijriDate addMonths(int months) {
    final index = year * 12 + (month - 1) + months;
    return HijriDate(index ~/ 12, index % 12 + 1, 1);
  }

  @override
  bool operator ==(Object other) =>
      other is HijriDate && other.year == year && other.month == month && other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => '$year-$month-$day AH';

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
