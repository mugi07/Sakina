import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/content_database.dart';
import '../../../core/providers.dart';

/// Basmala verbatim (verset 1:1 de Tanzil), pour l'en-tête des sourates.
final basmalaProvider = FutureProvider<String>(
  (ref) => ref.watch(contentDatabaseProvider).basmala().getSingle(),
);

final surahListProvider = FutureProvider<List<Surah>>(
  (ref) => ref.watch(contentDatabaseProvider).allSurahs().get(),
);

/// Versets d'une sourate, avec la traduction de l'édition demandée
/// (null : arabe seul).
final surahAyahsProvider =
    FutureProvider.family<List<AyahsOfSurahResult>, ({int surah, String? edition})>(
      (ref, arg) => ref
          .watch(contentDatabaseProvider)
          .ayahsOfSurah(surah: arg.surah, edition: arg.edition ?? '')
          .get(),
    );
