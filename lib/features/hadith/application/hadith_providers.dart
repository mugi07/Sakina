import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/hadith_database.dart';
import '../../../core/text/search_normalizer.dart';

final hadithBooksProvider = FutureProvider<List<HadithBook>>(
  (ref) async => (await ref.watch(hadithDatabaseProvider.future)).allBooks().get(),
);

final hadithSectionsProvider = FutureProvider.family<List<HadithSection>, String>(
  (ref, book) async =>
      (await ref.watch(hadithDatabaseProvider.future)).sectionsOfBook(book: book).get(),
);

final sectionHadithsProvider = FutureProvider.family<List<Hadith>, ({String book, int section})>(
  (ref, arg) async =>
      (await ref.watch(hadithDatabaseProvider.future))
          .hadithsOfSection(book: arg.book, section: arg.section)
          .get(),
);

/// Hadith du jour : un hadith d'an-Nawawi ou qudsi, le même toute la journée.
final hadithOfTheDayProvider = FutureProvider.family<Hadith?, DateTime>((ref, day) async {
  final list = await (await ref.watch(hadithDatabaseProvider.future)).dailyCandidates().get();
  if (list.isEmpty) return null;
  final dayNumber = DateTime.utc(day.year, day.month, day.day).millisecondsSinceEpoch ~/ 86400000;
  return list[dayNumber % list.length];
});

final hadithSearchProvider = FutureProvider.family<List<Hadith>, String>((ref, query) async {
  final match = ftsQuery(query);
  if (match == null) return const [];
  final db = await ref.watch(hadithDatabaseProvider.future);
  return db.searchHadiths(query: match, limit: 100).get();
});

/// Expression FTS5 : chaque mot (normalisé comme l'index) doit apparaître,
/// en acceptant les mots qui commencent par lui (« pri » → « prière »).
/// Null si la requête ne contient aucun mot d'au moins 2 lettres.
String? ftsQuery(String input) {
  final words = normalizeForSearch(input).split(' ').where((w) => w.length >= 2).toList();
  if (words.isEmpty) return null;
  return words.map((w) => '"$w"*').join(' ');
}

/// Numéro affiché : « 35 » ou « 35.5 ».
String hadithNumberLabel(double number) =>
    number == number.roundToDouble() ? '${number.toInt()}' : '$number';
