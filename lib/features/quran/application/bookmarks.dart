import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';

final bookmarksProvider = NotifierProvider<BookmarksController, Set<int>>(BookmarksController.new);

/// Versets marqués d'un signet (identifiants 1..6236), sauvegardés sur le
/// téléphone.
class BookmarksController extends Notifier<Set<int>> {
  static const _key = 'quran.bookmarks';

  @override
  Set<int> build() {
    final raw = ref.watch(sharedPreferencesProvider).getStringList(_key) ?? const [];
    return {for (final s in raw) ?int.tryParse(s)};
  }

  bool contains(int ayahId) => state.contains(ayahId);

  void toggle(int ayahId) {
    final next = {...state};
    if (!next.remove(ayahId)) next.add(ayahId);
    state = next;
    ref.read(sharedPreferencesProvider).setStringList(_key, [
      for (final id in next.toList()..sort()) '$id',
    ]);
  }
}
