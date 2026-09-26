// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'سكينة';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navQuran => 'القرآن';

  @override
  String get navPrayer => 'الصلاة';

  @override
  String get navAdhkar => 'الأذكار';

  @override
  String get navMore => 'المزيد';

  @override
  String get comingSoon => 'قريبًا';

  @override
  String get comingSoonBody => 'هذا القسم قادم في إصدار قريب، إن شاء الله.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get automatic => 'تلقائي';

  @override
  String get system => 'النظام';

  @override
  String get loadError => 'حدث خطأ أثناء التحميل.';

  @override
  String get homeGreeting => 'السلام عليكم';

  @override
  String get continueReading => 'متابعة القراءة';

  @override
  String get prayerFajr => 'الفجر';

  @override
  String get prayerSunrise => 'الشروق';

  @override
  String get prayerDhuhr => 'الظهر';

  @override
  String get prayerAsr => 'العصر';

  @override
  String get prayerMaghrib => 'المغرب';

  @override
  String get prayerIsha => 'العشاء';

  @override
  String get prayerTimesTitle => 'مواقيت الصلاة';

  @override
  String get nextPrayer => 'الصلاة القادمة';

  @override
  String timeRemaining(String duration) {
    return 'بعد $duration';
  }

  @override
  String get today => 'اليوم';

  @override
  String get previousDay => 'اليوم السابق';

  @override
  String get nextDay => 'اليوم التالي';

  @override
  String get chooseLocation => 'اختيار الموقع';

  @override
  String get changeLocation => 'تغيير الموقع';

  @override
  String get noLocationTitle => 'أين أنت؟';

  @override
  String get noLocationBody => 'اختر مدينتك لحساب مواقيت الصلاة واتجاه القبلة.';

  @override
  String methodSummary(String method) {
    return 'طريقة الحساب: $method';
  }

  @override
  String asrSummary(String madhab) {
    return 'العصر: $madhab';
  }

  @override
  String get qiblaTitle => 'اتجاه القبلة';

  @override
  String qiblaBearing(String degrees) {
    return '$degrees° من الشمال';
  }

  @override
  String qiblaDistance(String km) {
    return '$km كم إلى الكعبة';
  }

  @override
  String get qiblaHint =>
      'حدّد اتجاه الشمال، ثم استدر بهذه الزاوية في اتجاه عقارب الساعة. البوصلة المباشرة قادمة قريبًا.';

  @override
  String get locationTitle => 'اختيار الموقع';

  @override
  String get searchCityHint => 'ابحث عن مدينة…';

  @override
  String get useMyLocation => 'استخدام موقعي الحالي';

  @override
  String get locating => 'جارٍ تحديد الموقع…';

  @override
  String get locationServiceDisabled => 'خدمة الموقع معطّلة على هاتفك.';

  @override
  String get locationPermissionDenied => 'تم رفض الوصول إلى الموقع. يمكنك اختيار مدينة يدويًا.';

  @override
  String get locationError => 'تعذّر الحصول على موقعك.';

  @override
  String get myPosition => 'موقعي';

  @override
  String get noCityFound => 'لم يتم العثور على أي مدينة.';

  @override
  String get searchCityPrompt => 'اكتب حرفين على الأقل.';

  @override
  String get quranTitle => 'القرآن الكريم';

  @override
  String get meccan => 'مكية';

  @override
  String get medinan => 'مدنية';

  @override
  String ayahCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count آية',
      many: '$count آية',
      few: '$count آيات',
      two: 'آيتان',
      one: 'آية واحدة',
    );
    return '$_temp0';
  }

  @override
  String get moreTitle => 'المزيد';

  @override
  String get hadith => 'الأحاديث';

  @override
  String get tasbih => 'التسبيح';

  @override
  String get asmaUlHusna => 'أسماء الله الحسنى';

  @override
  String get hijriCalendar => 'التقويم الهجري';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get sourcesTitle => 'المصادر والتراخيص';

  @override
  String get softwareLicenses => 'تراخيص البرمجيات';

  @override
  String get sectionGeneral => 'عام';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get sectionPrayer => 'مواقيت الصلاة';

  @override
  String get calculationMethod => 'طريقة الحساب';

  @override
  String autoMethod(String method) {
    return 'تلقائي: $method';
  }

  @override
  String get asrMethod => 'حساب العصر';

  @override
  String get asrStandard => 'الجمهور (الشافعي، المالكي، الحنبلي)';

  @override
  String get asrHanafi => 'الحنفي';

  @override
  String get highLatitudeRule => 'خطوط العرض العليا';

  @override
  String get hlrMiddleOfTheNight => 'منتصف الليل';

  @override
  String get hlrSeventhOfTheNight => 'سُبع الليل';

  @override
  String get hlrTwilightAngle => 'زاوية الشفق';

  @override
  String get hijriAdjustment => 'تعديل التقويم الهجري';

  @override
  String hijriAdjustmentValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days يوم',
      many: '$days يومًا',
      few: '$days أيام',
      two: 'يومان',
      one: 'يوم واحد',
      zero: 'بدون',
    );
    return '$_temp0';
  }

  @override
  String get sectionQuran => 'القرآن';

  @override
  String get arabicFontSize => 'حجم الخط العربي';

  @override
  String anglesFajrIsha(String fajr, String isha) {
    return 'الفجر $fajr° · العشاء $isha°';
  }

  @override
  String anglesFajrIshaInterval(String fajr, int minutes) {
    return 'الفجر $fajr° · العشاء بعد المغرب بـ $minutes دقيقة';
  }

  @override
  String calcMethodName(String method) {
    String _temp0 = intl.Intl.selectLogic(method, {
      'algerian': 'الجزائر (وزارة الشؤون الدينية)',
      'dubai': 'دبي',
      'egyptian': 'الهيئة المصرية العامة للمساحة',
      'france': 'فرنسا (UOIF)',
      'gulfRegion': 'منطقة الخليج',
      'indonesian': 'إندونيسيا',
      'jafari': 'الجعفري (قم)',
      'jordan': 'الأردن',
      'karachi': 'جامعة العلوم الإسلامية بكراتشي',
      'kuwait': 'الكويت',
      'moonsightingCommittee': 'لجنة رؤية الهلال',
      'morocco': 'المغرب (وزارة الأوقاف)',
      'muslimWorldLeague': 'رابطة العالم الإسلامي',
      'northAmerica': 'أمريكا الشمالية (ISNA)',
      'portugal': 'البرتغال',
      'qatar': 'قطر',
      'russia': 'روسيا',
      'singapore': 'سنغافورة',
      'tehran': 'طهران',
      'tunisia': 'تونس',
      'turkiye': 'تركيا (رئاسة الشؤون الدينية)',
      'ummAlQura': 'أم القرى (مكة المكرمة)',
      'other': 'مخصصة',
    });
    return '$_temp0';
  }

  @override
  String get sourcesIntro =>
      'محتوى سكينة مأخوذ من مصادر موثوقة. نص القرآن الكريم منقول دون أي تعديل.';

  @override
  String get privacyNote => 'يعمل تطبيق سكينة بالكامل على هاتفك: لا يتم جمع أي بيانات ولا إرسالها.';

  @override
  String get tanzilNoticeTitle => 'إشعار حقوق مشروع تنزيل';

  @override
  String get fontsTitle => 'الخطوط';

  @override
  String get tabSurahs => 'السور';

  @override
  String get tabJuz => 'الأجزاء';

  @override
  String get tabHizb => 'الأحزاب';

  @override
  String juzLabel(int n) {
    return 'الجزء $n';
  }

  @override
  String hizbLabel(int n) {
    return 'الحزب $n';
  }

  @override
  String pageLabel(int n) {
    return 'الصفحة $n';
  }

  @override
  String get goToPage => 'الانتقال إلى صفحة';

  @override
  String get go => 'انتقال';

  @override
  String get copy => 'نسخ';

  @override
  String get copied => 'تم نسخ الآية';

  @override
  String continueReadingPage(int page, String surah) {
    return 'الصفحة $page · $surah';
  }

  @override
  String surahTitle(String name) {
    return 'سورة $name';
  }

  @override
  String ayahReference(String surah, int ayah) {
    return '$surah، الآية $ayah';
  }
}
