import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'asset_database.dart';

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

/// Copie la base des assets si nécessaire, puis l'ouvre en lecture seule.
Future<ContentDatabase> openContentDatabase(SharedPreferences prefs) async =>
    ContentDatabase(openReadOnly(await installAssetDatabase('content', prefs)));
