import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sakina/app/theme/app_theme.dart';
import 'package:sakina/core/providers.dart';
import 'package:sakina/features/qibla/presentation/qibla_compass_screen.dart';
import 'package:sakina/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;

const _casablanca =
    '{"language":"fr","onboardingDone":true,"location":{"latitude":33.5883,'
    '"longitude":-7.6114,"timezone":"Africa/Casablanca","countryCode":"MA",'
    '"name":"Casablanca"}}';

/// Boussole Qibla à Casablanca (Qibla ≈ 93,7°), à l'instant [now], le
/// téléphone orienté vers [heading] (cap simulé du capteur).
Future<void> pumpCompass(WidgetTester tester, {required DateTime now, double? heading}) async {
  tester.binding.defaultBinaryMessenger.setMockStreamHandler(
    const EventChannel('hemanthraj/flutter_compass'),
    MockStreamHandler.inline(
      onListen: (_, sink) {
        if (heading != null) sink.success(<double>[heading, heading, 5]);
      },
    ),
  );
  // Écran de téléphone (412 × 915) : la liste sous la boussole est construite.
  tester.view
    ..physicalSize = const Size(1236, 2745)
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues({'settings.v1': _casablanca});
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        clockProvider.overrideWith((ref) => Stream.value(now)),
      ],
      child: MaterialApp(
        theme: buildTheme(Brightness.light),
        locale: const Locale('fr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const QiblaCompassScreen(),
      ),
    ),
  );
  // Les événements du capteur passent par un canal de plateforme asynchrone.
  for (var i = 0; i < 3; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  setUpAll(() async {
    tzdata.initializeTimeZones();
    await initializeDateFormatting('fr');
  });

  testWidgets('téléphone vers le nord : tourner de 94° à droite', (tester) async {
    await pumpCompass(tester, now: DateTime.utc(2026, 9, 27, 0), heading: 0);
    expect(find.text('93,7° depuis le nord'), findsOneWidget);
    expect(find.text('Tournez vers la droite : 94°'), findsOneWidget);
  });

  testWidgets('face à la Qibla, en plein jour : méthode du soleil et vérification', (tester) async {
    // 11 h à Casablanca : le soleil est au sud-est (azimut ≈ 127°).
    await pumpCompass(tester, now: DateTime.utc(2026, 9, 27, 10), heading: 93.7);
    expect(find.text('Vous êtes face à la Qibla'), findsOneWidget);
    expect(find.textContaining('Vérification : le soleil dessiné'), findsOneWidget);
    await tester.scrollUntilVisible(find.textContaining('Faites face au soleil'), 200);
    expect(
      find.textContaining(RegExp(r'Faites face au soleil, puis tournez de \d+° vers la gauche')),
      findsOneWidget,
    );
  });

  testWidgets('la nuit : l\'heure à laquelle le soleil sera de nouveau utilisable', (tester) async {
    await pumpCompass(tester, now: DateTime.utc(2026, 9, 27, 0), heading: 0);
    await tester.scrollUntilVisible(find.textContaining('Le soleil est couché'), 200);
    // Lever vers 07:22 à Casablanca, soleil à 1° quelques minutes après.
    expect(find.textContaining(RegExp(r'à partir de 07:[23]\d')), findsOneWidget);
    expect(find.textContaining('Le 28 mai 2027 à 10:17'), findsOneWidget);
  });
}
