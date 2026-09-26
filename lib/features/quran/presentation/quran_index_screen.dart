import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/database/content_database.dart';
import '../../../core/widgets/coming_soon.dart';
import '../../../l10n/app_localizations.dart';
import '../application/quran_providers.dart';
import '../domain/quran_text.dart';

/// Ouvre le lecteur à une page du mushaf.
void openMushafPage(BuildContext context, int page) => context.push('/quran/page/$page');

/// Index du Coran : sourates, juz et hizb, chacun menant à sa page.
class QuranIndexScreen extends StatelessWidget {
  const QuranIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.quranTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l.tabSurahs),
              Tab(text: l.tabJuz),
              Tab(text: l.tabHizb),
            ],
          ),
        ),
        body: const TabBarView(children: [_SurahList(), _JuzList(), _HizbList()]),
      ),
    );
  }
}

class _SurahList extends ConsumerWidget {
  const _SurahList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahs = ref.watch(surahListProvider);
    final pages = ref.watch(surahStartPagesProvider).value;
    return surahs.when(
      data: (list) => ListView.separated(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: list.length,
        separatorBuilder: (_, _) => const Divider(height: 1, indent: 76),
        itemBuilder: (context, i) => SurahTile(surah: list[i], page: pages?[list[i].id]),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => LoadErrorView(onRetry: () => ref.invalidate(surahListProvider)),
    );
  }
}

class SurahTile extends StatelessWidget {
  const SurahTile({required this.surah, required this.page, super.key});

  final Surah surah;
  final int? page;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final scheme = Theme.of(context).colorScheme;
    final type = surah.revelationType == 'meccan' ? l.meccan : l.medinan;

    return ListTile(
      onTap: page == null ? null : () => openMushafPage(context, page!),
      leading: NumberBadge(number: surah.id),
      title: Text(
        isArabic ? 'سورة ${surah.nameAr}' : surah.nameTranslit,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        [type, l.ayahCount(surah.ayahCount), if (page != null) l.pageLabel(page!)].join(' · '),
      ),
      trailing: isArabic
          ? null
          : Text(
              surah.nameAr,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontFamily: quranFontFamily, fontSize: 22, color: scheme.primary),
            ),
    );
  }
}

class _JuzList extends ConsumerWidget {
  const _JuzList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return ref
        .watch(juzStartsProvider)
        .when(
          data: (list) => ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: list.length,
            separatorBuilder: (_, _) => const Divider(height: 1, indent: 76),
            itemBuilder: (context, i) {
              final j = list[i];
              return _SectionTile(
                number: j.juz,
                title: l.juzLabel(j.juz),
                surahName: j.nameTranslit,
                surahNameAr: j.nameAr,
                surah: j.surah,
                ayah: j.number,
                page: j.page,
                text: j.textUthmani,
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => LoadErrorView(onRetry: () => ref.invalidate(juzStartsProvider)),
        );
  }
}

class _HizbList extends ConsumerWidget {
  const _HizbList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return ref
        .watch(hizbStartsProvider)
        .when(
          data: (list) => ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: list.length,
            separatorBuilder: (_, _) => const Divider(height: 1, indent: 76),
            itemBuilder: (context, i) {
              final h = list[i];
              return _SectionTile(
                number: h.hizb,
                title: l.hizbLabel(h.hizb),
                surahName: h.nameTranslit,
                surahNameAr: h.nameAr,
                surah: h.surah,
                ayah: h.number,
                page: h.page,
                text: h.textUthmani,
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => LoadErrorView(onRetry: () => ref.invalidate(hizbStartsProvider)),
        );
  }
}

/// Début d'un juz ou d'un hizb : premiers mots du verset, référence, page.
class _SectionTile extends StatelessWidget {
  const _SectionTile({
    required this.number,
    required this.title,
    required this.surahName,
    required this.surahNameAr,
    required this.surah,
    required this.ayah,
    required this.page,
    required this.text,
  });

  final int number;
  final String title;
  final String surahName;
  final String surahNameAr;
  final int surah;
  final int ayah;
  final int page;
  final String text;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final scheme = Theme.of(context).colorScheme;
    final opening = ayahDisplayText(
      surah: surah,
      number: ayah,
      text: text,
    ).split(' ').take(4).join(' ');

    return ListTile(
      onTap: () => openMushafPage(context, page),
      leading: NumberBadge(number: number),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('${isArabic ? surahNameAr : surahName} $surah:$ayah · ${l.pageLabel(page)}'),
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 150),
        child: Text(
          opening,
          textDirection: TextDirection.rtl,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontFamily: quranFontFamily, fontSize: 18, color: scheme.primary),
        ),
      ),
    );
  }
}

/// Numéro dans un losange (deux carrés superposés, motif d'étoile à huit
/// branches).
class NumberBadge extends StatelessWidget {
  const NumberBadge({required this.number, super.key});

  final int number;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final border = Border.all(color: scheme.tertiary, width: 1.5);
    return SizedBox.square(
      dimension: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(width: 30, height: 30, decoration: BoxDecoration(border: border)),
          Transform.rotate(
            angle: 0.785398, // 45°
            child: Container(width: 30, height: 30, decoration: BoxDecoration(border: border)),
          ),
          Text('$number', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
