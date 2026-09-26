import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../core/providers.dart';
import '../core/settings/app_locale.dart';
import '../core/settings/app_settings.dart';
import '../features/prayer_times/application/adhan_notifications.dart';
import '../features/prayer_times/application/prayer_providers.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class SakinaApp extends ConsumerStatefulWidget {
  const SakinaApp({super.key});

  @override
  ConsumerState<SakinaApp> createState() => _SakinaAppState();
}

class _SakinaAppState extends ConsumerState<SakinaApp> {
  late final GoRouter _router = buildRouter(ref);
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Chiffres occidentaux (0-9) partout, y compris en arabe (usage du
    // Maghreb), pour ne pas mélanger « ١٥ » et « 15 » sur un même écran.
    // Les numéros de versets gardent les chiffres arabes orientaux du mushaf.
    DateFormat.useNativeDigitsByDefaultFor('ar', false);
    // Les notifications ne couvrent que les prochains jours : on les
    // reprogramme au démarrage et à chaque retour dans l'app.
    _lifecycle = AppLifecycleListener(onResume: _rescheduleAdhan);
    WidgetsBinding.instance.addPostFrameCallback((_) => _rescheduleAdhan());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _router.dispose();
    super.dispose();
  }

  Future<void> _rescheduleAdhan() async {
    final settings = ref.read(settingsProvider);
    final locale = resolveAppLocale(
      settings.language,
      WidgetsBinding.instance.platformDispatcher.locale,
    );
    try {
      await ref
          .read(adhanNotificationsProvider)
          .reschedule(
            calculator: ref.read(prayerCalculatorProvider),
            settings: settings,
            l: lookupAppLocalizations(locale),
            locale: locale.toLanguageTag(),
          );
    } on Exception catch (e) {
      debugPrint('Programmation des notifications impossible : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(settingsProvider.select((s) => s.language));
    final themeMode = ref.watch(settingsProvider.select((s) => s.themeMode));
    ref.listen(adhanInputsProvider, (_, _) => _rescheduleAdhan());

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: themeMode,
      locale: language == AppLanguage.system ? null : Locale(language.name),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeResolutionCallback: (device, _) => resolveAppLocale(AppLanguage.system, device),
      routerConfig: _router,
    );
  }
}
