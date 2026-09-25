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
  /// **'Sakina'**
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

  /// No description provided for @continueReadingSurah.
  ///
  /// In fr, this message translates to:
  /// **'Sourate {name}'**
  String continueReadingSurah(String name);

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
  /// **'Repérez le nord, puis tournez de cet angle dans le sens des aiguilles d\'une montre. La boussole en direct arrive bientôt.'**
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

  /// No description provided for @translation.
  ///
  /// In fr, this message translates to:
  /// **'Traduction'**
  String get translation;

  /// No description provided for @translationAuto.
  ///
  /// In fr, this message translates to:
  /// **'Selon la langue de l\'app'**
  String get translationAuto;

  /// No description provided for @translationNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucune'**
  String get translationNone;

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
  /// **'Le contenu de Sakina provient de sources reconnues. Le texte du Coran est reproduit sans aucune modification.'**
  String get sourcesIntro;

  /// No description provided for @privacyNote.
  ///
  /// In fr, this message translates to:
  /// **'Sakina fonctionne entièrement sur votre téléphone : aucune donnée n\'est collectée ni envoyée.'**
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
