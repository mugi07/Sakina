import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/database/content_database.dart';
import '../../../../core/providers.dart';
import '../../application/quran_providers.dart';
import '../../domain/page_layout.dart';
import '../../domain/quran_text.dart';
import 'mushaf_typography.dart';
import 'page_frame.dart';

/// Page de référence (Al-Baqara 6-16, une page pleine ordinaire) : sa taille
/// de police sert de plafond, pour garder une taille uniforme d'une page à
/// l'autre comme dans un mushaf imprimé.
const _referencePage = 3;

/// Une page du mushaf en arabe : texte continu et justifié, en-têtes de
/// sourate, et taille ajustée pour que la page tienne entière à l'écran.
class MushafPage extends ConsumerStatefulWidget {
  const MushafPage({required this.page, required this.onAyahTap, this.selectedAyahId, super.key});

  final int page;
  final int? selectedAyahId;
  final ValueChanged<AyahsOfPageResult> onAyahTap;

  @override
  ConsumerState<MushafPage> createState() => _MushafPageState();
}

class _MushafPageState extends ConsumerState<MushafPage> {
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
    final reference = ref.watch(pageAyahsProvider((page: _referencePage, edition: null))).value;
    final surahs = ref.watch(surahByIdProvider).value;
    final basmala = ref.watch(basmalaProvider).value;
    final scale = ref.watch(settingsProvider.select((s) => s.arabicFontScale));
    if (rows == null || reference == null || surahs == null || basmala == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final scheme = Theme.of(context).colorScheme;
    final blocks = buildPageBlocks(rows);
    for (final row in rows) {
      _recognizerFor(row);
    }
    final first = rows.first.a;

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest;
            final pageFit = fitFontSize('p${widget.page}', blocks, size);
            final referenceFit = fitFontSize('p$_referencePage', buildPageBlocks(reference), size);
            final fontSize = math.min(pageFit, referenceFit) * scale;
            final m = MushafMetrics(fontSize);

            final children = <Widget>[];
            for (final block in blocks) {
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
                        fontSize: fontSize,
                        textColor: scheme.onSurface,
                        markColor: scheme.tertiary,
                        selectedAyahId: widget.selectedAyahId,
                        highlightColor: scheme.primary.withValues(alpha: 0.14),
                        recognizers: _recognizers,
                      ),
                      textAlign: TextAlign.justify,
                      textDirection: TextDirection.rtl,
                      textScaler: TextScaler.noScaling,
                    ),
                  );
              }
            }

            // Les deux premières pages (Al-Fatiha, début d'Al-Baqara) sont
            // centrées, comme dans le mushaf imprimé.
            final centered = widget.page <= 2;
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height),
                child: Column(
                  mainAxisAlignment: centered ? MainAxisAlignment.center : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            );
          },
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
