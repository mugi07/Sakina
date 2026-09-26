import 'dart:convert';
import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

import 'downloads.dart';

const _api = 'https://www.hisnmuslim.com/api';

final _bom = String.fromCharCode(0xFEFF);
final _controlChars = RegExp('[\x00-\x1F]');

/// Lit la liste contenue dans un fichier JSON de hisnmuslim.com, de la forme
/// `{ "<titre>": [ … ] }`. Certains fichiers ont des défauts (BOM, caractères
/// de contrôle, guillemet manquant dans le titre) : on retire les premiers
/// et on n'analyse que la liste, sans la clé.
List<Map<String, dynamic>> _readList(File file) {
  final text = file.readAsStringSync().replaceFirst(_bom, '').replaceAll(_controlChars, ' ');
  final list = text.substring(text.indexOf('['), text.lastIndexOf(']') + 1);
  return (jsonDecode(list) as List<dynamic>).cast<Map<String, dynamic>>();
}

/// Nettoyage de présentation uniquement : espaces superflus et doubles
/// parenthèses de citation du livre « (( … )) » autour du texte entier.
String _clean(String input) {
  var s = input.replaceAll(RegExp(r'\s+'), ' ').trim();
  final closing = RegExp(r'\)\)\.?$');
  if (s.startsWith('((') && closing.hasMatch(s)) {
    s = s.substring(2).replaceFirst(closing, '').trim();
  }
  return s;
}

String? _nonEmpty(String? s) {
  if (s == null) return null;
  final c = _clean(s);
  return c.isEmpty ? null : c;
}

/// Hisn al-Muslim : chapitres (ordre du site : essentiels d'abord) et
/// invocations, en arabe, translittération et anglais.
Future<({int categories, int items})> buildAdhkar(SourceCache cache, Database db) async {
  final arIndex = _readList(await cache.fetch('$_api/ar/husn_ar.json', 'hisn-index-ar.json'));
  final enTitles = {
    for (final c in _readList(await cache.fetch('$_api/en/husn_en.json', 'hisn-index-en.json')))
      c['ID'] as int: c['TITLE'] as String,
  };

  final insertCategory = db.prepare('INSERT INTO adhkar_categories VALUES (?, ?, ?, ?, ?, ?)');
  final insertItem = db.prepare('INSERT INTO adhkar VALUES (?, ?, ?, ?, ?, ?, ?, ?)');
  var items = 0;
  for (final (position, chapter) in arIndex.indexed) {
    final id = chapter['ID'] as int;
    final ar = _readList(await cache.fetch('$_api/ar/$id.json', 'hisn-ar-$id.json'));
    final en = {
      for (final e in _readList(await cache.fetch('$_api/en/$id.json', 'hisn-en-$id.json')))
        e['ID'] as int: e,
    };
    for (final (index, a) in ar.indexed) {
      final e = en[a['ID'] as int];
      insertItem.execute([
        a['ID'],
        id,
        index,
        _clean(a['ARABIC_TEXT'] as String),
        _nonEmpty(e?['LANGUAGE_ARABIC_TRANSLATED_TEXT'] as String?),
        _nonEmpty(e?['TRANSLATED_TEXT'] as String?),
        null,
        (a['REPEAT'] as num?)?.toInt() ?? 1,
      ]);
      items++;
    }
    insertCategory.execute([
      id,
      position,
      _clean(chapter['TITLE'] as String),
      _clean(enTitles[id] ?? ''),
      null,
      ar.length,
    ]);
  }
  insertCategory.close();
  insertItem.close();
  if (items < 250) throw StateError('Adhkar : seulement $items invocations lues');
  return (categories: arIndex.length, items: items);
}
