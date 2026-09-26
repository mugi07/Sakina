import 'dart:ui';

import '../../l10n/app_localizations.dart';
import 'app_settings.dart';

/// Langue effective de l'app : celle choisie dans les réglages, sinon celle
/// du téléphone si elle est gérée (arabe, français, anglais), sinon l'anglais.
Locale resolveAppLocale(AppLanguage language, Locale? device) {
  if (language != AppLanguage.system) return Locale(language.name);
  return AppLocalizations.supportedLocales.firstWhere(
    (l) => l.languageCode == device?.languageCode,
    orElse: () => const Locale('en'),
  );
}
