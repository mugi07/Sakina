import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/database/content_database.dart';
import '../../application/quran_providers.dart';
import '../../domain/page_layout.dart';
import '../../domain/quran_text.dart';
import 'mushaf_typography.dart';
import 'page_frame.dart';

/// Page de référence (Al-Baqara 6-16, une page pleine ordinaire).
const referenceMushafPage = 3;

/// Taille du texte arabe, la même pour tout le mushaf : celle qui fait tenir
/// la page de référence dans la hauteur de l'écran (une page ≈ un écran).
double uniformMushafFontSize(List<AyahsOfPageResult> referenceRows, Size viewport) {
  final content = Size(
    viewport.width - pageFrameHorizontalInset,
    viewport.height - pageFrameVerticalInset,
  );
  return fitFontSize('ref$referenceMushafPage', buildPageBlocks(referenceRows), content);
}

/// Une page du mushaf en arabe, dans le défilement continu : texte justifié,
/// en-têtes de sourate, médaillons de versets ; hauteur naturelle.
class MushafPageBlock extends ConsumerStatefulWidget {
  const MushafPageBlock({
    required this.page,
    required this.fontSize,
    required this.onAyahTap,
    this.selectedAyahId,
    this.playingAyahId,
    super.key,
  });

  final int page;
  final double fontSize;
  final int? selectedAyahId;

  /// Verset en cours de récitation (surligné en doré).
  final int? playingAyahId;
  final ValueChanged<AyahsOfPageResult> onAyahTap;

  @override
  ConsumerState<MushafPageBlock> createState() => _MushafPageBlockState();
}

class _MushafPageBlockState extends ConsumerState<MushafPageBlock> {
  final _recognizers = <int, TapGestureRecognizer>{};

  @override
  void dispose() {
    for (final r in _recognizers.values) {
      r.dispose();
    }
    super.dispose();
  }

  TapGestureRecognizer _recognizerFor(AyahsOfPageResult row) =>
      _recognizers[row.a.id] ??= TapGestureRecognizer()..onTap = () => widget.onAyahTap(row);

  @override
  Widget build(BuildContext context) {
    final rows = ref.watch(pageAyahsProvider((page: widget.page, edition: null))).value;
    final surahs = ref.watch(surahByIdProvider).value;
    final basmala = ref.watch(basmalaProvider).value;
    if (rows == null || surahs == null || basmala == null) {
      // Réserve environ une page pendant le chargement.
      return SizedBox(height: widget.fontSize * 30);
    }

    final scheme = Theme.of(context).colorScheme;
    for (final row in rows) {
      _recognizerFor(row);
    }
    final first = rows.first.a;
    final m = MushafMetrics(widget.fontSize);

    final children = <Widget>[];
    for (final block in buildPageBlocks(rows)) {
      if (children.isNotEmpty) children.add(SizedBox(height: m.blockGap));
      switch (block) {
        case SurahHeaderBlock():
          children.add(
            _SurahBanner(
              name: 'سُورَةُ ${surahs[block.surah]!.nameAr}',
              basmala: block.showsBasmala ? basmala : null,
              metrics: m,
            ),
          );
        case AyahRunBlock():
          children.add(
            Text.rich(
              ayahRunSpan(
                block,
                fontSize: widget.fontSize,
                textColor: scheme.onSurface,
                markColor: scheme.tertiary,
                selectedAyahId: widget.selectedAyahId,
                highlightColor: scheme.primary.withValues(alpha: 0.14),
                playingAyahId: widget.playingAyahId,
                playingColor: scheme.tertiary.withValues(alpha: 0.22),
                recognizers: _recognizers,
              ),
              textAlign: TextAlign.justify,
              textDirection: TextDirection.rtl,
              textScaler: TextScaler.noScaling,
            ),
          );
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: PageFrame(
        header: PageHeaderRow(
          start: 'سورة ${surahs[first.surah]!.nameAr}',
          end:
              'الجزء ${toArabicIndicDigits(first.juz)} · '
              'الحزب ${toArabicIndicDigits(hizbOfQuarter(first.hizbQuarter))}',
        ),
        footer: toArabicIndicDigits(widget.page),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

class _SurahBanner extends StatelessWidget {
  const _SurahBanner({required this.name, required this.basmala, required this.metrics});

  final String name;
  final String? basmala;
  final MushafMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = TextStyle(
      fontFamily: quranFontFamily,
      fontSize: metrics.fontSize,
      height: 1.2,
      letterSpacing: 0,
    );
    return Column(
      children: [
        Container(
          height: metrics.headerHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.08),
            border: Border.all(color: scheme.tertiary, width: 1.2),
            borderRadius: BorderRadius.circular(metrics.fontSize * 0.6),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              name,
              textScaler: TextScaler.noScaling,
              style: style.copyWith(color: scheme.primary),
            ),
          ),
        ),
        if (basmala != null)
          SizedBox(
            height: metrics.basmalaHeight,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(basmala!, textScaler: TextScaler.noScaling, style: style),
              ),
            ),
          ),
      ],
    );
  }
}
