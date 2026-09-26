import 'dart:convert';
import 'dart:io';

import 'package:sakina/core/text/search_normalizer.dart';
import 'package:sqlite3/sqlite3.dart';

import 'downloads.dart';

const _base = 'https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions';

/// Recueils embarqués, dans l'ordre d'affichage. Noms en arabe, français,
/// anglais. (Abu Dawud, Nasa'i, Ibn Majah : prévus en V2, trop volumineux.)
const hadithBooks = [
  (id: 'nawawi', ar: 'الأربعون النووية', fr: 'Les 40 hadiths de an-Nawawi', en: 'Forty Hadith of an-Nawawi'),
  (id: 'qudsi', ar: 'الأحاديث القدسية', fr: '40 hadiths qudsi', en: 'Forty Hadith Qudsi'),
  (id: 'bukhari', ar: 'صحيح البخاري', fr: 'Sahih al-Bukhari', en: 'Sahih al-Bukhari'),
  (id: 'muslim', ar: 'صحيح مسلم', fr: 'Sahih Muslim', en: 'Sahih Muslim'),
  (id: 'malik', ar: 'موطأ الإمام مالك', fr: "Al-Muwatta de l'imam Malik", en: 'Muwatta Malik'),
];

typedef _Hadith = ({num number, int section, String text, String? grades});

class _Edition {
  _Edition(this.hadiths, this.sections);

  final Map<num, _Hadith> hadiths;
  final Map<int, String> sections;
}

Future<_Edition> _edition(SourceCache cache, String name) async {
  final file = await cache.fetch('$_base/$name.min.json', 'hadith-$name.json');
  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  final metadata = json['metadata'] as Map<String, dynamic>;
  final sections = {
    for (final MapEntry(:key, :value) in (metadata['sections'] as Map<String, dynamic>).entries)
      int.parse(key): value as String,
  };
  final hadiths = <num, _Hadith>{};
  for (final h in (json['hadiths'] as List<dynamic>).cast<Map<String, dynamic>>()) {
    final text = (h['text'] as String).trim();
    if (text.isEmpty) continue;
    final grades = (h['grades'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((g) => '${g['name']}: ${g['grade']}')
        .join('; ');
    final number = h['hadithnumber'] as num;
    hadiths[number] = (
      number: number,
      section: (h['reference'] as Map<String, dynamic>)['book'] as int,
      text: text,
      grades: grades.isEmpty ? null : grades,
    );
  }
  return _Edition(hadiths, sections);
}

/// Construit hadith.sqlite dans [db] (schéma déjà créé). Renvoie le nombre
/// de hadiths par recueil.
Future<Map<String, int>> buildHadiths(SourceCache cache, Database db) async {
  final insertBook = db.prepare('INSERT INTO hadith_books VALUES (?, ?, ?, ?, ?, ?)');
  final insertSection = db.prepare('INSERT INTO hadith_sections VALUES (?, ?, ?, ?)');
  final insertHadith = db.prepare('INSERT INTO hadiths VALUES (?, ?, ?, ?, ?, ?, ?, ?)');
  final insertSearch = db.prepare(
    'INSERT INTO hadith_search (rowid, ar, fr, en) VALUES (?, ?, ?, ?)',
  );
  final counts = <String, int>{};
  var id = 0;

  for (final (position, book) in hadithBooks.indexed) {
    stdout.writeln('  … ${book.id}');
    final ar = await _edition(cache, 'ara-${book.id}');
    final arPlain = await _edition(cache, 'ara-${book.id}1');
    final fr = await _edition(cache, 'fra-${book.id}');
    final en = await _edition(cache, 'eng-${book.id}');

    final numbers = {...ar.hadiths.keys, ...fr.hadiths.keys, ...en.hadiths.keys}.toList()..sort();
    final perSection = <int, int>{};
    for (final number in numbers) {
      final any = ar.hadiths[number] ?? fr.hadiths[number] ?? en.hadiths[number]!;
      id++;
      perSection[any.section] = (perSection[any.section] ?? 0) + 1;
      final grades = en.hadiths[number]?.grades ?? ar.hadiths[number]?.grades;
      insertHadith.execute([
        id,
        book.id,
        number,
        any.section,
        ar.hadiths[number]?.text,
        fr.hadiths[number]?.text,
        en.hadiths[number]?.text,
        grades,
      ]);
      insertSearch.execute([
        id,
        normalizeForSearch(arPlain.hadiths[number]?.text ?? ar.hadiths[number]?.text ?? ''),
        fr.hadiths[number]?.text ?? '',
        en.hadiths[number]?.text ?? '',
      ]);
    }

    for (final MapEntry(key: number, value: count) in perSection.entries) {
      insertSection.execute([book.id, number, en.sections[number] ?? '', count]);
    }
    insertBook.execute([book.id, position, book.ar, book.fr, book.en, numbers.length]);
    counts[book.id] = numbers.length;
  }

  insertBook.close();
  insertSection.close();
  insertHadith.close();
  insertSearch.close();
  return counts;
}
