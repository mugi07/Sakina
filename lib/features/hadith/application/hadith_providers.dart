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

/// Numéro affiché : « 35 » ou « 35.5 ».
String hadithNumberLabel(double number) =>
    number == number.roundToDouble() ? '${number.toInt()}' : '$number';
