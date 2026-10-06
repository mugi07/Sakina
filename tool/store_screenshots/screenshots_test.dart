// Captures d'écran pour l'App Store, rendues avec le vrai code de l'app.
//
//   flutter test --update-goldens tool/store_screenshots/screenshots_test.dart
//
// Produit tool/store_screenshots/out/<appareil>/<langue>/NN_<écran>.png aux
// tailles demandées par App Store Connect (iPhone 6,9" et iPad 13").
// Outil lancé avec flutter test, hors du dossier test/ : l'analyseur ne le
// reconnaît pas comme un test.
// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sakina/app/app.dart';
import 'package:sakina/core/database/content_database.dart';
import 'package:sakina/core/database/hadith_database.dart';
import 'package:sakina/core/providers.dart';
import 'package:sakina/core/time/time_zones.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _devices = {
  'iphone_6.9': (size: Size(1320, 2868), ratio: 3.0),
  'ipad_13': (size: Size(2064, 2752), ratio: 2.0),
};

/// Écrans, dans l'ordre de la fiche App Store.
const _screens = [
  ('01_accueil', '/home'),
  ('02_coran', '/quran/page/1'),
  ('03_horaires', '/prayer'),
  ('04_qibla', '/qibla'),
  ('05_adhkar', '/adhkar/27'),
  ('06_hadiths', '/more/hadith/nawawi/1'),
  ('07_sadaqa_jariya', '/more/dedication'),
];

/// Casablanca, mardi 6 octobre 2026 à 10:15 (GMT) : ciel de jour, Dhuhr à venir.
final _now = DateTime.utc(2026, 10, 6, 10, 15);

String _settings(String lang) =>
    '{"language":"$lang","onboardingDone":true,"adhanEnabled":true,'
    '"location":{"latitude":33.5883,"longitude":-7.6114,"timezone":"Africa/Casablanca",'
    '"countryCode":"MA","name":"Casablanca","nameAr":"الدار البيضاء",'
    '"countryNameEn":"Morocco","countryNameFr":"Maroc","countryNameAr":"المغرب"}}';

Future<void> _font(String family, List<String> files) async {
  final loader = FontLoader(family);
  for (final f in files) {
    loader.addFont(Future.value(ByteData.sublistView(File(f).readAsBytesSync())));
  }
  await loader.load();
}

Future<void> _settle(WidgetTester tester, [int rounds = 8]) async {
  for (var i = 0; i < rounds; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 40)));
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  setUpAll(() async {
    initTimeZones();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    const fonts = 'C:/flutter/bin/cache/artifacts/material_fonts';
    await _font('IBMPlexSansArabic', [
      for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold']) 'assets/fonts/IBMPlexSansArabic-$w.ttf',
    ]);
    await _font('AmiriQuran', ['assets/fonts/AmiriQuran-Regular.ttf']);
    await _font('MaterialIcons', ['$fonts/materialicons-regular.otf']);
    await _font('Roboto', ['$fonts/roboto-regular.ttf', '$fonts/roboto-bold.ttf']);
  });

  for (final MapEntry(key: device, value: spec) in _devices.entries) {
    for (final lang in ['ar', 'fr', 'en']) {
      testWidgets('$device $lang', (tester) async {
        tester.view
          ..physicalSize = spec.size
          ..devicePixelRatio = spec.ratio;
        addTearDown(tester.view.reset);
        // Boussole : téléphone tourné vers la Qibla (écran vert).
        tester.binding.defaultBinaryMessenger.setMockStreamHandler(
          const EventChannel('hemanthraj/flutter_compass'),
          MockStreamHandler.inline(onListen: (_, sink) => sink.success(<double>[93.7, 93.7, 5])),
        );
        SharedPreferences.setMockInitialValues({'settings.v1': _settings(lang)});
        final prefs = await SharedPreferences.getInstance();
        NativeDatabase open(String file) =>
            NativeDatabase(File(file), setup: (raw) => raw.execute('PRAGMA query_only = ON'));
        final content = ContentDatabase(open('assets/db/content.sqlite'));
        final hadith = HadithDatabase(open('assets/db/hadith.sqlite'));
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(prefs),
              contentDatabaseProvider.overrideWithValue(content),
              hadithDatabaseProvider.overrideWith((ref) => hadith),
              clockProvider.overrideWith((ref) => Stream.value(_now)),
            ],
            child: const SakinaApp(),
          ),
        );
        await _settle(tester);

        for (var (name, location) in _screens) {
          // Adhkar : pas encore de traduction française ; le tasbih à la place.
          if (lang == 'fr' && location == '/adhkar/27') {
            (name, location) = ('05_tasbih', '/adhkar/tasbih');
          }
          final router = GoRouter.of(tester.element(find.byType(Scaffold).first));
          if (location == '/qibla') {
            unawaited(router.push<void>(location));
          } else {
            router.go(location);
          }
          await _settle(tester, 14);
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('out/$device/$lang/$name.png'),
          );
          if (location == '/qibla') {
            router.pop();
            await _settle(tester);
          }
        }

        await tester.pumpWidget(const SizedBox());
        await tester.runAsync(() async {
          await content.close();
          await hadith.close();
        });
      });
    }
  }
}
