import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/database/content_database.dart';
import '../../../core/providers.dart';
import '../../../core/text/search_normalizer.dart';
import '../../../l10n/app_localizations.dart';
import '../application/bookmarks.dart';
import '../application/quran_providers.dart';
import '../domain/quran_text.dart';
import 'quran_index_screen.dart';

/// Traduction affichée avec les résultats : celle de la langue de l'app.
String _editionFor(BuildContext context) => switch (Localizations.localeOf(context).languageCode) {
  'fr' => 'fr.hamidullah',
  'en' => 'en.sahih',
  _ => '',
};

final _quranSearchProvider =
    FutureProvider.family<List<SearchAyahsResult>, ({String query, String edition})>((ref, arg) {
      final match = ftsQuery(arg.query);
      if (match == null) return const [];
      return ref
          .watch(contentDatabaseProvider)
          .searchAyahs(query: match, edition: arg.edition, limit: 300)
          .get();
    });

final _bookmarkedAyahsProvider = FutureProvider.family<List<AyahsByIdsResult>, String>((
  ref,
  edition,
) {
  final ids = ref.watch(bookmarksProvider);
  if (ids.isEmpty) return const [];
  return ref.watch(contentDatabaseProvider).ayahsByIds(ids: ids.toList(), edition: edition).get();
});

/// Un verset dans une liste (résultat ou signet) : arabe, traduction de la
/// langue de l'app, référence ; ouvre la page du mushaf.
class AyahListTile extends ConsumerWidget {
  const AyahListTile({required this.ayah, required this.translation, this.trailing, super.key});

  final Ayah ayah;
  final String? translation;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Localizations.localeOf(context).languageCode;
    final surah = ref.watch(surahByIdProvider).value?[ayah.surah];
    final scheme = Theme.of(context).colorScheme;
    final name = surah == null ? '' : (lang == 'ar' ? 'سورة ${surah.nameAr}' : surah.nameTranslit);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => openMushafPage(context, ayah.page),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$name ${ayah.surah}:${ayah.number}',
                      style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700),
                    ),
                  ),
                  ?trailing,
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: Text(
                  '${ayahDisplayText(surah: ayah.surah, number: ayah.number, text: ayah.textUthmani)}'
                  ' ${ayahEndMark(ayah.number)}',
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(fontFamily: quranFontFamily, fontSize: 20, height: 1.9),
                ),
              ),
              if (translation != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8, top: 4),
                  child: Text(
                    translation!,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(color: scheme.onSurfaceVariant, height: 1.5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Recherche hors-ligne dans le texte arabe (avec ou sans voyelles) et
/// dans les traductions française et anglaise.
class QuranSearchScreen extends ConsumerStatefulWidget {
  const QuranSearchScreen({super.key});

  @override
  ConsumerState<QuranSearchScreen> createState() => _QuranSearchScreenState();
}

class _QuranSearchScreenState extends ConsumerState<QuranSearchScreen> {
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final edition = _editionFor(context);
    final results = ftsQuery(_query) == null
        ? null
        : ref.watch(_quranSearchProvider((query: _query, edition: edition)));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(hintText: l.quranSearchHint, border: InputBorder.none),
          onChanged: (v) {
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 300), () {
              if (mounted) setState(() => _query = v);
            });
          },
        ),
      ),
      body: results == null
          ? const SizedBox.shrink()
          : results.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(child: Text(l.noResults)),
              data: (list) => ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: list.length + 1,
                itemBuilder: (context, i) => i == 0
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                        child: Text(l.searchResultsCount(list.length)),
                      )
                    : AyahListTile(ayah: list[i - 1].a, translation: list[i - 1].translation),
              ),
            ),
    );
  }
}

/// Onglet « Signets » de l'index du Coran.
class BookmarksList extends ConsumerWidget {
  const BookmarksList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final rows = ref.watch(_bookmarkedAyahsProvider(_editionFor(context))).value;
    if (rows == null) return const Center(child: CircularProgressIndicator());
    if (rows.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(l.noBookmarks, textAlign: TextAlign.center),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        for (final r in rows)
          AyahListTile(
            ayah: r.a,
            translation: r.translation,
            trailing: IconButton(
              tooltip: l.bookmarkRemove,
              icon: const Icon(Icons.bookmark_remove_outlined),
              onPressed: () => ref.read(bookmarksProvider.notifier).toggle(r.a.id),
            ),
          ),
      ],
    );
  }
}
