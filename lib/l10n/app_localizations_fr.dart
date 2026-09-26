// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Sakinah';

  @override
  String get navHome => 'Accueil';

  @override
  String get navQuran => 'Coran';

  @override
  String get navPrayer => 'Prière';

  @override
  String get navAdhkar => 'Adhkar';

  @override
  String get navMore => 'Plus';

  @override
  String get comingSoon => 'Bientôt';

  @override
  String get comingSoonBody => 'Cette section arrive dans une prochaine version, in cha Allah.';

  @override
  String get retry => 'Réessayer';

  @override
  String get cancel => 'Annuler';

  @override
  String get automatic => 'Automatique';

  @override
  String get system => 'Système';

  @override
  String get loadError => 'Une erreur est survenue lors du chargement.';

  @override
  String get homeGreeting => 'As-salamu alaykum';

  @override
  String get continueReading => 'Continuer la lecture';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerSunrise => 'Lever du soleil';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get prayerTimesTitle => 'Horaires de prière';

  @override
  String get nextPrayer => 'Prochaine prière';

  @override
  String timeRemaining(String duration) {
    return 'dans $duration';
  }

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get previousDay => 'Jour précédent';

  @override
  String get nextDay => 'Jour suivant';

  @override
  String get chooseLocation => 'Choisir un lieu';

  @override
  String get changeLocation => 'Changer de lieu';

  @override
  String get noLocationTitle => 'Où êtes-vous ?';

  @override
  String get noLocationBody =>
      'Choisissez votre ville pour calculer les horaires de prière et la direction de la Qibla.';

  @override
  String methodSummary(String method) {
    return 'Méthode : $method';
  }

  @override
  String asrSummary(String madhab) {
    return 'Asr : $madhab';
  }

  @override
  String get qiblaTitle => 'Direction de la Qibla';

  @override
  String qiblaBearing(String degrees) {
    return '$degrees° depuis le nord';
  }

  @override
  String qiblaDistance(String km) {
    return '$km km jusqu\'à la Kaaba';
  }

  @override
  String get qiblaHint =>
      'Repérez le nord, puis tournez de cet angle dans le sens des aiguilles d\'une montre. Ou ouvrez la boussole.';

  @override
  String get locationTitle => 'Choisir un lieu';

  @override
  String get searchCityHint => 'Rechercher une ville…';

  @override
  String get useMyLocation => 'Utiliser ma position actuelle';

  @override
  String get locating => 'Localisation en cours…';

  @override
  String get locationServiceDisabled => 'La localisation est désactivée sur votre téléphone.';

  @override
  String get locationPermissionDenied =>
      'L\'accès à la position a été refusé. Vous pouvez choisir une ville à la main.';

  @override
  String get locationError => 'Impossible d\'obtenir votre position.';

  @override
  String get myPosition => 'Ma position';

  @override
  String get noCityFound => 'Aucune ville trouvée.';

  @override
  String get searchCityPrompt => 'Tapez au moins 2 lettres.';

  @override
  String get quranTitle => 'Le Saint Coran';

  @override
  String get meccan => 'Mecquoise';

  @override
  String get medinan => 'Médinoise';

  @override
  String ayahCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count versets',
      one: '1 verset',
    );
    return '$_temp0';
  }

  @override
  String get moreTitle => 'Plus';

  @override
  String get hadith => 'Hadiths';

  @override
  String get tasbih => 'Tasbih';

  @override
  String get asmaUlHusna => 'Les 99 noms d\'Allah';

  @override
  String get hijriCalendar => 'Calendrier hégirien';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get sourcesTitle => 'Sources et licences';

  @override
  String get softwareLicenses => 'Licences des logiciels';

  @override
  String get sectionGeneral => 'Général';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get sectionPrayer => 'Horaires de prière';

  @override
  String get calculationMethod => 'Méthode de calcul';

  @override
  String autoMethod(String method) {
    return 'Automatique : $method';
  }

  @override
  String get asrMethod => 'Calcul de l\'Asr';

  @override
  String get asrStandard => 'Standard (chaféite, malékite, hanbalite)';

  @override
  String get asrHanafi => 'Hanafite';

  @override
  String get highLatitudeRule => 'Hautes latitudes';

  @override
  String get hlrMiddleOfTheNight => 'Milieu de la nuit';

  @override
  String get hlrSeventhOfTheNight => 'Septième de la nuit';

  @override
  String get hlrTwilightAngle => 'Angle du crépuscule';

  @override
  String get hijriAdjustment => 'Ajustement du calendrier hégirien';

  @override
  String hijriAdjustmentValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours',
      one: '1 jour',
      zero: 'Aucun',
    );
    return '$_temp0';
  }

  @override
  String get sectionQuran => 'Coran';

  @override
  String get arabicFontSize => 'Taille du texte arabe';

  @override
  String anglesFajrIsha(String fajr, String isha) {
    return 'Fajr $fajr° · Isha $isha°';
  }

  @override
  String anglesFajrIshaInterval(String fajr, int minutes) {
    return 'Fajr $fajr° · Isha $minutes min après le Maghrib';
  }

  @override
  String calcMethodName(String method) {
    String _temp0 = intl.Intl.selectLogic(method, {
      'algerian': 'Algérie (ministère des Affaires religieuses)',
      'dubai': 'Dubaï',
      'egyptian': 'Égypte (Autorité générale d\'arpentage)',
      'france': 'France (UOIF)',
      'gulfRegion': 'Région du Golfe',
      'indonesian': 'Indonésie (KEMENAG)',
      'jafari': 'Ja\'fari (Qom)',
      'jordan': 'Jordanie',
      'karachi': 'Karachi (Université des sciences islamiques)',
      'kuwait': 'Koweït',
      'moonsightingCommittee': 'Moonsighting Committee',
      'morocco': 'Maroc (ministère des Habous)',
      'muslimWorldLeague': 'Ligue islamique mondiale',
      'northAmerica': 'Amérique du Nord (ISNA)',
      'portugal': 'Portugal (Communauté islamique de Lisbonne)',
      'qatar': 'Qatar',
      'russia': 'Russie',
      'singapore': 'Singapour (MUIS)',
      'tehran': 'Téhéran',
      'tunisia': 'Tunisie',
      'turkiye': 'Turquie (Diyanet)',
      'ummAlQura': 'Umm al-Qura (La Mecque)',
      'other': 'Personnalisée',
    });
    return '$_temp0';
  }

  @override
  String get sourcesIntro =>
      'Le contenu de Sakina provient de sources reconnues. Le texte du Coran est reproduit sans aucune modification.';

  @override
  String get privacyNote =>
      'Sakina fonctionne entièrement sur votre téléphone : aucune donnée n\'est collectée ni envoyée.';

  @override
  String get tanzilNoticeTitle => 'Avis de copyright Tanzil';

  @override
  String get fontsTitle => 'Polices';

  @override
  String get tabSurahs => 'Sourates';

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
  String get goToPage => 'Aller à la page';

  @override
  String get go => 'Aller';

  @override
  String get copy => 'Copier';

  @override
  String get copied => 'Verset copié';

  @override
  String continueReadingPage(int page, String surah) {
    return 'Page $page · $surah';
  }

  @override
  String surahTitle(String name) {
    return 'Sourate $name';
  }

  @override
  String ayahReference(String surah, int ayah) {
    return '$surah, verset $ayah';
  }

  @override
  String adhanTitle(String prayer, String time) {
    return '$prayer — $time';
  }

  @override
  String adhanBody(String prayer) {
    return 'C\'est l\'heure de la prière du $prayer.';
  }

  @override
  String reminderTitle(String prayer, int minutes) {
    return '$prayer dans $minutes min';
  }

  @override
  String get reminderBody => 'Préparez-vous pour la prière, in cha Allah.';

  @override
  String get adhanChannelName => 'Heures de prière';

  @override
  String get adhanChannelDescription => 'Notification à l\'heure de chaque prière';

  @override
  String get sectionAdhan => 'Notifications de prière';

  @override
  String get adhanNotifications => 'Notification à l\'heure de la prière';

  @override
  String get adhanPrayersTitle => 'Prières concernées';

  @override
  String get reminderBefore => 'Rappel avant la prière';

  @override
  String reminderValue(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min avant',
      zero: 'Aucun',
    );
    return '$_temp0';
  }

  @override
  String get notificationsDenied =>
      'Les notifications sont bloquées. Autorisez-les pour recevoir les heures de prière.';

  @override
  String get allow => 'Autoriser';

  @override
  String get welcomeTagline =>
      'Coran, prière, Qibla et invocations. Gratuit, sans publicité, sans compte.';

  @override
  String get welcomeLanguage => 'Choisissez votre langue';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get later => 'Plus tard';

  @override
  String get start => 'Commencer';

  @override
  String get welcomeLocationTitle => 'Votre ville';

  @override
  String get welcomeLocationBody =>
      'Pour calculer les horaires de prière et la direction de la Qibla. Votre position reste sur votre téléphone.';

  @override
  String get welcomeNotifTitle => 'Notifications de prière';

  @override
  String get welcomeNotifBody =>
      'Recevez une notification à l\'heure de chaque prière. Vous pourrez choisir les prières dans les réglages.';

  @override
  String get notificationsAllowed => 'Notifications autorisées';

  @override
  String get monthlyTimetable => 'Horaires du mois';

  @override
  String get dayColumn => 'Jour';

  @override
  String get previousMonth => 'Mois précédent';

  @override
  String get nextMonth => 'Mois suivant';

  @override
  String get exactAlarmsDenied =>
      'Les notifications peuvent arriver en retard : autorisez « Alarmes et rappels » pour l\'heure exacte.';

  @override
  String get openCompass => 'Ouvrir la boussole';

  @override
  String get qiblaCompassTitle => 'Boussole Qibla';

  @override
  String get qiblaAligned => 'Vous êtes face à la Qibla';

  @override
  String turnRight(String deg) {
    return 'Tournez vers la droite : $deg°';
  }

  @override
  String turnLeft(String deg) {
    return 'Tournez vers la gauche : $deg°';
  }

  @override
  String get compassUnavailable =>
      'Boussole indisponible sur cet appareil. Utilisez l\'angle ci-dessus avec une boussole classique.';

  @override
  String get calibrateTip =>
      'Précision faible : faites des mouvements en forme de 8 avec le téléphone pour calibrer la boussole.';

  @override
  String get metalWarning =>
      'Tenez le téléphone à plat, loin des objets métalliques, des aimants et des appareils électriques.';

  @override
  String declinationNote(String deg) {
    return 'Déclinaison magnétique corrigée : $deg°';
  }

  @override
  String get compassNeedsLocation => 'Autorisez la localisation pour activer la boussole.';

  @override
  String get hadithSearchHint => 'Rechercher dans les hadiths…';

  @override
  String hadithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hadiths',
      one: '1 hadith',
    );
    return '$_temp0';
  }

  @override
  String chapterLabel(int n) {
    return 'Chapitre $n';
  }

  @override
  String get translationMissing => 'Traduction non disponible pour ce hadith dans cette langue.';

  @override
  String hadithNumber(String number) {
    return 'Hadith $number';
  }

  @override
  String get sahihCollection => 'Recueil authentique (sahih)';

  @override
  String get hadithOfTheDay => 'Hadith du jour';

  @override
  String get preparingHadiths => 'Préparation des hadiths (première ouverture)…';

  @override
  String get noResults => 'Aucun résultat.';

  @override
  String get search => 'Rechercher';

  @override
  String get tasbihTarget => 'Objectif';

  @override
  String get tasbihFree => 'Libre';

  @override
  String tasbihToday(int count) {
    return 'Aujourd\'hui : $count';
  }

  @override
  String get tasbihReset => 'Remettre à zéro';

  @override
  String get tasbihCompleted => 'Objectif atteint, qu\'Allah l\'accepte';

  @override
  String get tasbihTapHint => 'Touchez le cercle pour compter';

  @override
  String get phraseSubhanallah => 'Gloire à Allah';

  @override
  String get phraseAlhamdulillah => 'Louange à Allah';

  @override
  String get phraseAllahuakbar => 'Allah est le plus grand';

  @override
  String get phraseLailaha => 'Il n\'y a de divinité qu\'Allah';

  @override
  String get phraseAstaghfirullah => 'Je demande pardon à Allah';

  @override
  String get phraseSalawat => 'Ô Allah, prie sur Muhammad';
}
