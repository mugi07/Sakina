import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina/core/text/search_normalizer.dart';
import 'package:sakina/features/quran/domain/quran_text.dart';
import 'package:sqlite3/sqlite3.dart';

/// Vérifie l'intégrité de assets/db/content.sqlite tel que livré dans l'app.
void main() {
  late Database db;

  setUpAll(() => db = sqlite3.open('assets/db/content.sqlite', mode: OpenMode.readOnly));
  tearDownAll(() => db.close());

  int count(String sql) => db.select(sql).first.values.first! as int;
  String meta(String key) =>
      db.select('SELECT value FROM meta_entries WHERE "key" = ?', [key]).first['value'] as String;

  test('version de schéma et manifeste cohérents', () {
    expect(db.userVersion, 1);
    final manifest = jsonDecode(
      File('assets/db/content_manifest.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    expect('${manifest['content_version']}', meta('content_version'));
  });

  test('114 sourates et 6236 versets, numérotés sans trou', () {
    expect(count('SELECT count(*) FROM surahs'), 114);
    expect(count('SELECT count(*) FROM ayahs'), 6236);
    expect(count('SELECT sum(ayah_count) FROM surahs'), 6236);
    final mismatches = db.select('''
      SELECT s.id FROM surahs s
      WHERE s.ayah_count != (SELECT count(*) FROM ayahs a WHERE a.surah = s.id)
         OR s.ayah_count != (SELECT max(number) FROM ayahs a WHERE a.surah = s.id)
         OR s.first_ayah_id != (SELECT min(id) FROM ayahs a WHERE a.surah = s.id)
    ''');
    expect(mismatches, isEmpty);
  });

  test('le texte du Coran est identique à la source Tanzil (SHA-256)', () {
    final buffer = StringBuffer();
    for (final row in db.select('SELECT surah, number, text_uthmani FROM ayahs ORDER BY id')) {
      buffer.write('${row['surah']}|${row['number']}|${row['text_uthmani']}\n');
    }
    expect(sha256.convert(utf8.encode(buffer.toString())).toString(), meta('quran_text_sha256'));
  });

  test('découpages du mushaf de Médine', () {
    expect(count('SELECT max(juz) FROM ayahs'), 30);
    expect(count('SELECT max(hizb_quarter) FROM ayahs'), 240);
    expect(count('SELECT count(DISTINCT page) FROM ayahs'), 604);
    expect(count('SELECT count(*) FROM ayahs WHERE sajda IS NOT NULL'), 15);
    // Ayat al-Kursi (2:255) : juz 3, page 42.
    final kursi = db.select('SELECT juz, page FROM ayahs WHERE surah = 2 AND number = 255').first;
    expect((kursi['juz'], kursi['page']), (3, 42));
  });

  test('basmala : présente au verset 1 de chaque sourate, retirée une seule fois', () {
    // L'en-tête affiche le verset 1:1 tel quel (requête `basmala`).
    final fatiha1 = db.select('SELECT text_uthmani FROM ayahs WHERE id = 1').first['text_uthmani'];
    final basmala = normalizeArabic(fatiha1 as String);
    expect(basmala, 'بسم الله الرحمن الرحيم');

    final firstAyahs = db.select('SELECT surah, number, text_uthmani FROM ayahs WHERE number = 1');
    for (final row in firstAyahs) {
      final surah = row['surah'] as int;
      final text = row['text_uthmani'] as String;
      if (!showsBasmalaHeader(surah)) continue;
      // Le verset 1 de chaque sourate (hors 1 et 9) commence par la basmala…
      final prefix = normalizeArabic(text.split(' ').take(4).join(' '));
      expect(prefix, basmala, reason: 'sourate $surah');
      // …et le texte affiché ne la contient plus.
      final shown = ayahDisplayText(surah: surah, number: 1, text: text);
      expect(shown.length, lessThan(text.length), reason: 'sourate $surah');
      expect(normalizeArabic(shown).startsWith(basmala), isFalse, reason: 'sourate $surah');
    }
  });

  test('deux traductions complètes', () {
    final rows = db.select('SELECT edition, count(*) AS n FROM ayah_translations GROUP BY edition');
    expect({for (final r in rows) r['edition']: r['n']}, {'fr.hamidullah': 6236, 'en.sahih': 6236});
  });

  test('villes : fuseau horaire, pays connu, clé de recherche', () {
    expect(count('SELECT count(*) FROM cities'), greaterThan(30000));
    expect(count("SELECT count(*) FROM cities WHERE timezone = '' OR search_key = ''"), 0);
    expect(
      count(
        'SELECT count(*) FROM cities c LEFT JOIN countries co ON co.code = c.country_code '
        'WHERE co.code IS NULL',
      ),
      0,
    );
    final mecca = db.select('SELECT name_fr, name_ar FROM cities WHERE id = 104515').first;
    expect((mecca['name_fr'], mecca['name_ar']), ('La Mecque', 'مكة المكرمة'));
  });

  test('sources et avis Tanzil présents', () {
    expect(meta('tanzil_notice'), contains('Tanzil'));
    expect(jsonDecode(meta('sources')), isNotEmpty);
  });
}
