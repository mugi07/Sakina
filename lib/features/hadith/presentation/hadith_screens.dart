import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/hadith_database.dart';
import '../../../core/text/search_normalizer.dart';
import '../../../core/widgets/coming_soon.dart';
import '../../../l10n/app_localizations.dart';
import '../../quran/presentation/quran_index_screen.dart';
import '../application/hadith_providers.dart';
import 'widgets/hadith_card.dart';

/// Recueils dont tous les hadiths sont authentiques (sahih) par définition.
const _sahihBooks = {'bukhari', 'muslim'};

String bookName(HadithBook b, String languageCode) => switch (languageCode) {
  'ar' => b.nameAr,
  'fr' => b.nameFr,
  _ => b.nameEn,
};

/// Écran « Hadiths » : les recueils, avec accès à la recherche.
class HadithBooksScreen extends ConsumerWidget {
  const HadithBooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final scheme = Theme.of(context).colorScheme;
    final books = ref.watch(hadithBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.hadith),
        actions: [
          IconButton(
            tooltip: l.search,
            icon: const Icon(Icons.search),
            onPressed: () => context.go('/more/hadith/search'),
          ),
        ],
      ),
      body: books.when(
        loading: () => _Preparing(text: l.preparingHadiths),
        error: (_, _) => LoadErrorView(onRetry: () => ref.invalidate(hadithDatabaseProvider)),
        data: (list) => ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: list.length,
          separatorBuilder: (_, _) => const Divider(height: 1, indent: 76),
          itemBuilder: (context, i) {
            final b = list[i];
            return ListTile(
              leading: NumberBadge(number: i + 1),
              title: Text(bookName(b, lang), style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                [
                  l.hadithCount(b.hadithCount),
                  if (_sahihBooks.contains(b.id)) l.sahihCollection,
                ].join(' · '),
              ),
              trailing: lang == 'ar'
                  ? null
                  : Text(
                      b.nameAr,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: scheme.primary, fontSize: 16),
                    ),
              onTap: () => context.go('/more/hadith/${b.id}'),
            );
          },
        ),
      ),
    );
  }
}

/// Un recueil : ses chapitres, ou directement ses hadiths s'il n'en a qu'un
/// (les 40 hadiths d'an-Nawawi, les hadiths qudsi).
class HadithBookScreen extends ConsumerWidget {
  const HadithBookScreen({required this.bookId, super.key});

  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final book = ref.watch(hadithBooksProvider).value?.where((b) => b.id == bookId).firstOrNull;
    final sections = ref.watch(hadithSectionsProvider(bookId));

    return sections.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => Scaffold(
        appBar: AppBar(),
        body: LoadErrorView(onRetry: () => ref.invalidate(hadithSectionsProvider(bookId))),
      ),
      data: (list) {
        final title = book == null ? '' : bookName(book, lang);
        if (list.length == 1) {
          return HadithListScreen(bookId: bookId, section: list.single.number, title: title);
        }
        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: list.length,
            separatorBuilder: (_, _) => const Divider(height: 1, indent: 76),
            itemBuilder: (context, i) {
              final s = list[i];
              return ListTile(
                leading: NumberBadge(number: s.number),
                title: Text(s.nameEn.isEmpty ? l.chapterLabel(s.number) : s.nameEn),
                subtitle: Text('${l.chapterLabel(s.number)} · ${l.hadithCount(s.hadithCount)}'),
                onTap: () => context.go('/more/hadith/$bookId/${s.number}'),
              );
            },
          ),
        );
      },
    );
  }
}

/// Les hadiths d'un chapitre, dans la langue choisie.
class HadithListScreen extends ConsumerWidget {
  const HadithListScreen({required this.bookId, required this.section, this.title, super.key});

  final String bookId;
  final int section;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final key = (book: bookId, section: section);
    final hadiths = ref.watch(sectionHadithsProvider(key));
    final sectionName = ref
        .watch(hadithSectionsProvider(bookId))
        .value
        ?.where((s) => s.number == section)
        .firstOrNull
        ?.nameEn;

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? sectionName ?? l.chapterLabel(section)),
        bottom: const PreferredSize(preferredSize: Size.fromHeight(52), child: HadithLanguageBar()),
      ),
      body: hadiths.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => LoadErrorView(onRetry: () => ref.invalidate(sectionHadithsProvider(key))),
        data: (list) => ListView.builder(
          padding: const EdgeInsets.only(top: 6, bottom: 24),
          itemCount: list.length,
          itemBuilder: (context, i) => HadithCard(hadith: list[i]),
        ),
      ),
    );
  }
}

/// Recherche dans tous les recueils (arabe, français, anglais), hors-ligne.
class HadithSearchScreen extends ConsumerStatefulWidget {
  const HadithSearchScreen({super.key});

  @override
  ConsumerState<HadithSearchScreen> createState() => _HadithSearchScreenState();
}

class _HadithSearchScreenState extends ConsumerState<HadithSearchScreen> {
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
    final lang = Localizations.localeOf(context).languageCode;
    final books = {for (final b in ref.watch(hadithBooksProvider).value ?? <HadithBook>[]) b.id: b};
    final results = ftsQuery(_query) == null ? null : ref.watch(hadithSearchProvider(_query));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: l.hadithSearchHint, border: InputBorder.none),
          textInputAction: TextInputAction.search,
          onChanged: (v) {
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 350), () {
              if (mounted) setState(() => _query = v);
            });
          },
        ),
        bottom: const PreferredSize(preferredSize: Size.fromHeight(52), child: HadithLanguageBar()),
      ),
      body: results == null
          ? const SizedBox.shrink()
          : results.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(child: Text(l.noResults)),
              data: (list) => list.isEmpty
                  ? Center(child: Text(l.noResults))
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 6, bottom: 24),
                      itemCount: list.length,
                      itemBuilder: (context, i) => HadithCard(
                        hadith: list[i],
                        bookName: books[list[i].book] == null
                            ? null
                            : bookName(books[list[i].book]!, lang),
                      ),
                    ),
            ),
    );
  }
}

class _Preparing extends StatelessWidget {
  const _Preparing({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [const CircularProgressIndicator(), const SizedBox(height: 16), Text(text)],
    ),
  );
}
