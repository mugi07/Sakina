import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../core/providers.dart';
import '../core/settings/app_locale.dart';
import '../core/settings/app_settings.dart';
import '../features/khatma/application/khatma_controller.dart';
import '../features/prayer_times/application/adhan_notifications.dart';
import '../features/prayer_times/application/prayer_providers.dart';
import '../features/widgets/prayer_widget.dart';
import '../l10n/app_localizations.dart';
import 'app_shortcuts.dart';
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
  late final _shortcuts = AppShortcuts(onQibla: _openQibla);

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

  /// Raccourci « Trouver la Qibla » de l'icône de l'app (sauf pendant la
  /// bienvenue, qui doit d'abord choisir le lieu).
  void _openQibla() {
    if (ref.read(settingsProvider).location == null) return;
    if (_router.state.matchedLocation != '/qibla') _router.push('/qibla');
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
    await _shortcuts.update(lookupAppLocalizations(locale));
    try {
      // Fuseau des rappels « à heure fixe » (khatma) : celui du lieu choisi,
      // sinon celui du téléphone.
      final zoneName =
          settings.location?.timezone ?? (await FlutterTimezone.getLocalTimezone()).identifier;
      await ref
          .read(adhanNotificationsProvider)
          .reschedule(
            calculator: ref.read(prayerCalculatorProvider),
            settings: settings,
            l: lookupAppLocalizations(locale),
            locale: locale.toLanguageTag(),
            khatma: ref.read(khatmaProvider),
            localZone: tz.getLocation(zoneName),
          );
    } on Exception catch (e) {
      debugPrint('Programmation des notifications impossible : $e');
    }
    try {
      await syncPrayerWidget(
        buildPrayerWidgetData(
          calculator: ref.read(prayerCalculatorProvider),
          location: settings.location,
          l: lookupAppLocalizations(locale),
          locale: locale.toLanguageTag(),
          hijriAdjustment: settings.hijriAdjustment,
          now: DateTime.now(),
        ),
      );
    } on Exception catch (e) {
      debugPrint('Mise à jour du widget impossible : $e');
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
