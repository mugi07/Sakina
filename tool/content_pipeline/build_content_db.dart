// Construit assets/db/content.sqlite à partir des sources brutes.
//
// Usage (depuis la racine du projet) :
//   dart run tool/content_pipeline/build_content_db.dart [--update-lock]
//
// Les téléchargements sont mis en cache dans tool/content_pipeline/.cache
// (environ 215 Mo, ignoré par git). Les sommes SHA-256 des sources sont
// vérifiées contre tool/content_pipeline/sources.lock.json.

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import 'src/downloads.dart';
import 'src/geonames_source.dart';
import 'src/quran_source.dart';

/// Doit rester égal à ContentDatabase.schemaVersion.
const schemaVersion = 1;

Future<void> main(List<String> args) async {
  final root = Directory.current.path;
  final pipelineDir = p.join(root, 'tool', 'content_pipeline');
  final schemaFile = File(p.join(root, 'lib', 'core', 'database', 'content_schema.drift'));
  if (!schemaFile.existsSync()) {
    stderr.writeln('Lancez ce script depuis la racine du projet Flutter.');
    exit(64);
  }

  final cache = SourceCache(
    cacheDir: Directory(p.join(pipelineDir, '.cache')),
    lockFile: File(p.join(pipelineDir, 'sources.lock.json')),
  );

  final outDir = Directory(p.join(root, 'assets', 'db'))..createSync(recursive: true);
  final dbFile = File(p.join(outDir.path, 'content.sqlite'));
  final tmpFile = File('${dbFile.path}.tmp');
  if (tmpFile.existsSync()) tmpFile.deleteSync();

  final db = sqlite3.open(tmpFile.path);
  try {
    db.execute('PRAGMA journal_mode = OFF');
    db.execute(schemaFile.readAsStringSync());
    db.execute('BEGIN');

    stdout.writeln('Coran (Tanzil)…');
    final quran = await buildQuran(cache, db);

    stdout.writeln('Villes (GeoNames)…');
    final places = await buildCities(cache, db);

    cache.verifyLock(update: args.contains('--update-lock'));

    final builtAt = DateTime.now().toUtc();
    final contentVersion = int.parse(
      builtAt.toIso8601String().replaceAll(RegExp(r'[^0-9]'), '').substring(0, 12),
    );
    final insertMeta = db.prepare('INSERT INTO meta_entries VALUES (?, ?)');
    for (final entry in {
      'content_version': '$contentVersion',
      'built_at': builtAt.toIso8601String(),
      'quran_text_sha256': quran.textSha256,
      'tanzil_notice': quran.tanzilNotice,
      'sources': jsonEncode(_sources),
    }.entries) {
      insertMeta.execute([entry.key, entry.value]);
    }
    insertMeta.close();

    db.execute('COMMIT');
    db.execute('PRAGMA user_version = $schemaVersion');
    db.execute('VACUUM');
    db.close();

    if (dbFile.existsSync()) dbFile.deleteSync();
    tmpFile.renameSync(dbFile.path);

    final dbSha = (await sha256.bind(dbFile.openRead()).first).toString();
    File(p.join(outDir.path, 'content_manifest.json')).writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert({'content_version': contentVersion, 'schema_version': schemaVersion, 'sha256': dbSha})}\n',
    );
    _writeSourcesDoc(root, quran.tanzilNotice);

    final sizeMb = (dbFile.lengthSync() / (1024 * 1024)).toStringAsFixed(1);
    stdout.writeln(
      '\n✓ content.sqlite : $sizeMb Mo · 6236 versets · '
      '${places.cities} villes · ${places.countries} pays · version $contentVersion',
    );
  } catch (_) {
    try {
      db.close();
    } catch (_) {}
    if (tmpFile.existsSync()) tmpFile.deleteSync();
    rethrow;
  }
}

/// Sources affichées dans l'écran « Sources et licences » et dans SOURCES.md.
const _sources = [
  {
    'title': 'Texte du Coran (uthmani et simple)',
    'author': 'Tanzil Project',
    'license': 'Creative Commons Attribution 3.0 — texte reproduit sans modification',
    'url': 'https://tanzil.net',
  },
  {
    'title': 'Traduction française',
    'author': 'Muhammad Hamidullah (via Tanzil)',
    'license': 'Usage non commercial',
    'url': 'https://tanzil.net/trans/',
  },
  {
    'title': 'Traduction anglaise',
    'author': 'Saheeh International (via Tanzil)',
    'license': 'Usage non commercial',
    'url': 'https://tanzil.net/trans/',
  },
  {
    'title': 'Villes et pays',
    'author': 'GeoNames',
    'license': 'Creative Commons Attribution 4.0',
    'url': 'https://www.geonames.org',
  },
];

void _writeSourcesDoc(String root, String tanzilNotice) {
  final docs = Directory(p.join(root, 'docs'))..createSync(recursive: true);
  final b = StringBuffer()
    ..writeln('# Sources et licences du contenu')
    ..writeln()
    ..writeln(
      'Fichier généré par `tool/content_pipeline/build_content_db.dart`. Ne pas modifier à la main.',
    )
    ..writeln()
    ..writeln('| Contenu | Auteur / source | Licence | Lien |')
    ..writeln('|---|---|---|---|');
  for (final s in _sources) {
    b.writeln('| ${s['title']} | ${s['author']} | ${s['license']} | ${s['url']} |');
  }
  b
    ..writeln(
      '| Police IBM Plex Sans Arabic | IBM | SIL Open Font License 1.1 | https://github.com/IBM/plex |',
    )
    ..writeln(
      '| Police Amiri Quran | Khaled Hosny / Amiri Project | SIL Open Font License 1.1 | https://github.com/aliftype/amiri |',
    )
    ..writeln()
    ..writeln('## Avis de copyright Tanzil (à conserver)')
    ..writeln()
    ..writeln('```')
    ..writeln(tanzilNotice)
    ..writeln('```');
  File(p.join(docs.path, 'SOURCES.md')).writeAsStringSync(b.toString());
}
