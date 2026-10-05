import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina/core/database/hadith_database.dart';
import 'package:sakina/core/text/search_normalizer.dart';

void main() {
  late HadithDatabase db;

  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = HadithDatabase(
      NativeDatabase(
        File('assets/db/hadith.sqlite'),
        setup: (raw) => raw.execute('PRAGMA query_only = ON'),
      ),
    );
  });
  tearDownAll(() => db.close());

  test('cinq recueils, dans l\'ordre', () async {
    final books = await db.allBooks().get();
    expect(books.map((b) => b.id), ['nawawi', 'qudsi', 'bukhari', 'muslim', 'malik']);
    final counts = {for (final b in books) b.id: b.hadithCount};
    expect(counts['nawawi'], 42);
    expect(counts['qudsi'], 40);
    expect(counts['bukhari'], greaterThan(7000));
    expect(counts['muslim'], greaterThan(7000));
  });

  test('chaque hadith a au moins un texte, et le compte des chapitres est juste', () async {
    for (final book in await db.allBooks().get()) {
      var total = 0;
      for (final s in await db.sectionsOfBook(book: book.id).get()) {
        final hadiths = await db.hadithsOfSection(book: book.id, section: s.number).get();
        expect(hadiths, hasLength(s.hadithCount), reason: '${book.id} ${s.number}');
        expect(
          hadiths.every((h) => (h.textAr ?? h.textFr ?? h.textEn) != null),
          isTrue,
          reason: '${book.id} ${s.number}',
        );
        total += hadiths.length;
      }
      expect(total, book.hadithCount, reason: book.id);
    }
  });

  test('an-Nawawi n°1 en trois langues', () async {
    final first = (await db.hadithsOfSection(book: 'nawawi', section: 1).get()).first;
    expect(first.number, 1);
    expect(first.textFr, contains('intention'));
    expect(first.textEn, contains('intended'));
    expect(first.textAr, contains('بِالنِّيَّاتِ'));
  });

  group('recherche', () {
    Future<List<Hadith>> search(String q) =>
        db.searchHadiths(query: ftsQuery(q)!, limit: 100).get();

    test('en français, sans tenir compte des accents ni des majuscules', () async {
      final results = await search('Intentions');
      expect(results.any((h) => h.book == 'nawawi' && h.number == 1), isTrue);
      expect(await search('priere'), isNotEmpty);
    });

    test('en arabe, avec ou sans voyelles', () async {
      final withVowels = await search('بِالنِّيَّاتِ');
      final plain = await search('بالنيات');
      expect(plain.any((h) => h.book == 'nawawi' && h.number == 1), isTrue);
      expect(withVowels.map((h) => h.id), plain.map((h) => h.id));
    });

    test('en anglais, par début de mot', () async {
      expect((await search('intent')).any((h) => h.book == 'nawawi'), isTrue);
    });

    test('requête vide ou trop courte : pas de recherche', () {
      expect(ftsQuery(''), isNull);
      expect(ftsQuery('a'), isNull);
      expect(ftsQuery('  %  '), isNull);
    });
  });

  test('textes propres : ni HTML, ni titre de chapitre ou script collé', () async {
    final junk = RegExp(
      r'<[a-zA-Z/][^>]*>|&[a-z]+;|MOUATTA|Chapitre (?:[IVXLC]+|premier)\b|navigator\.',
    );
    final rows = await db.customSelect('SELECT id, text_ar, text_fr, text_en FROM hadiths').get();
    final dirty = [
      for (final r in rows)
        for (final col in ['text_ar', 'text_fr', 'text_en'])
          if (junk.hasMatch(r.readNullable<String>(col) ?? '')) '${r.read<int>('id')}:$col',
    ];
    expect(dirty, isEmpty);
  });

  test('chaque hadith est rangé dans un chapitre nommé', () async {
    final unnamed = await db
        .customSelect(
          "SELECT book, number FROM hadith_sections WHERE trim(name_en) = '' "
          "OR (number = 0 AND book != 'muslim')",
        )
        .get();
    expect(unnamed, isEmpty);
  });
}
