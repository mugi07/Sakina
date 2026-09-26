import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/database/content_database.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/quran_providers.dart';
import '../../domain/page_layout.dart';
import 'page_frame.dart';

/// Une page du mushaf dans une seule langue de traduction (mêmes versets
/// que la page arabe), de gauche à droite.
class TranslationPage extends ConsumerWidget {
  const TranslationPage({
    required this.page,
    required this.edition,
    required this.onAyahTap,
    this.selectedAyahId,
    this.playingAyahId,
    super.key,
  });

  final int page;
  final String edition;
  final int? selectedAyahId;
  final int? playingAyahId;
  final ValueChanged<AyahsOfPageResult> onAyahTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final rows = ref.watch(pageAyahsProvider((page: page, edition: edition))).value;
    final surahs = ref.watch(surahByIdProvider).value;
    final basmala = ref.watch(basmalaTranslationProvider(edition)).value;
    if (rows == null || surahs == null || basmala == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final scheme = Theme.of(context).colorScheme;
    final first = rows.first.a;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: PageFrame(
        header: PageHeaderRow(
          start: l.surahTitle(surahs[first.surah]!.nameTranslit),
          end: '${l.juzLabel(first.juz)} · ${l.hizbLabel(hizbOfQuarter(first.hizbQuarter))}',
        ),
        footer: '${l.pageLabel(page)} / $mushafPageCount',
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            for (final block in buildPageBlocks(rows))
              switch (block) {
                SurahHeaderBlock() => _SurahHeader(
                  surah: surahs[block.surah]!,
                  basmala: block.showsBasmala ? basmala : null,
                ),
                AyahRunBlock() => Column(
                  children: [
                    for (final row in block.rows)
                      InkWell(
                        onTap: () => onAyahTap(row),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                          decoration: BoxDecoration(
                            color: row.a.id == selectedAyahId
                                ? scheme.primary.withValues(alpha: 0.12)
                                : (row.a.id == playingAyahId
                                      ? scheme.tertiary.withValues(alpha: 0.18)
                                      : null),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${row.a.number}. ',
                                  style: TextStyle(
                                    color: scheme.tertiary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(text: row.translation ?? ''),
                              ],
                            ),
                            style: const TextStyle(fontSize: 16, height: 1.55),
                          ),
                        ),
                      ),
                  ],
                ),
              },
          ],
        ),
      ),
    );
  }
}

class _SurahHeader extends StatelessWidget {
  const _SurahHeader({required this.surah, required this.basmala});

  final Surah surah;
  final String? basmala;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        border: Border.all(color: scheme.tertiary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            surah.nameAr,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: quranFontFamily, fontSize: 24, color: scheme.primary),
          ),
          Text(
            '${surah.nameTranslit} — ${surah.nameEn}',
            style: const TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          if (basmala != null) ...[
            const SizedBox(height: 6),
            Text(
              basmala!,
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
