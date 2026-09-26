// Construit les bases de contenu de l'app à partir des sources brutes :
//   assets/db/content.sqlite  Coran, traductions, villes
//   assets/db/hadith.sqlite   recueils de hadiths
//
// Usage (depuis la racine du projet) :
//   dart run tool/content_pipeline/build_content_db.dart [--update-lock]
//
// Les téléchargements sont mis en cache dans tool/content_pipeline/.cache
// (environ 280 Mo, ignoré par git). Les sommes SHA-256 des sources sont
// vérifiées contre tool/content_pipeline/sources.lock.json.

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import 'src/downloads.dart';
import 'src/geonames_source.dart';
import 'src/hadith_source.dart';
import 'src/quran_source.dart';

/// Doivent rester égaux à ContentDatabase.schemaVersion et
/// HadithDatabase.schemaVersion.
const contentSchemaVersion = 1;
const hadithSchemaVersion = 1;

Future<void> main(List<String> args) async {
  final root = Directory.current.path;
  final dbDir = p.join(root, 'lib', 'core', 'database');
  if (!File(p.join(dbDir, 'content_schema.drift')).existsSync()) {
    stderr.writeln('Lancez ce script depuis la racine du projet Flutter.');
    exit(64);
  }
  final pipelineDir = p.join(root, 'tool', 'content_pipeline');
  final cache = SourceCache(
    cacheDir: Directory(p.join(pipelineDir, '.cache')),
    lockFile: File(p.join(pipelineDir, 'sources.lock.json')),
  );
  final outDir = Directory(p.join(root, 'assets', 'db'))..createSync(recursive: true);
  final updateLock = args.contains('--update-lock');

  late String tanzilNotice;
  await _buildDatabase(
    schema: File(p.join(dbDir, 'content_schema.drift')),
    out: File(p.join(outDir.path, 'content.sqlite')),
    manifest: File(p.join(outDir.path, 'content_manifest.json')),
    metaTable: 'meta_entries',
    schemaVersion: contentSchemaVersion,
    fill: (db) async {
      stdout.writeln('Coran (Tanzil)…');
      final quran = await buildQuran(cache, db);
      stdout.writeln('Villes (GeoNames)…');
      final places = await buildCities(cache, db);
      cache.verifyLock(update: updateLock);
      tanzilNotice = quran.tanzilNotice;
      return (
        meta: {
          'quran_text_sha256': quran.textSha256,
          'tanzil_notice': quran.tanzilNotice,
          'sources': jsonEncode(_sources),
        },
        summary: '6236 versets · ${places.cities} villes · ${places.countries} pays',
      );
    },
  );

  await _buildDatabase(
    schema: File(p.join(dbDir, 'hadith_schema.drift')),
    out: File(p.join(outDir.path, 'hadith.sqlite')),
    manifest: File(p.join(outDir.path, 'hadith_manifest.json')),
    metaTable: 'hadith_meta',
    schemaVersion: hadithSchemaVersion,
    fill: (db) async {
      stdout.writeln('Hadiths (hadith-api)…');
      final counts = await buildHadiths(cache, db);
      cache.verifyLock(update: updateLock);
      return (
        meta: <String, String>{},
        summary: counts.entries.map((e) => '${e.key} ${e.value}').join(' · '),
      );
    },
  );

  _writeSourcesDoc(root, tanzilNotice);
}

typedef _Fill = Future<({Map<String, String> meta, String summary})> Function(Database db);

/// Construit une base dans un fichier temporaire (schéma, remplissage,
/// métadonnées, version), puis la met en place et écrit son manifeste.
Future<void> _buildDatabase({
  required File schema,
  required File out,
  required File manifest,
  required String metaTable,
  required int schemaVersion,
  required _Fill fill,
}) async {
  final tmp = File('${out.path}.tmp');
  if (tmp.existsSync()) tmp.deleteSync();
  final db = sqlite3.open(tmp.path);
  try {
    db.execute('PRAGMA journal_mode = OFF');
    db.execute(schema.readAsStringSync());
    db.execute('BEGIN');
    final result = await fill(db);

    final builtAt = DateTime.now().toUtc();
    final version = int.parse(
      builtAt.toIso8601String().replaceAll(RegExp(r'[^0-9]'), '').substring(0, 12),
    );
    final insertMeta = db.prepare('INSERT INTO $metaTable VALUES (?, ?)');
    for (final entry in {
      'content_version': '$version',
      'built_at': builtAt.toIso8601String(),
      ...result.meta,
    }.entries) {
      insertMeta.execute([entry.key, entry.value]);
    }
    insertMeta.close();

    db.execute('COMMIT');
    db.execute('PRAGMA user_version = $schemaVersion');
    db.execute('VACUUM');
    db.close();

    if (out.existsSync()) out.deleteSync();
    tmp.renameSync(out.path);

    final sha = (await sha256.bind(out.openRead()).first).toString();
    manifest.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert({'content_version': version, 'schema_version': schemaVersion, 'sha256': sha})}\n',
    );
    final sizeMb = (out.lengthSync() / (1024 * 1024)).toStringAsFixed(1);
    stdout.writeln('✓ ${p.basename(out.path)} : $sizeMb Mo · ${result.summary} · version $version\n');
  } catch (_) {
    try {
      db.close();
    } catch (_) {}
    if (tmp.existsSync()) tmp.deleteSync();
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
    'title': 'Hadiths (an-Nawawi, Qudsi, Bukhari, Muslim, Malik) en arabe, français, anglais',
    'author': 'hadith-api (Fawaz Ahmed)',
    'license': 'Domaine public (Unlicense)',
    'url': 'https://github.com/fawazahmed0/hadith-api',
  },
  {
    'title': 'Villes et pays',
    'author': 'GeoNames',
    'license': 'Creative Commons Attribution 4.0',
    'url': 'https://www.geonames.org',
  },
  {
    'title': 'Déclinaison magnétique (boussole Qibla)',
    'author': 'NOAA — World Magnetic Model 2025',
    'license': 'Domaine public',
    'url': 'https://www.ncei.noaa.gov/products/world-magnetic-model',
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
