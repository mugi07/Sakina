import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/content_database.dart';
import '../../../core/providers.dart';

/// Basmala verbatim (verset 1:1 de Tanzil), pour l'en-tête des sourates.
final basmalaProvider = FutureProvider<String>(
  (ref) => ref.watch(contentDatabaseProvider).basmala().getSingle(),
);

/// Traduction de la basmala dans une édition (« Au nom d'Allah… »).
final basmalaTranslationProvider = FutureProvider.family<String, String>(
  (ref, edition) =>
      ref.watch(contentDatabaseProvider).basmalaTranslation(edition: edition).getSingle(),
);

final surahListProvider = FutureProvider<List<Surah>>(
  (ref) => ref.watch(contentDatabaseProvider).allSurahs().get(),
);

/// Sourates indexées par numéro.
final surahByIdProvider = FutureProvider<Map<int, Surah>>((ref) async {
  final list = await ref.watch(surahListProvider.future);
  return {for (final s in list) s.id: s};
});

/// Page du mushaf où commence chaque sourate.
final surahStartPagesProvider = FutureProvider<Map<int, int>>((ref) async {
  final rows = await ref.watch(contentDatabaseProvider).surahStartPages().get();
  return {for (final r in rows) r.surah: r.page!};
});

/// Versets d'une page du mushaf, avec la traduction demandée (null : arabe seul).
final pageAyahsProvider =
    FutureProvider.family<List<AyahsOfPageResult>, ({int page, String? edition})>(
      (ref, arg) => ref
          .watch(contentDatabaseProvider)
          .ayahsOfPage(page: arg.page, edition: arg.edition ?? '')
          .get(),
    );

final juzStartsProvider = FutureProvider<List<JuzStartsResult>>(
  (ref) => ref.watch(contentDatabaseProvider).juzStarts().get(),
);

final hizbStartsProvider = FutureProvider<List<HizbStartsResult>>(
  (ref) => ref.watch(contentDatabaseProvider).hizbStarts().get(),
);

final ayahTranslationsProvider = FutureProvider.family<List<TranslationsOfAyahResult>, int>(
  (ref, ayahId) => ref.watch(contentDatabaseProvider).translationsOfAyah(ayahId: ayahId).get(),
);
