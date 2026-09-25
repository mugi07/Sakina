import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:sakina/core/text/search_normalizer.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:xml/xml.dart';

import 'downloads.dart';

const _tanzilText =
    'https://tanzil.net/pub/download/index.php'
    '?marks=true&sajdah=true&rub=false&tatweel=true&outType=txt-2&agree=true';

const translationEditions = [
  (id: 'fr.hamidullah', language: 'fr', name: 'Hamidullah', translator: 'Muhammad Hamidullah'),
  (
    id: 'en.sahih',
    language: 'en',
    name: 'Saheeh International',
    translator: 'Saheeh International',
  ),
];

typedef _Verse = ({int surah, int ayah, String text});

class QuranBuildResult {
  QuranBuildResult({required this.tanzilNotice, required this.textSha256});

  final String tanzilNotice;
  final String textSha256;
}

/// Construit les tables surahs, ayahs, translation_editions, ayah_translations.
Future<QuranBuildResult> buildQuran(SourceCache cache, Database db) async {
  final uthmaniFile = await cache.fetch('$_tanzilText&quranType=uthmani', 'tanzil-uthmani.txt');
  final simpleFile = await cache.fetch(
    '$_tanzilText&quranType=simple-clean',
    'tanzil-simple-clean.txt',
  );
  final metadataFile = await cache.fetch(
    'https://tanzil.net/res/text/metadata/quran-data.xml',
    'tanzil-quran-data.xml',
  );

  final uthmani = _readTanzilText(uthmaniFile);
  final simple = _readTanzilText(simpleFile);
  final meta = XmlDocument.parse(metadataFile.readAsStringSync());

  _check(uthmani.verses.length == 6236, 'texte uthmani : ${uthmani.verses.length} versets');
  _check(simple.verses.length == 6236, 'texte simple : ${simple.verses.length} versets');

  // --- Sourates -------------------------------------------------------------
  final suras = meta.findAllElements('sura').toList();
  _check(suras.length == 114, '${suras.length} sourates');
  final insertSurah = db.prepare('INSERT INTO surahs VALUES (?, ?, ?, ?, ?, ?, ?, ?)');
  var total = 0;
  for (final s in suras) {
    final ayas = int.parse(s.getAttribute('ayas')!);
    insertSurah.execute([
      int.parse(s.getAttribute('index')!),
      s.getAttribute('name')!,
      s.getAttribute('tname')!,
      s.getAttribute('ename')!,
      s.getAttribute('type')!.toLowerCase(),
      int.parse(s.getAttribute('order')!),
      ayas,
      int.parse(s.getAttribute('start')!) + 1,
    ]);
    total += ayas;
  }
  insertSurah.close();
  _check(total == 6236, 'somme des versets par sourate : $total');

  // --- Découpages (juz, quarts de hizb, pages) et sajdas --------------------
  final juz = _markers(meta, 'juz', expected: 30);
  final quarters = _markers(meta, 'quarter', expected: 240);
  final pages = _markers(meta, 'page', expected: 604);
  final sajdas = {
    for (final e in meta.findAllElements('sajda'))
      (int.parse(e.getAttribute('sura')!), int.parse(e.getAttribute('aya')!)): e.getAttribute(
        'type',
      )!,
  };
  _check(sajdas.length == 15, '${sajdas.length} sajdas');

  // --- Versets --------------------------------------------------------------
  final insertAyah = db.prepare('INSERT INTO ayahs VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)');
  final hashInput = StringBuffer();
  for (var i = 0; i < uthmani.verses.length; i++) {
    final v = uthmani.verses[i];
    final s = simple.verses[i];
    _check(v.surah == s.surah && v.ayah == s.ayah, 'désalignement au verset ${i + 1}');
    final key = (v.surah, v.ayah);
    insertAyah.execute([
      i + 1,
      v.surah,
      v.ayah,
      v.text,
      normalizeForSearch(s.text),
      juz.indexFor(key),
      quarters.indexFor(key),
      pages.indexFor(key),
      sajdas[key],
    ]);
    hashInput.write('${v.surah}|${v.ayah}|${v.text}\n');
  }
  insertAyah.close();

  // --- Traductions ----------------------------------------------------------
  final insertEdition = db.prepare('INSERT INTO translation_editions VALUES (?, ?, ?, ?)');
  final insertTranslation = db.prepare('INSERT INTO ayah_translations VALUES (?, ?, ?)');
  for (final edition in translationEditions) {
    final file = await cache.fetch(
      'https://tanzil.net/trans/?transID=${edition.id}&type=txt-2',
      'tanzil-${edition.id}.txt',
    );
    final verses = _readTanzilText(file).verses;
    _check(verses.length == 6236, '${edition.id} : ${verses.length} versets');
    insertEdition.execute([edition.id, edition.language, edition.name, edition.translator]);
    for (var i = 0; i < verses.length; i++) {
      insertTranslation.execute([i + 1, edition.id, verses[i].text]);
    }
  }
  insertEdition.close();
  insertTranslation.close();

  return QuranBuildResult(
    tanzilNotice: uthmani.notice,
    textSha256: sha256.convert(utf8.encode(hashInput.toString())).toString(),
  );
}

({List<_Verse> verses, String notice}) _readTanzilText(File file) {
  final verses = <_Verse>[];
  final notice = StringBuffer();
  for (final line in file.readAsLinesSync()) {
    if (line.startsWith('#')) {
      notice.writeln(line.replaceFirst(RegExp(r'^#\s?'), ''));
    } else if (line.trim().isNotEmpty) {
      final parts = line.split('|');
      verses.add((
        surah: int.parse(parts[0]),
        ayah: int.parse(parts[1]),
        text: parts.sublist(2).join('|').trim(),
      ));
    }
  }
  return (verses: verses, notice: notice.toString().trim());
}

/// Débuts de section (juz, quart, page) triés, pour retrouver la section
/// qui contient un verset donné.
class _Markers {
  _Markers(this._starts);

  final List<(int, int)> _starts;

  int indexFor((int, int) key) {
    var index = 0;
    for (var i = 0; i < _starts.length; i++) {
      if (_compare(_starts[i], key) <= 0) {
        index = i + 1;
      } else {
        break;
      }
    }
    return index;
  }

  static int _compare((int, int) a, (int, int) b) => a.$1 != b.$1 ? a.$1 - b.$1 : a.$2 - b.$2;
}

_Markers _markers(XmlDocument meta, String tag, {required int expected}) {
  final elements = meta.findAllElements(tag).toList()
    ..sort((a, b) => int.parse(a.getAttribute('index')!) - int.parse(b.getAttribute('index')!));
  _check(elements.length == expected, '$tag : ${elements.length} au lieu de $expected');
  return _Markers([
    for (final e in elements)
      (int.parse(e.getAttribute('sura')!), int.parse(e.getAttribute('aya')!)),
  ]);
}

void _check(bool condition, String message) {
  if (!condition) throw StateError('Contrôle du Coran échoué : $message');
}
