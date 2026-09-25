import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../core/providers.dart';
import '../core/settings/app_settings.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class SakinaApp extends ConsumerStatefulWidget {
  const SakinaApp({super.key});

  @override
  ConsumerState<SakinaApp> createState() => _SakinaAppState();
}

class _SakinaAppState extends ConsumerState<SakinaApp> {
  late final GoRouter _router = buildRouter();

  @override
  void initState() {
    super.initState();
    // Chiffres occidentaux (0-9) partout, y compris en arabe (usage du
    // Maghreb), pour ne pas mélanger « ١٥ » et « 15 » sur un même écran.
    // Les numéros de versets gardent les chiffres arabes orientaux du mushaf.
    DateFormat.useNativeDigitsByDefaultFor('ar', false);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(settingsProvider.select((s) => s.language));
    final themeMode = ref.watch(settingsProvider.select((s) => s.themeMode));

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: themeMode,
      locale: language == AppLanguage.system ? null : Locale(language.name),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      // Langue du téléphone si elle est gérée, sinon l'anglais.
      localeResolutionCallback: (device, supported) => supported.firstWhere(
        (l) => l.languageCode == device?.languageCode,
        orElse: () => const Locale('en'),
      ),
      routerConfig: _router,
    );
  }
}
