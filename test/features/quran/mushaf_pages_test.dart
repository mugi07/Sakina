import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina/core/database/content_database.dart';
import 'package:sakina/features/home/presentation/widgets/daily_cards.dart';
import 'package:sakina/features/quran/domain/page_layout.dart';
import 'package:sakina/features/quran/presentation/widgets/mushaf_typography.dart';

void main() {
  late ContentDatabase db;

  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = ContentDatabase(
      NativeDatabase(
        File('assets/db/content.sqlite'),
        setup: (raw) => raw.execute('PRAGMA query_only = ON'),
      ),
    );
  });
  tearDownAll(() => db.close());

  Future<List<PageBlock>> blocksOf(int page) async =>
      buildPageBlocks(await db.ayahsOfPage(page: page, edition: '').get());

  group('découpage des pages', () {
    test('page 1 : en-tête d\'Al-Fatiha sans basmala séparée, puis 7 versets', () async {
      final blocks = await blocksOf(1);
      expect(blocks, hasLength(2));
      final header = blocks[0] as SurahHeaderBlock;
      expect((header.surah, header.showsBasmala), (1, false));
      expect((blocks[1] as AyahRunBlock).rows, hasLength(7));
    });

    test('page 2 : début d\'Al-Baqara avec basmala en en-tête', () async {
      final blocks = await blocksOf(2);
      final header = blocks[0] as SurahHeaderBlock;
      expect((header.surah, header.showsBasmala), (2, true));
      expect((blocks[1] as AyahRunBlock).rows.map((r) => r.a.number), [1, 2, 3, 4, 5]);
    });

    test('page 604 : trois sourates, chacune avec son en-tête', () async {
      final headers = (await blocksOf(604)).whereType<SurahHeaderBlock>().map((h) => h.surah);
      expect(headers, [112, 113, 114]);
    });

    test('chaque page a au moins un verset, les 6236 sont couverts une fois', () async {
      var total = 0;
      for (var page = 1; page <= mushafPageCount; page++) {
        final rows = await db.ayahsOfPage(page: page, edition: '').get();
        expect(rows, isNotEmpty, reason: 'page $page');
        total += rows.length;
      }
      expect(total, 6236);
    });

    test('la traduction suit la même page, dans une seule langue', () async {
      final fr = await db.ayahsOfPage(page: 1, edition: 'fr.hamidullah').get();
      final ar = await db.ayahsOfPage(page: 1, edition: '').get();
      expect(fr.map((r) => r.a.id), ar.map((r) => r.a.id));
      expect(fr.first.translation, startsWith("Au nom d'Allah"));
      expect(ar.every((r) => r.translation == null), isTrue);
    });
  });

  test('verset du jour : chaque référence existe, avec sa traduction', () async {
    for (final (surah, number) in dailyVerses) {
      final row = await db
          .ayahByReference(surah: surah, number: number, edition: 'fr.hamidullah')
          .getSingleOrNull();
      expect(row, isNotNull, reason: '$surah:$number');
      expect(row!.translation, isNotEmpty, reason: '$surah:$number');
    }
    expect(
      verseOfTheDayReference(DateTime(2026, 9, 26)),
      verseOfTheDayReference(DateTime(2026, 9, 26, 23)),
    );
    expect(
      verseOfTheDayReference(DateTime(2026, 9, 26)),
      isNot(verseOfTheDayReference(DateTime(2026, 9, 27))),
    );
  });

  group('index', () {
    test('sourates : page de début', () async {
      final pages = {for (final r in await db.surahStartPages().get()) r.surah: r.page};
      expect(pages, hasLength(114));
      expect((pages[1], pages[2], pages[18], pages[114]), (1, 2, 293, 604));
    });

    test('30 juz et 60 hizb', () async {
      final juz = await db.juzStarts().get();
      expect(juz, hasLength(30));
      expect((juz[1].surah, juz[1].number, juz[1].page), (2, 142, 22));

      final hizb = await db.hizbStarts().get();
      expect(hizb, hasLength(60));
      expect(hizb.map((h) => h.hizb), List.generate(60, (i) => i + 1));
      expect((hizb[1].surah, hizb[1].number, hizb[1].page), (2, 75, 11));
    });
  });

  testWidgets('la taille calculée fait tenir la page entière', (tester) async {
    // Vraie police coranique : la police de test par défaut dessine des carrés.
    await tester.runAsync(
      () => (FontLoader(
        'AmiriQuran',
      )..addFont(rootBundle.load('assets/fonts/AmiriQuran-Regular.ttf'))).load(),
    );
    final blocks = (await tester.runAsync(() => blocksOf(50)))!;
    const size = Size(360, 600);
    final font = fitFontSize('test-p50', blocks, size);
    expect(font, inInclusiveRange(14, 32));
    expect(measurePage(blocks, size.width, font), lessThanOrEqualTo(size.height));

    // Moins de place → police plus petite.
    final smaller = fitFontSize('test-p50', blocks, const Size(360, 400));
    expect(smaller, lessThan(font));
  });
}
