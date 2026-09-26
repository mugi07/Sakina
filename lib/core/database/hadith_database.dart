import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'asset_database.dart';

part 'hadith_database.g.dart';

/// Recueils de hadiths (lecture seule), construits par tool/content_pipeline.
@DriftDatabase(include: {'hadith_queries.drift'})
class HadithDatabase extends _$HadithDatabase {
  HadithDatabase(super.executor);

  /// Doit rester égal à `hadithSchemaVersion` dans tool/content_pipeline.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (_) =>
        throw StateError('hadith.sqlite doit être livré pré-construit (tool/content_pipeline).'),
    onUpgrade: (_, from, to) => throw StateError(
      'hadith.sqlite en version de schéma $from, attendu $to : '
      'reconstruisez-le avec tool/content_pipeline.',
    ),
  );
}

/// Base des hadiths (environ 47 Mo), copiée depuis les assets en arrière-plan
/// à la première utilisation (hadith du jour ou section Hadiths), pas au
/// démarrage de l'app.
final hadithDatabaseProvider = FutureProvider<HadithDatabase>((ref) async {
  final file = await installAssetDatabase('hadith', ref.watch(sharedPreferencesProvider));
  final db = HadithDatabase(openReadOnly(file));
  ref.onDispose(db.close);
  return db;
});
