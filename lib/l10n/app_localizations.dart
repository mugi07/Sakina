import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ar'), Locale('en'), Locale('fr')];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sakinah'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// No description provided for @navQuran.
  ///
  /// In fr, this message translates to:
  /// **'Coran'**
  String get navQuran;

  /// No description provided for @navPrayer.
  ///
  /// In fr, this message translates to:
  /// **'Prière'**
  String get navPrayer;

  /// No description provided for @navAdhkar.
  ///
  /// In fr, this message translates to:
  /// **'Adhkar'**
  String get navAdhkar;

  /// No description provided for @navMore.
  ///
  /// In fr, this message translates to:
  /// **'Plus'**
  String get navMore;

  /// No description provided for @comingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt'**
  String get comingSoon;

  /// No description provided for @comingSoonBody.
  ///
  /// In fr, this message translates to:
  /// **'Cette section arrive dans une prochaine version, in cha Allah.'**
  String get comingSoonBody;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @automatic.
  ///
  /// In fr, this message translates to:
  /// **'Automatique'**
  String get automatic;

  /// No description provided for @system.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get system;

  /// No description provided for @loadError.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue lors du chargement.'**
  String get loadError;

  /// No description provided for @homeGreeting.
  ///
  /// In fr, this message translates to:
  /// **'As-salamu alaykum'**
  String get homeGreeting;

  /// No description provided for @continueReading.
  ///
  /// In fr, this message translates to:
  /// **'Continuer la lecture'**
  String get continueReading;

  /// No description provided for @prayerFajr.
  ///
  /// In fr, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// No description provided for @prayerSunrise.
  ///
  /// In fr, this message translates to:
  /// **'Lever du soleil'**
  String get prayerSunrise;

  /// No description provided for @prayerDhuhr.
  ///
  /// In fr, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// No description provided for @prayerAsr.
  ///
  /// In fr, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// No description provided for @prayerMaghrib.
  ///
  /// In fr, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// No description provided for @prayerIsha.
  ///
  /// In fr, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// No description provided for @prayerTimesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Horaires de prière'**
  String get prayerTimesTitle;

  /// No description provided for @nextPrayer.
  ///
  /// In fr, this message translates to:
  /// **'Prochaine prière'**
  String get nextPrayer;

  /// No description provided for @timeRemaining.
  ///
  /// In fr, this message translates to:
  /// **'dans {duration}'**
  String timeRemaining(String duration);

  /// No description provided for @today.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get today;

  /// No description provided for @previousDay.
  ///
  /// In fr, this message translates to:
  /// **'Jour précédent'**
  String get previousDay;

  /// No description provided for @nextDay.
  ///
  /// In fr, this message translates to:
  /// **'Jour suivant'**
  String get nextDay;

  /// No description provided for @chooseLocation.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un lieu'**
  String get chooseLocation;

  /// No description provided for @changeLocation.
  ///
  /// In fr, this message translates to:
  /// **'Changer de lieu'**
  String get changeLocation;

  /// No description provided for @noLocationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Où êtes-vous ?'**
  String get noLocationTitle;

  /// No description provided for @noLocationBody.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre ville pour calculer les horaires de prière et la direction de la Qibla.'**
  String get noLocationBody;

  /// No description provided for @methodSummary.
  ///
  /// In fr, this message translates to:
  /// **'Méthode : {method}'**
  String methodSummary(String method);

  /// No description provided for @asrSummary.
  ///
  /// In fr, this message translates to:
  /// **'Asr : {madhab}'**
  String asrSummary(String madhab);

  /// No description provided for @qiblaTitle.
  ///
  /// In fr, this message translates to:
  /// **'Direction de la Qibla'**
  String get qiblaTitle;

  /// No description provided for @qiblaBearing.
  ///
  /// In fr, this message translates to:
  /// **'{degrees}° depuis le nord'**
  String qiblaBearing(String degrees);

  /// No description provided for @qiblaDistance.
  ///
  /// In fr, this message translates to:
  /// **'{km} km jusqu\'à la Kaaba'**
  String qiblaDistance(String km);

  /// No description provided for @qiblaHint.
  ///
  /// In fr, this message translates to:
  /// **'Repérez le nord, puis tournez de cet angle dans le sens des aiguilles d\'une montre. Ou ouvrez la boussole.'**
  String get qiblaHint;

  /// No description provided for @locationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un lieu'**
  String get locationTitle;

  /// No description provided for @searchCityHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une ville…'**
  String get searchCityHint;

  /// No description provided for @useMyLocation.
  ///
  /// In fr, this message translates to:
  /// **'Utiliser ma position actuelle'**
  String get useMyLocation;

  /// No description provided for @locating.
  ///
  /// In fr, this message translates to:
  /// **'Localisation en cours…'**
  String get locating;

  /// No description provided for @locationServiceDisabled.
  ///
  /// In fr, this message translates to:
  /// **'La localisation est désactivée sur votre téléphone.'**
  String get locationServiceDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In fr, this message translates to:
  /// **'L\'accès à la position a été refusé. Vous pouvez choisir une ville à la main.'**
  String get locationPermissionDenied;

  /// No description provided for @locationError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'obtenir votre position.'**
  String get locationError;

  /// No description provided for @myPosition.
  ///
  /// In fr, this message translates to:
  /// **'Ma position'**
  String get myPosition;

  /// No description provided for @noCityFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucune ville trouvée.'**
  String get noCityFound;

  /// No description provided for @searchCityPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Tapez au moins 2 lettres.'**
  String get searchCityPrompt;

  /// No description provided for @quranTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le Saint Coran'**
  String get quranTitle;

  /// No description provided for @meccan.
  ///
  /// In fr, this message translates to:
  /// **'Mecquoise'**
  String get meccan;

  /// No description provided for @medinan.
  ///
  /// In fr, this message translates to:
  /// **'Médinoise'**
  String get medinan;

  /// No description provided for @ayahCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 verset} other{{count} versets}}'**
  String ayahCount(int count);

  /// No description provided for @moreTitle.
  ///
  /// In fr, this message translates to:
  /// **'Plus'**
  String get moreTitle;

  /// No description provided for @hadith.
  ///
  /// In fr, this message translates to:
  /// **'Hadiths'**
  String get hadith;

  /// No description provided for @tasbih.
  ///
  /// In fr, this message translates to:
  /// **'Tasbih'**
  String get tasbih;

  /// No description provided for @asmaUlHusna.
  ///
  /// In fr, this message translates to:
  /// **'Les 99 noms d\'Allah'**
  String get asmaUlHusna;

  /// No description provided for @hijriCalendar.
  ///
  /// In fr, this message translates to:
  /// **'Calendrier hégirien'**
  String get hijriCalendar;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get settingsTitle;

  /// No description provided for @sourcesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sources et licences'**
  String get sourcesTitle;

  /// No description provided for @softwareLicenses.
  ///
  /// In fr, this message translates to:
  /// **'Licences des logiciels'**
  String get softwareLicenses;

  /// No description provided for @sectionGeneral.
  ///
  /// In fr, this message translates to:
  /// **'Général'**
  String get sectionGeneral;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get themeDark;

  /// No description provided for @sectionPrayer.
  ///
  /// In fr, this message translates to:
  /// **'Horaires de prière'**
  String get sectionPrayer;

  /// No description provided for @calculationMethod.
  ///
  /// In fr, this message translates to:
  /// **'Méthode de calcul'**
  String get calculationMethod;

  /// No description provided for @autoMethod.
  ///
  /// In fr, this message translates to:
  /// **'Automatique : {method}'**
  String autoMethod(String method);

  /// No description provided for @asrMethod.
  ///
  /// In fr, this message translates to:
  /// **'Calcul de l\'Asr'**
  String get asrMethod;

  /// No description provided for @asrStandard.
  ///
  /// In fr, this message translates to:
  /// **'Standard (chaféite, malékite, hanbalite)'**
  String get asrStandard;

  /// No description provided for @asrHanafi.
  ///
  /// In fr, this message translates to:
  /// **'Hanafite'**
  String get asrHanafi;

  /// No description provided for @highLatitudeRule.
  ///
  /// In fr, this message translates to:
  /// **'Hautes latitudes'**
  String get highLatitudeRule;

  /// No description provided for @hlrMiddleOfTheNight.
  ///
  /// In fr, this message translates to:
  /// **'Milieu de la nuit'**
  String get hlrMiddleOfTheNight;

  /// No description provided for @hlrSeventhOfTheNight.
  ///
  /// In fr, this message translates to:
  /// **'Septième de la nuit'**
  String get hlrSeventhOfTheNight;

  /// No description provided for @hlrTwilightAngle.
  ///
  /// In fr, this message translates to:
  /// **'Angle du crépuscule'**
  String get hlrTwilightAngle;

  /// No description provided for @hijriAdjustment.
  ///
  /// In fr, this message translates to:
  /// **'Ajustement du calendrier hégirien'**
  String get hijriAdjustment;

  /// No description provided for @hijriAdjustmentValue.
  ///
  /// In fr, this message translates to:
  /// **'{days, plural, =0{Aucun} =1{1 jour} other{{days} jours}}'**
  String hijriAdjustmentValue(int days);

  /// No description provided for @sectionQuran.
  ///
  /// In fr, this message translates to:
  /// **'Coran'**
  String get sectionQuran;

  /// No description provided for @arabicFontSize.
  ///
  /// In fr, this message translates to:
  /// **'Taille du texte arabe'**
  String get arabicFontSize;

  /// No description provided for @anglesFajrIsha.
  ///
  /// In fr, this message translates to:
  /// **'Fajr {fajr}° · Isha {isha}°'**
  String anglesFajrIsha(String fajr, String isha);

  /// No description provided for @anglesFajrIshaInterval.
  ///
  /// In fr, this message translates to:
  /// **'Fajr {fajr}° · Isha {minutes} min après le Maghrib'**
  String anglesFajrIshaInterval(String fajr, int minutes);

  /// No description provided for @calcMethodName.
  ///
  /// In fr, this message translates to:
  /// **'{method, select, algerian{Algérie (ministère des Affaires religieuses)} dubai{Dubaï} egyptian{Égypte (Autorité générale d\'arpentage)} france{France (UOIF)} gulfRegion{Région du Golfe} indonesian{Indonésie (KEMENAG)} jafari{Ja\'fari (Qom)} jordan{Jordanie} karachi{Karachi (Université des sciences islamiques)} kuwait{Koweït} moonsightingCommittee{Moonsighting Committee} morocco{Maroc (ministère des Habous)} muslimWorldLeague{Ligue islamique mondiale} northAmerica{Amérique du Nord (ISNA)} portugal{Portugal (Communauté islamique de Lisbonne)} qatar{Qatar} russia{Russie} singapore{Singapour (MUIS)} tehran{Téhéran} tunisia{Tunisie} turkiye{Turquie (Diyanet)} ummAlQura{Umm al-Qura (La Mecque)} other{Personnalisée}}'**
  String calcMethodName(String method);

  /// No description provided for @sourcesIntro.
  ///
  /// In fr, this message translates to:
  /// **'Le contenu de Sakinah provient de sources reconnues. Le texte du Coran est reproduit sans aucune modification.'**
  String get sourcesIntro;

  /// No description provided for @privacyNote.
  ///
  /// In fr, this message translates to:
  /// **'Sakinah fonctionne entièrement sur votre téléphone : aucune donnée n\'est collectée ni envoyée.'**
  String get privacyNote;

  /// No description provided for @tanzilNoticeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Avis de copyright Tanzil'**
  String get tanzilNoticeTitle;

  /// No description provided for @fontsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Polices'**
  String get fontsTitle;

  /// No description provided for @tabSurahs.
  ///
  /// In fr, this message translates to:
  /// **'Sourates'**
  String get tabSurahs;

  /// No description provided for @tabJuz.
  ///
  /// In fr, this message translates to:
  /// **'Juz'**
  String get tabJuz;

  /// No description provided for @tabHizb.
  ///
  /// In fr, this message translates to:
  /// **'Hizb'**
  String get tabHizb;

  /// No description provided for @juzLabel.
  ///
  /// In fr, this message translates to:
  /// **'Juz {n}'**
  String juzLabel(int n);

  /// No description provided for @hizbLabel.
  ///
  /// In fr, this message translates to:
  /// **'Hizb {n}'**
  String hizbLabel(int n);

  /// No description provided for @pageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Page {n}'**
  String pageLabel(int n);

  /// No description provided for @goToPage.
  ///
  /// In fr, this message translates to:
  /// **'Aller à la page'**
  String get goToPage;

  /// No description provided for @go.
  ///
  /// In fr, this message translates to:
  /// **'Aller'**
  String get go;

  /// No description provided for @copy.
  ///
  /// In fr, this message translates to:
  /// **'Copier'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In fr, this message translates to:
  /// **'Verset copié'**
  String get copied;

  /// No description provided for @continueReadingPage.
  ///
  /// In fr, this message translates to:
  /// **'Page {page} · {surah}'**
  String continueReadingPage(int page, String surah);

  /// No description provided for @surahTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sourate {name}'**
  String surahTitle(String name);

  /// No description provided for @ayahReference.
  ///
  /// In fr, this message translates to:
  /// **'{surah}, verset {ayah}'**
  String ayahReference(String surah, int ayah);

  /// No description provided for @adhanTitle.
  ///
  /// In fr, this message translates to:
  /// **'{prayer} — {time}'**
  String adhanTitle(String prayer, String time);

  /// No description provided for @adhanBody.
  ///
  /// In fr, this message translates to:
  /// **'C\'est l\'heure de la prière du {prayer}.'**
  String adhanBody(String prayer);

  /// No description provided for @reminderTitle.
  ///
  /// In fr, this message translates to:
  /// **'{prayer} dans {minutes} min'**
  String reminderTitle(String prayer, int minutes);

  /// No description provided for @reminderBody.
  ///
  /// In fr, this message translates to:
  /// **'Préparez-vous pour la prière, in cha Allah.'**
  String get reminderBody;

  /// No description provided for @adhanChannelName.
  ///
  /// In fr, this message translates to:
  /// **'Heures de prière'**
  String get adhanChannelName;

  /// No description provided for @adhanChannelDescription.
  ///
  /// In fr, this message translates to:
  /// **'Notification à l\'heure de chaque prière'**
  String get adhanChannelDescription;

  /// No description provided for @sectionAdhan.
  ///
  /// In fr, this message translates to:
  /// **'Notifications de prière'**
  String get sectionAdhan;

  /// No description provided for @adhanNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Notification à l\'heure de la prière'**
  String get adhanNotifications;

  /// No description provided for @adhanPrayersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prières concernées'**
  String get adhanPrayersTitle;

  /// No description provided for @reminderBefore.
  ///
  /// In fr, this message translates to:
  /// **'Rappel avant la prière'**
  String get reminderBefore;

  /// No description provided for @reminderValue.
  ///
  /// In fr, this message translates to:
  /// **'{minutes, plural, =0{Aucun} other{{minutes} min avant}}'**
  String reminderValue(int minutes);

  /// No description provided for @notificationsDenied.
  ///
  /// In fr, this message translates to:
  /// **'Les notifications sont bloquées. Autorisez-les pour recevoir les heures de prière.'**
  String get notificationsDenied;

  /// No description provided for @allow.
  ///
  /// In fr, this message translates to:
  /// **'Autoriser'**
  String get allow;

  /// No description provided for @welcomeTagline.
  ///
  /// In fr, this message translates to:
  /// **'Coran, prière, Qibla et invocations. Gratuit, sans publicité, sans compte.'**
  String get welcomeTagline;

  /// No description provided for @welcomeLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre langue'**
  String get welcomeLanguage;

  /// No description provided for @continueLabel.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get continueLabel;

  /// No description provided for @later.
  ///
  /// In fr, this message translates to:
  /// **'Plus tard'**
  String get later;

  /// No description provided for @start.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get start;

  /// No description provided for @welcomeLocationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre ville'**
  String get welcomeLocationTitle;

  /// No description provided for @welcomeLocationBody.
  ///
  /// In fr, this message translates to:
  /// **'Pour calculer les horaires de prière et la direction de la Qibla. Votre position reste sur votre téléphone.'**
  String get welcomeLocationBody;

  /// No description provided for @welcomeNotifTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications de prière'**
  String get welcomeNotifTitle;

  /// No description provided for @welcomeNotifBody.
  ///
  /// In fr, this message translates to:
  /// **'Recevez une notification à l\'heure de chaque prière. Vous pourrez choisir les prières dans les réglages.'**
  String get welcomeNotifBody;

  /// No description provided for @notificationsAllowed.
  ///
  /// In fr, this message translates to:
  /// **'Notifications autorisées'**
  String get notificationsAllowed;

  /// No description provided for @monthlyTimetable.
  ///
  /// In fr, this message translates to:
  /// **'Horaires du mois'**
  String get monthlyTimetable;

  /// No description provided for @dayColumn.
  ///
  /// In fr, this message translates to:
  /// **'Jour'**
  String get dayColumn;

  /// No description provided for @previousMonth.
  ///
  /// In fr, this message translates to:
  /// **'Mois précédent'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In fr, this message translates to:
  /// **'Mois suivant'**
  String get nextMonth;

  /// No description provided for @exactAlarmsDenied.
  ///
  /// In fr, this message translates to:
  /// **'Les notifications peuvent arriver en retard : autorisez « Alarmes et rappels » pour l\'heure exacte.'**
  String get exactAlarmsDenied;

  /// No description provided for @openCompass.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir la boussole'**
  String get openCompass;

  /// No description provided for @qiblaCompassTitle.
  ///
  /// In fr, this message translates to:
  /// **'Boussole Qibla'**
  String get qiblaCompassTitle;

  /// No description provided for @qiblaAligned.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes face à la Qibla'**
  String get qiblaAligned;

  /// No description provided for @turnRight.
  ///
  /// In fr, this message translates to:
  /// **'Tournez vers la droite : {deg}°'**
  String turnRight(String deg);

  /// No description provided for @turnLeft.
  ///
  /// In fr, this message translates to:
  /// **'Tournez vers la gauche : {deg}°'**
  String turnLeft(String deg);

  /// No description provided for @compassUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Boussole indisponible sur cet appareil. Utilisez le soleil (ci-dessous) ou l\'angle ci-dessus avec une boussole classique.'**
  String get compassUnavailable;

  /// No description provided for @calibrateTip.
  ///
  /// In fr, this message translates to:
  /// **'Précision faible : faites des mouvements en forme de 8 avec le téléphone pour calibrer la boussole.'**
  String get calibrateTip;

  /// No description provided for @metalWarning.
  ///
  /// In fr, this message translates to:
  /// **'Tenez le téléphone à plat, loin des objets métalliques, des aimants et des appareils électriques.'**
  String get metalWarning;

  /// No description provided for @declinationNote.
  ///
  /// In fr, this message translates to:
  /// **'Déclinaison magnétique corrigée : {deg}°'**
  String declinationNote(String deg);

  /// No description provided for @compassNeedsLocation.
  ///
  /// In fr, this message translates to:
  /// **'Autorisez la localisation pour activer la boussole.'**
  String get compassNeedsLocation;

  /// No description provided for @hadithSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher dans les hadiths…'**
  String get hadithSearchHint;

  /// No description provided for @hadithCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 hadith} other{{count} hadiths}}'**
  String hadithCount(int count);

  /// No description provided for @chapterLabel.
  ///
  /// In fr, this message translates to:
  /// **'Chapitre {n}'**
  String chapterLabel(int n);

  /// No description provided for @translationMissing.
  ///
  /// In fr, this message translates to:
  /// **'Traduction non disponible pour ce hadith dans cette langue.'**
  String get translationMissing;

  /// No description provided for @hadithNumber.
  ///
  /// In fr, this message translates to:
  /// **'Hadith {number}'**
  String hadithNumber(String number);

  /// No description provided for @sahihCollection.
  ///
  /// In fr, this message translates to:
  /// **'Recueil authentique (sahih)'**
  String get sahihCollection;

  /// No description provided for @hadithOfTheDay.
  ///
  /// In fr, this message translates to:
  /// **'Hadith du jour'**
  String get hadithOfTheDay;

  /// No description provided for @preparingHadiths.
  ///
  /// In fr, this message translates to:
  /// **'Préparation des hadiths (première ouverture)…'**
  String get preparingHadiths;

  /// No description provided for @noResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat.'**
  String get noResults;

  /// No description provided for @search.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get search;

  /// No description provided for @tasbihTarget.
  ///
  /// In fr, this message translates to:
  /// **'Objectif'**
  String get tasbihTarget;

  /// No description provided for @tasbihFree.
  ///
  /// In fr, this message translates to:
  /// **'Libre'**
  String get tasbihFree;

  /// No description provided for @tasbihToday.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui : {count}'**
  String tasbihToday(int count);

  /// No description provided for @tasbihReset.
  ///
  /// In fr, this message translates to:
  /// **'Remettre à zéro'**
  String get tasbihReset;

  /// No description provided for @tasbihCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Objectif atteint, qu\'Allah l\'accepte'**
  String get tasbihCompleted;

  /// No description provided for @tasbihTapHint.
  ///
  /// In fr, this message translates to:
  /// **'Touchez le cercle pour compter'**
  String get tasbihTapHint;

  /// No description provided for @phraseSubhanallah.
  ///
  /// In fr, this message translates to:
  /// **'Gloire à Allah'**
  String get phraseSubhanallah;

  /// No description provided for @phraseAlhamdulillah.
  ///
  /// In fr, this message translates to:
  /// **'Louange à Allah'**
  String get phraseAlhamdulillah;

  /// No description provided for @phraseAllahuakbar.
  ///
  /// In fr, this message translates to:
  /// **'Allah est le plus grand'**
  String get phraseAllahuakbar;

  /// No description provided for @phraseLailaha.
  ///
  /// In fr, this message translates to:
  /// **'Il n\'y a de divinité qu\'Allah'**
  String get phraseLailaha;

  /// No description provided for @phraseAstaghfirullah.
  ///
  /// In fr, this message translates to:
  /// **'Je demande pardon à Allah'**
  String get phraseAstaghfirullah;

  /// No description provided for @phraseSalawat.
  ///
  /// In fr, this message translates to:
  /// **'Ô Allah, prie sur Muhammad'**
  String get phraseSalawat;

  /// No description provided for @adhkarEssentials.
  ///
  /// In fr, this message translates to:
  /// **'Essentiels'**
  String get adhkarEssentials;

  /// No description provided for @adhkarAllChapters.
  ///
  /// In fr, this message translates to:
  /// **'Tous les chapitres'**
  String get adhkarAllChapters;

  /// No description provided for @adhkarSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un chapitre…'**
  String get adhkarSearchHint;

  /// No description provided for @repeatTimes.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 fois} other{{count} fois}}'**
  String repeatTimes(int count);

  /// No description provided for @adhkarDone.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get adhkarDone;

  /// No description provided for @adhkarTapHint.
  ///
  /// In fr, this message translates to:
  /// **'Touchez une invocation à chaque récitation.'**
  String get adhkarTapHint;

  /// No description provided for @translationEnglishPending.
  ///
  /// In fr, this message translates to:
  /// **'Traduction française à venir — en anglais :'**
  String get translationEnglishPending;

  /// No description provided for @restart.
  ///
  /// In fr, this message translates to:
  /// **'Recommencer'**
  String get restart;

  /// No description provided for @adhkarProgress.
  ///
  /// In fr, this message translates to:
  /// **'{done} / {total}'**
  String adhkarProgress(int done, int total);

  /// No description provided for @verseOfTheDay.
  ///
  /// In fr, this message translates to:
  /// **'Verset du jour'**
  String get verseOfTheDay;

  /// No description provided for @morningAdhkar.
  ///
  /// In fr, this message translates to:
  /// **'Adhkar du matin'**
  String get morningAdhkar;

  /// No description provided for @eveningAdhkar.
  ///
  /// In fr, this message translates to:
  /// **'Adhkar du soir'**
  String get eveningAdhkar;

  /// No description provided for @adhkarReminderBodyMorning.
  ///
  /// In fr, this message translates to:
  /// **'Prenez quelques minutes pour les invocations du matin.'**
  String get adhkarReminderBodyMorning;

  /// No description provided for @adhkarReminderBodyEvening.
  ///
  /// In fr, this message translates to:
  /// **'Prenez quelques minutes pour les invocations du soir.'**
  String get adhkarReminderBodyEvening;

  /// No description provided for @adhkarReminders.
  ///
  /// In fr, this message translates to:
  /// **'Rappel des adhkar du matin et du soir'**
  String get adhkarReminders;

  /// No description provided for @adhkarRemindersHint.
  ///
  /// In fr, this message translates to:
  /// **'30 min après le Fajr et après le Asr'**
  String get adhkarRemindersHint;

  /// No description provided for @share.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get share;

  /// No description provided for @quranSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher dans le Coran…'**
  String get quranSearchHint;

  /// No description provided for @tabBookmarks.
  ///
  /// In fr, this message translates to:
  /// **'Signets'**
  String get tabBookmarks;

  /// No description provided for @noBookmarks.
  ///
  /// In fr, this message translates to:
  /// **'Aucun signet. Touchez un verset dans le mushaf, puis l\'icône signet.'**
  String get noBookmarks;

  /// No description provided for @bookmarkAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un signet'**
  String get bookmarkAdd;

  /// No description provided for @bookmarkRemove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer le signet'**
  String get bookmarkRemove;

  /// No description provided for @searchResultsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun résultat} =1{1 verset} other{{count} versets}}'**
  String searchResultsCount(int count);

  /// No description provided for @listen.
  ///
  /// In fr, this message translates to:
  /// **'Écouter'**
  String get listen;

  /// No description provided for @listenFromHere.
  ///
  /// In fr, this message translates to:
  /// **'Écouter à partir de ce verset'**
  String get listenFromHere;

  /// No description provided for @reciter.
  ///
  /// In fr, this message translates to:
  /// **'Récitateur'**
  String get reciter;

  /// No description provided for @repeatVerse.
  ///
  /// In fr, this message translates to:
  /// **'Répéter le verset'**
  String get repeatVerse;

  /// No description provided for @stop.
  ///
  /// In fr, this message translates to:
  /// **'Arrêter'**
  String get stop;

  /// No description provided for @recitationChannel.
  ///
  /// In fr, this message translates to:
  /// **'Récitation du Coran'**
  String get recitationChannel;

  /// No description provided for @audioNeedsInternet.
  ///
  /// In fr, this message translates to:
  /// **'Connexion internet nécessaire pour la première écoute de ce verset.'**
  String get audioNeedsInternet;

  /// No description provided for @previous.
  ///
  /// In fr, this message translates to:
  /// **'Précédent'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get next;

  /// No description provided for @pause.
  ///
  /// In fr, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @eventName.
  ///
  /// In fr, this message translates to:
  /// **'{event, select, newYear{Nouvel an hégirien} ashura{Achoura} mawlid{Mawlid (naissance du Prophète ﷺ, date traditionnelle)} israMiraj{Isra\' et Mi\'raj (date traditionnelle)} ramadanStart{Début du Ramadan} lastTenNights{Dix dernières nuits du Ramadan} eidAlFitr{Aïd al-Fitr} dhulHijjahTenDays{Dix premiers jours de Dhou al-hijja} arafah{Jour de \'Arafa} eidAlAdha{Aïd al-Adha} other{Événement}}'**
  String eventName(String event);

  /// No description provided for @upcomingEvents.
  ///
  /// In fr, this message translates to:
  /// **'Prochains événements'**
  String get upcomingEvents;

  /// No description provided for @inDays.
  ///
  /// In fr, this message translates to:
  /// **'{days, plural, =0{Aujourd\'hui} =1{Demain} other{Dans {days} jours}}'**
  String inDays(int days);

  /// No description provided for @fastingRecommended.
  ///
  /// In fr, this message translates to:
  /// **'Jeûne recommandé'**
  String get fastingRecommended;

  /// No description provided for @whiteDays.
  ///
  /// In fr, this message translates to:
  /// **'Jours blancs (13, 14, 15) : jeûne recommandé'**
  String get whiteDays;

  /// No description provided for @eventsThisMonth.
  ///
  /// In fr, this message translates to:
  /// **'Ce mois-ci'**
  String get eventsThisMonth;

  /// No description provided for @asmaSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un nom…'**
  String get asmaSearchHint;

  /// No description provided for @asmaReviewNote.
  ///
  /// In fr, this message translates to:
  /// **'Liste rapportée par at-Tirmidhi. Les traductions sont indicatives.'**
  String get asmaReviewNote;

  /// No description provided for @khatmaTitle.
  ///
  /// In fr, this message translates to:
  /// **'Khatma'**
  String get khatmaTitle;

  /// No description provided for @khatmaIntro.
  ///
  /// In fr, this message translates to:
  /// **'Lisez le Coran en entier en un nombre de jours choisi. L\'app calcule votre objectif de chaque jour.'**
  String get khatmaIntro;

  /// No description provided for @khatmaDuration.
  ///
  /// In fr, this message translates to:
  /// **'Durée'**
  String get khatmaDuration;

  /// No description provided for @khatmaDays.
  ///
  /// In fr, this message translates to:
  /// **'{days} jours'**
  String khatmaDays(int days);

  /// No description provided for @khatmaStartFrom.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get khatmaStartFrom;

  /// No description provided for @khatmaFromBeginning.
  ///
  /// In fr, this message translates to:
  /// **'Depuis le début'**
  String get khatmaFromBeginning;

  /// No description provided for @khatmaFromPage.
  ///
  /// In fr, this message translates to:
  /// **'Depuis la page {page}'**
  String khatmaFromPage(int page);

  /// No description provided for @khatmaStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer la khatma'**
  String get khatmaStart;

  /// No description provided for @khatmaReminder.
  ///
  /// In fr, this message translates to:
  /// **'Rappel quotidien'**
  String get khatmaReminder;

  /// No description provided for @khatmaReminderOff.
  ///
  /// In fr, this message translates to:
  /// **'Aucun'**
  String get khatmaReminderOff;

  /// No description provided for @khatmaDayOf.
  ///
  /// In fr, this message translates to:
  /// **'Jour {day} sur {days}'**
  String khatmaDayOf(int day, int days);

  /// No description provided for @khatmaPagesPerDay.
  ///
  /// In fr, this message translates to:
  /// **'{pages} pages par jour'**
  String khatmaPagesPerDay(int pages);

  /// No description provided for @khatmaTodayGoal.
  ///
  /// In fr, this message translates to:
  /// **'Objectif d\'aujourd\'hui : jusqu\'à la page {page}'**
  String khatmaTodayGoal(int page);

  /// No description provided for @khatmaRemainingToday.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Objectif du jour atteint} =1{Encore 1 page aujourd\'hui} other{Encore {count} pages aujourd\'hui}}'**
  String khatmaRemainingToday(int count);

  /// No description provided for @khatmaBehind.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 page de retard} other{{count} pages de retard}}'**
  String khatmaBehind(int count);

  /// No description provided for @khatmaAhead.
  ///
  /// In fr, this message translates to:
  /// **'En avance sur votre objectif'**
  String get khatmaAhead;

  /// No description provided for @khatmaOnTrack.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes dans les temps'**
  String get khatmaOnTrack;

  /// No description provided for @khatmaCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Khatma terminée, qu\'Allah l\'accepte de vous !'**
  String get khatmaCompleted;

  /// No description provided for @khatmaCompletedCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 khatma terminée} other{{count} khatmas terminées}}'**
  String khatmaCompletedCount(int count);

  /// No description provided for @khatmaContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer à la page {page}'**
  String khatmaContinue(int page);

  /// No description provided for @khatmaMarkRead.
  ///
  /// In fr, this message translates to:
  /// **'Khatma : lu jusqu\'ici'**
  String get khatmaMarkRead;

  /// No description provided for @khatmaMarkedRead.
  ///
  /// In fr, this message translates to:
  /// **'Khatma : lu jusqu\'à la page {page}'**
  String khatmaMarkedRead(int page);

  /// No description provided for @khatmaSetPage.
  ///
  /// In fr, this message translates to:
  /// **'Indiquer la dernière page lue'**
  String get khatmaSetPage;

  /// No description provided for @khatmaStop.
  ///
  /// In fr, this message translates to:
  /// **'Arrêter la khatma'**
  String get khatmaStop;

  /// No description provided for @khatmaStopConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Arrêter cette khatma ? La progression sera perdue.'**
  String get khatmaStopConfirm;

  /// No description provided for @khatmaRestart.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle khatma'**
  String get khatmaRestart;

  /// No description provided for @khatmaReminderBody.
  ///
  /// In fr, this message translates to:
  /// **'Lisez {pages} pages aujourd\'hui pour tenir votre objectif.'**
  String khatmaReminderBody(int pages);

  /// No description provided for @khatmaProgress.
  ///
  /// In fr, this message translates to:
  /// **'{read} / {total} pages'**
  String khatmaProgress(int read, int total);

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @addWidget.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter le widget à l\'écran d\'accueil'**
  String get addWidget;

  /// No description provided for @widgetNoLocation.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrez Sakinah pour choisir votre ville.'**
  String get widgetNoLocation;

  /// No description provided for @findQibla.
  ///
  /// In fr, this message translates to:
  /// **'Trouver la Qibla'**
  String get findQibla;

  /// No description provided for @sunMethodTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sans boussole : avec le soleil'**
  String get sunMethodTitle;

  /// No description provided for @sunFaceRight.
  ///
  /// In fr, this message translates to:
  /// **'Faites face au soleil, puis tournez de {deg}° vers la droite.'**
  String sunFaceRight(String deg);

  /// No description provided for @sunFaceLeft.
  ///
  /// In fr, this message translates to:
  /// **'Faites face au soleil, puis tournez de {deg}° vers la gauche.'**
  String sunFaceLeft(String deg);

  /// No description provided for @sunFaceAhead.
  ///
  /// In fr, this message translates to:
  /// **'Faites face au soleil : la Qibla est droit devant vous.'**
  String get sunFaceAhead;

  /// No description provided for @sunTooHigh.
  ///
  /// In fr, this message translates to:
  /// **'Le soleil est trop haut pour servir de repère. Réessayez un peu plus tard.'**
  String get sunTooHigh;

  /// No description provided for @sunBelowHorizon.
  ///
  /// In fr, this message translates to:
  /// **'Le soleil est couché. Cette méthode fonctionne à nouveau à partir de {time}.'**
  String sunBelowHorizon(String time);

  /// No description provided for @sunCompassCheck.
  ///
  /// In fr, this message translates to:
  /// **'Vérification : le soleil dessiné sur la boussole doit indiquer le vrai soleil. Sinon, calibrez la boussole.'**
  String get sunCompassCheck;

  /// No description provided for @kaabaTransit.
  ///
  /// In fr, this message translates to:
  /// **'Le {date} à {time}, le soleil passera juste au-dessus de la Kaaba : faites-lui face et vous serez face à la Qibla.'**
  String kaabaTransit(String date, String time);

  /// No description provided for @qibla.
  ///
  /// In fr, this message translates to:
  /// **'Qibla'**
  String get qibla;

  /// No description provided for @testNotification.
  ///
  /// In fr, this message translates to:
  /// **'Tester la notification'**
  String get testNotification;

  /// No description provided for @testNotificationHint.
  ///
  /// In fr, this message translates to:
  /// **'Envoie une notification dans quelques secondes pour vérifier le son et l\'affichage.'**
  String get testNotificationHint;

  /// No description provided for @testNotificationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sakinah : notification de test'**
  String get testNotificationTitle;

  /// No description provided for @testNotificationBody.
  ///
  /// In fr, this message translates to:
  /// **'Les notifications fonctionnent. Vous serez prévenu à l\'heure de chaque prière.'**
  String get testNotificationBody;

  /// No description provided for @testNotificationScheduled.
  ///
  /// In fr, this message translates to:
  /// **'Notification de test dans {seconds} secondes : vous pouvez verrouiller le téléphone.'**
  String testNotificationScheduled(int seconds);

  /// No description provided for @testNotificationSent.
  ///
  /// In fr, this message translates to:
  /// **'Notification de test envoyée.'**
  String get testNotificationSent;

  /// No description provided for @adhanSound.
  ///
  /// In fr, this message translates to:
  /// **'Son de l\'adhan'**
  String get adhanSound;

  /// No description provided for @adhanSoundHint.
  ///
  /// In fr, this message translates to:
  /// **'« Allahu Akbar, Allahu Akbar » à l\'heure de chaque prière (sinon, le son du téléphone).'**
  String get adhanSoundHint;

  /// No description provided for @remindersChannelName.
  ///
  /// In fr, this message translates to:
  /// **'Rappels'**
  String get remindersChannelName;

  /// No description provided for @remindersChannelDescription.
  ///
  /// In fr, this message translates to:
  /// **'Rappels avant la prière, adhkar et khatma'**
  String get remindersChannelDescription;

  /// No description provided for @dedicationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sadaqa jariya'**
  String get dedicationTitle;

  /// No description provided for @dedicationBasmala.
  ///
  /// In fr, this message translates to:
  /// **'Au nom d\'Allah, le Tout Miséricordieux, le Très Miséricordieux.'**
  String get dedicationBasmala;

  /// No description provided for @dedicationBody.
  ///
  /// In fr, this message translates to:
  /// **'Cette application est entièrement gratuite, sans publicité.\n\nElle est une sadaqa jariya (aumône continue) pour l\'âme de ma tante Zahra Hafidi, de mon oncle Mohammed Hafidi et de mon grand-père Abdellah Hafidi, qu\'Allah leur fasse miséricorde.\n\nQu\'Allah l\'accepte, leur pardonne et les accueille au Paradis.\n\nN\'oubliez pas de faire une invocation (dou\'a) pour eux.'**
  String get dedicationBody;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
