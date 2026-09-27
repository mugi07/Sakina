import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/database/content_database.dart';
import 'core/providers.dart';
import 'core/settings/app_locale.dart';
import 'core/time/time_zones.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initTimeZones();
  _registerFontLicenses();

  final prefs = await SharedPreferences.getInstance();
  final contentDb = await openContentDatabase(prefs);

  // Récitation en arrière-plan (notification et écran de verrouillage).
  final locale = resolveAppLocale(
    SettingsController.load(prefs).language,
    WidgetsBinding.instance.platformDispatcher.locale,
  );
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.mugi07.sakinah.recitation',
    androidNotificationChannelName: lookupAppLocalizations(locale).recitationChannel,
    androidNotificationOngoing: true,
    // Même silhouette blanche que les notifications d'adhan.
    androidNotificationIcon: 'drawable/ic_stat_sakinah',
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        contentDatabaseProvider.overrideWithValue(contentDb),
      ],
      child: const SakinaApp(),
    ),
  );
}

/// Ajoute les licences OFL des polices à la page « Licences des logiciels ».
void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (package, file) in const [
      ('IBM Plex Sans Arabic', 'assets/licenses/OFL-IBMPlexSansArabic.txt'),
      ('Amiri Quran', 'assets/licenses/OFL-AmiriQuran.txt'),
    ]) {
      yield LicenseEntryWithLineBreaks([package], await rootBundle.loadString(file));
    }
  });
}
