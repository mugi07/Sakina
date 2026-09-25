import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/database/content_database.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/coming_soon.dart';
import '../../../l10n/app_localizations.dart';
import '../application/quran_providers.dart';
import '../domain/quran_text.dart';

/// Lecture d'une sourate : texte uthmani et traduction optionnelle.
class SurahReaderScreen extends ConsumerStatefulWidget {
  const SurahReaderScreen({required this.surahId, super.key});

  final int surahId;

  @override
  ConsumerState<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends ConsumerState<SurahReaderScreen> {
  @override
  void initState() {
    super.initState();
    // Mémorise la sourate pour « Continuer la lecture » sur l'accueil.
    Future.microtask(
      () => ref
          .read(settingsProvider.notifier)
          .update((s) => s.copyWith(lastReadSurah: widget.surahId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final settings = ref.watch(settingsProvider);
    final edition = settings.quranTranslation.editionFor(lang);
    final surahs = ref.watch(surahListProvider).value;
    final surah = surahs?.firstWhere((s) => s.id == widget.surahId);
    final ayahs = ref.watch(surahAyahsProvider((surah: widget.surahId, edition: edition)));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          surah == null ? '' : (lang == 'ar' ? 'سورة ${surah.nameAr}' : surah.nameTranslit),
        ),
      ),
      body: ayahs.when(
        data: (rows) => ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          itemCount: rows.length + 1,
          itemBuilder: (context, i) => i == 0
              ? _SurahHeader(surah: surah, surahId: widget.surahId)
              : _AyahItem(row: rows[i - 1], fontScale: settings.arabicFontScale),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => LoadErrorView(
          onRetry: () =>
              ref.invalidate(surahAyahsProvider((surah: widget.surahId, edition: edition))),
        ),
      ),
      bottomNavigationBar: surah == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '${l.ayahCount(surah.ayahCount)} · ${surah.revelationType == 'meccan' ? l.meccan : l.medinan}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
    );
  }
}

class _SurahHeader extends ConsumerWidget {
  const _SurahHeader({required this.surah, required this.surahId});

  final Surah? surah;
  final int surahId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final basmala = ref.watch(basmalaProvider).value;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.tertiary.withValues(alpha: 0.6)),
        color: scheme.primary.withValues(alpha: 0.06),
      ),
      child: Column(
        children: [
          if (surah != null)
            Text(
              'سُورَةُ ${surah!.nameAr}',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontFamily: quranFontFamily, fontSize: 30, color: scheme.primary),
            ),
          if (showsBasmalaHeader(surahId) && basmala != null) ...[
            const SizedBox(height: 12),
            Text(
              basmala,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontFamily: quranFontFamily, fontSize: 26, height: 1.8),
            ),
          ],
        ],
      ),
    );
  }
}

class _AyahItem extends StatelessWidget {
  const _AyahItem({required this.row, required this.fontScale});

  final AyahsOfSurahResult row;
  final double fontScale;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ayah = row.a;
    final text = ayahDisplayText(surah: ayah.surah, number: ayah.number, text: ayah.textUthmani);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            // Espace insécable : la marque de fin ne passe jamais seule à la ligne.
            '$text\u00A0${ayahEndMark(ayah.number)}',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.start,
            style: TextStyle(fontFamily: quranFontFamily, fontSize: 26 * fontScale, height: 2.1),
          ),
          if (row.translation != null) ...[
            const SizedBox(height: 8),
            Text(
              '${ayah.number}. ${row.translation}',
              // Les traductions disponibles (FR, EN) s'écrivent de gauche à droite.
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 15, height: 1.5, color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
