import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/page_layout.dart';
import '../../domain/quran_text.dart';

/// Dimensions d'une page du mushaf pour une taille de police donnée.
///
/// Le rendu (MushafPage) et la mesure ([measurePage]) utilisent exactement
/// ces valeurs, pour que la taille calculée corresponde à l'affichage.
class MushafMetrics {
  const MushafMetrics(this.fontSize);

  final double fontSize;

  /// Interligne du texte coranique (les signes au-dessus et en dessous des
  /// lettres demandent plus de place qu'un texte ordinaire).
  static const lineHeight = 1.9;

  double get headerHeight => fontSize * 2.2;
  double get basmalaHeight => fontSize * 2.1;
  double get blockGap => fontSize * 0.3;
}

/// Paragraphe d'une suite de versets : texte, espace insécable, puis
/// médaillon de fin de verset (jamais seul en début de ligne).
TextSpan ayahRunSpan(
  AyahRunBlock block, {
  required double fontSize,
  Color? textColor,
  Color? markColor,
  int? selectedAyahId,
  Color? highlightColor,
  Map<int, TapGestureRecognizer>? recognizers,
}) {
  final children = <InlineSpan>[];
  for (final row in block.rows) {
    final a = row.a;
    final selected = a.id == selectedAyahId;
    final background = selected ? highlightColor : null;
    final recognizer = recognizers?[a.id];
    children
      ..add(
        TextSpan(
          text: '${ayahDisplayText(surah: a.surah, number: a.number, text: a.textUthmani)}\u00A0',
          recognizer: recognizer,
          style: background == null ? null : TextStyle(backgroundColor: background),
        ),
      )
      ..add(
        TextSpan(
          text: ayahEndMark(a.number),
          recognizer: recognizer,
          style: TextStyle(color: markColor, backgroundColor: background),
        ),
      )
      ..add(const TextSpan(text: ' '));
  }
  return TextSpan(
    // Tout est fixé explicitement : le style par défaut du thème (espacement
    // des lettres, graisse…) ne doit pas modifier la mise en page mesurée.
    style: TextStyle(
      fontFamily: quranFontFamily,
      fontSize: fontSize,
      height: MushafMetrics.lineHeight,
      color: textColor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0,
      wordSpacing: 0,
    ),
    children: children,
  );
}

/// Hauteur totale d'une page composée de [blocks] sur la largeur [width].
double measurePage(List<PageBlock> blocks, double width, double fontSize) {
  final m = MushafMetrics(fontSize);
  var height = 0.0;
  for (var i = 0; i < blocks.length; i++) {
    if (i > 0) height += m.blockGap;
    switch (blocks[i]) {
      case SurahHeaderBlock(:final showsBasmala):
        height += m.headerHeight + (showsBasmala ? m.basmalaHeight : 0);
      case final AyahRunBlock run:
        final painter = TextPainter(
          text: ayahRunSpan(run, fontSize: fontSize),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.justify,
          textScaler: TextScaler.noScaling,
        )..layout(maxWidth: width);
        height += painter.height;
        painter.dispose();
    }
  }
  return height;
}

/// Plus grande taille de police (entre [min] et [max]) pour laquelle toute
/// la page tient dans [size]. Résultats mis en cache : la mesure du texte
/// arabe est coûteuse et les pages sont reconstruites souvent.
double fitFontSize(
  String cacheKey,
  List<PageBlock> blocks,
  Size size, {
  double min = 14,
  double max = 32,
}) {
  final key = '$cacheKey@${size.width.round()}x${size.height.round()}';
  final cached = _fitCache[key];
  if (cached != null) return cached;

  double result;
  if (measurePage(blocks, size.width, max) <= size.height) {
    result = max;
  } else {
    var lo = min;
    var hi = max;
    for (var i = 0; i < 10; i++) {
      final mid = (lo + hi) / 2;
      if (measurePage(blocks, size.width, mid) <= size.height) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    result = lo;
  }
  _fitCache[key] = result;
  if (_fitCache.length > 200) _fitCache.remove(_fitCache.keys.first);
  return result;
}

final _fitCache = <String, double>{};
