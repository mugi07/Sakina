import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'content_database.g.dart';

/// Base de contenu en lecture seule (Coran, traductions, villes…).
///
/// Elle est construite par tool/content_pipeline, livrée dans les assets et
/// copiée au premier lancement (ou quand une nouvelle version est livrée).
@DriftDatabase(include: {'content_queries.drift'})
class ContentDatabase extends _$ContentDatabase {
  ContentDatabase(super.executor);

  /// Doit rester égal à `schemaVersion` dans tool/content_pipeline.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (_) =>
        throw StateError('content.sqlite doit être livré pré-construit (tool/content_pipeline).'),
    onUpgrade: (_, from, to) => throw StateError(
      'content.sqlite en version de schéma $from, attendu $to : '
      'reconstruisez-le avec tool/content_pipeline.',
    ),
  );
}

const _installedVersionKey = 'content_db.installed_version';

/// Copie la base des assets si nécessaire, puis l'ouvre en lecture seule.
Future<ContentDatabase> openContentDatabase(SharedPreferences prefs) async {
  final manifest = jsonDecode(
    await rootBundle.loadString('assets/db/content_manifest.json'),
  ) as Map<String, dynamic>;
  final version = manifest['content_version'] as int;

  final dir = await getApplicationSupportDirectory();
  final file = File(p.join(dir.path, 'content.sqlite'));
  if (!file.existsSync() || prefs.getInt(_installedVersionKey) != version) {
    final data = await rootBundle.load('assets/db/content.sqlite');
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      flush: true,
    );
    await tmp.rename(file.path);
    await prefs.setInt(_installedVersionKey, version);
  }

  return ContentDatabase(
    NativeDatabase.createInBackground(file, setup: (db) => db.execute('PRAGMA query_only = ON')),
  );
}
