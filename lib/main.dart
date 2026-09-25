import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;

import 'app/app.dart';
import 'core/database/content_database.dart';
import 'core/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tzdata.initializeTimeZones();
  _registerFontLicenses();

  final prefs = await SharedPreferences.getInstance();
  final contentDb = await openContentDatabase(prefs);

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
