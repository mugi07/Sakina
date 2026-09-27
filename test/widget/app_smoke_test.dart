import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina/app/app.dart';
import 'package:sakina/core/database/content_database.dart';
import 'package:sakina/core/database/hadith_database.dart';
import 'package:sakina/core/providers.dart';
import 'package:sakina/core/settings/app_settings.dart';
import 'package:sakina/core/time/time_zones.dart';
import 'package:sakina/features/prayer_times/presentation/prayer_times_screen.dart';
import 'package:sakina/features/quran/presentation/widgets/mushaf_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lance l'app complète avec la vraie base de contenu.
Future<ContentDatabase> _pumpApp(WidgetTester tester, {String? settingsJson}) async {
  SharedPreferences.setMockInitialValues({'settings.v1': ?settingsJson});
  final prefs = await SharedPreferences.getInstance();
  final db = ContentDatabase(
    NativeDatabase(
      File('assets/db/content.sqlite'),
      setup: (raw) => raw.execute('PRAGMA query_only = ON'),
    ),
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        contentDatabaseProvider.overrideWithValue(db),
        hadithDatabaseProvider.overrideWith(
          (ref) => HadithDatabase(
            NativeDatabase(
              File('assets/db/hadith.sqlite'),
              setup: (raw) => raw.execute('PRAGMA query_only = ON'),
            ),
          ),
        ),
      ],
      child: const SakinaApp(),
    ),
  );
  await _settle(tester);
  return db;
}

/// L'horloge tique chaque seconde : pumpAndSettle ne se stabiliserait jamais.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _unmount(WidgetTester tester, ContentDatabase db) async {
  await tester.pumpWidget(const SizedBox());
  await tester.runAsync(db.close);
}

const _casablanca =
    '{"language":"fr","location":{"latitude":33.5883,"longitude":-7.6114,'
    '"timezone":"Africa/Casablanca","countryCode":"MA","name":"Casablanca",'
    '"nameAr":"الدار البيضاء","countryNameEn":"Morocco","countryNameFr":"Maroc",'
    '"countryNameAr":"المغرب"}}';

void main() {
  setUpAll(() {
    initTimeZones();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  testWidgets('premier lancement : bienvenue, puis accueil sans lieu', (tester) async {
    final db = await _pumpApp(tester, settingsJson: '{"language":"fr"}');
    expect(find.text('Choisissez votre langue'), findsOneWidget);
    expect(find.text('Accueil'), findsNothing);

    await tester.tap(find.text('Continuer'));
    await _settle(tester);
    expect(find.text('Votre ville'), findsOneWidget);
    await tester.tap(find.text('Plus tard'));
    await _settle(tester);
    expect(find.text('Notifications de prière'), findsOneWidget);
    await tester.tap(find.text('Commencer'));
    await _settle(tester);

    expect(find.text('Accueil'), findsOneWidget);
    expect(find.text('As-salamu alaykum'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Choisir un lieu'), findsOneWidget);
    await _unmount(tester, db);
  });

  testWidgets('avec Casablanca : horaires, méthode du Maroc et Qibla', (tester) async {
    final db = await _pumpApp(tester, settingsJson: _casablanca);
    expect(find.text('Prochaine prière'), findsOneWidget);
    // Grille d'icônes de l'accueil, Qibla comprise.
    for (final label in ['Qibla', 'Tasbih', 'Hadiths', 'Khatma', 'Calendrier hégirien']) {
      expect(find.text(label), findsOneWidget);
    }

    await tester.tap(find.text('Prière'));
    await _settle(tester);
    expect(find.text('Horaires de prière'), findsOneWidget);
    expect(find.text('Lever du soleil'), findsOneWidget);
    final list = find
        .descendant(of: find.byType(PrayerTimesScreen), matching: find.byType(Scrollable))
        .first;
    await tester.scrollUntilVisible(
      find.textContaining('Maroc (ministère des Habous)'),
      200,
      scrollable: list,
    );
    await tester.scrollUntilVisible(find.text('Direction de la Qibla'), 200, scrollable: list);
    expect(find.textContaining('° depuis le nord'), findsOneWidget);
    await _unmount(tester, db);
  });

  testWidgets('Coran : page 1 en arabe, puis la même page en français seul', (tester) async {
    final db = await _pumpApp(tester, settingsJson: '{"language":"fr","onboardingDone":true}');
    // Onglet « Coran » (le mot figure aussi dans la grille de l'accueil).
    await tester.tap(find.descendant(of: find.byType(NavigationBar), matching: find.text('Coran')));
    await _settle(tester);
    expect(find.text('Al-Faatiha'), findsOneWidget);
    expect(find.text('Juz'), findsOneWidget);

    await tester.tap(find.text('Al-Faatiha'));
    await _settle(tester);
    // Mushaf arabe : page 1, sans traduction.
    expect(find.byType(MushafPageBlock), findsWidgets);
    expect(find.text('Page 1'), findsOneWidget);
    expect(find.textContaining("Au nom d'Allah"), findsNothing);

    await tester.tap(find.text('Français'));
    await _settle(tester);
    // Même page, en français uniquement.
    expect(find.byType(MushafPageBlock), findsNothing);
    expect(find.textContaining("Au nom d'Allah"), findsOneWidget);
    expect(find.text('Page 1'), findsOneWidget);
    await _unmount(tester, db);
  });

  testWidgets('Adhkar : matin et soir, compteur de répétitions', (tester) async {
    final db = await _pumpApp(tester, settingsJson: '{"language":"en","onboardingDone":true}');
    await tester.tap(find.text('Adhkar').last);
    await _settle(tester);
    expect(find.text('Essentials'), findsOneWidget);
    await tester.tap(find.text('أذكار الصباح والمساء').first);
    await _settle(tester);
    expect(find.textContaining('Recite Ayat-Al-Kursiy'), findsOneWidget);
    expect(find.textContaining('0 / 1'), findsWidgets);
    await tester.tap(find.textContaining('Recite Ayat-Al-Kursiy'));
    await tester.pump();
    expect(find.text('Done'), findsOneWidget);
    await _unmount(tester, db);
  });

  testWidgets('en arabe, l\'interface passe de droite à gauche', (tester) async {
    final db = await _pumpApp(tester, settingsJson: '{"language":"ar","onboardingDone":true}');
    expect(find.text('الرئيسية'), findsOneWidget);
    final context = tester.element(find.text('الرئيسية'));
    expect(Directionality.of(context), TextDirection.rtl);
    await _unmount(tester, db);
  });

  test('les réglages survivent à un aller-retour JSON', () {
    const settings = AppSettings(
      language: AppLanguage.ar,
      hijriAdjustment: -1,
      lastReadPage: 293,
      quranLanguage: QuranLanguage.french,
    );
    final back = AppSettings.fromJson(settings.toJson());
    expect(
      (back.language, back.hijriAdjustment, back.lastReadPage, back.quranLanguage),
      (AppLanguage.ar, -1, 293, QuranLanguage.french),
    );
  });
}
