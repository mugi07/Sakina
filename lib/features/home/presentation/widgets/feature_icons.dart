import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../qibla/presentation/dial_glyphs.dart';

/// Rubriques de la grille de l'accueil.
enum HomeFeature { quran, prayerTimes, qibla, adhkar, tasbih, hadith, names, calendar, khatma }

const _cream = Color(0xFFFFF6E0);
const _gold = Color(0xFFF2D28B);
const _goldDeep = Color(0xFFD9A544);

/// Dégradé de fond de chaque icône (haut-gauche, bas-droite).
const _backgrounds = {
  HomeFeature.quran: (Color(0xFF1BAA84), Color(0xFF0B6B53)),
  HomeFeature.prayerTimes: (Color(0xFF4079C0), Color(0xFF1B3A66)),
  HomeFeature.qibla: (Color(0xFF34B37D), Color(0xFF146B45)),
  HomeFeature.adhkar: (Color(0xFFFDB44B), Color(0xFFE2701F)),
  HomeFeature.tasbih: (Color(0xFF4A9BEA), Color(0xFF2360B8)),
  HomeFeature.hadith: (Color(0xFFC9914A), Color(0xFF7E5222)),
  HomeFeature.names: (Color(0xFF8B6AD8), Color(0xFF4E3496)),
  HomeFeature.calendar: (Color(0xFF3CC1B8), Color(0xFF1D7F7A)),
  HomeFeature.khatma: (Color(0xFFE0619C), Color(0xFFA12D69)),
};

/// Icône illustrée d'une rubrique : disque en dégradé et dessin simple,
/// lisible même en petit. Jamais inversée en arabe.
class FeatureIcon extends StatelessWidget {
  const FeatureIcon(this.feature, {this.size = 60, super.key});

  final HomeFeature feature;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(painter: _FeatureIconPainter(feature)),
  );
}

class _FeatureIconPainter extends CustomPainter {
  _FeatureIconPainter(this.feature);

  final HomeFeature feature;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // Toutes les icônes sont dessinées dans un carré de 100 × 100.
    canvas.scale(size.shortestSide / 100);
    final (top, bottom) = _backgrounds[feature]!;
    final disc = Path()..addOval(Rect.fromCircle(center: const Offset(50, 50), radius: 47));
    canvas.drawShadow(disc, Colors.black, 3, false);
    canvas.drawPath(
      disc,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [top, bottom],
        ).createShader(const Rect.fromLTWH(0, 0, 100, 100)),
    );
    switch (feature) {
      case HomeFeature.quran:
        _quran(canvas);
      case HomeFeature.prayerTimes:
        _mosque(canvas, bottom);
      case HomeFeature.qibla:
        _qibla(canvas);
      case HomeFeature.adhkar:
        _sunAndMoon(canvas, top);
      case HomeFeature.tasbih:
        _tasbih(canvas);
      case HomeFeature.hadith:
        _scroll(canvas);
      case HomeFeature.names:
        _star(canvas, bottom);
      case HomeFeature.calendar:
        _calendar(canvas, bottom);
      case HomeFeature.khatma:
        _khatma(canvas, bottom);
    }
    canvas.restore();
  }

  static Paint _fill(Color c) => Paint()..color = c;

  static Paint _stroke(Color c, double width) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  /// Croissant : disque de centre [c] et rayon [r], moins un disque décalé
  /// de [shift] (le trou laisse voir le fond).
  static Path _crescent(Offset c, double r, Offset shift, {double inner = 0.85}) => Path.combine(
    PathOperation.difference,
    Path()..addOval(Rect.fromCircle(center: c, radius: r)),
    Path()..addOval(Rect.fromCircle(center: c + shift, radius: r * inner)),
  );

  /// Coran ouvert posé sur un pupitre (rahla).
  void _quran(Canvas canvas) {
    final stand = _stroke(_gold, 4);
    canvas.drawLine(const Offset(33, 82), const Offset(67, 64), stand);
    canvas.drawLine(const Offset(67, 82), const Offset(33, 64), stand);
    Path page(double side, double edge) => Path()
      ..moveTo(50, 36)
      ..cubicTo(50 + side * 8, 31 + edge, 50 + side * 20, 31 + edge, 50 + side * 28, 34 + edge)
      ..lineTo(50 + side * 28, 64 + edge)
      ..cubicTo(50 + side * 20, 61 + edge, 50 + side * 8, 61 + edge, 50, 66 + edge)
      ..close();
    // Couverture (dépasse sous les pages), puis pages.
    final cover = _fill(const Color(0xFF0A4F3E));
    canvas.drawPath(page(-1.14, 4), cover);
    canvas.drawPath(page(1.14, 4), cover);
    canvas.drawPath(page(-1, 0), _fill(_cream));
    canvas.drawPath(page(1, 0), _fill(_cream));
    final lines = _stroke(const Color(0xFF0E6B55).withValues(alpha: 0.4), 1.8);
    for (final y in [43.0, 49.0, 55.0]) {
      canvas.drawLine(Offset(27, y), Offset(45, y + 1.5), lines);
      canvas.drawLine(Offset(55, y + 1.5), Offset(73, y), lines);
    }
    canvas.drawLine(const Offset(50, 36), const Offset(50, 66), _stroke(_goldDeep, 1.4));
  }

  /// Mosquée : coupole, deux minarets, croissant.
  void _mosque(Canvas canvas, Color background) {
    final body = _fill(_cream);
    canvas.drawRect(const Rect.fromLTRB(30, 57, 70, 76), body);
    canvas.drawPath(
      Path()
        ..moveTo(31, 58)
        ..cubicTo(31, 45, 42, 40, 50, 31)
        ..cubicTo(58, 40, 69, 45, 69, 58)
        ..close(),
      body,
    );
    for (final x in [20.0, 74.0]) {
      canvas.drawRect(Rect.fromLTRB(x, 42, x + 6, 76), body);
      canvas.drawPath(
        Path()
          ..moveTo(x - 1, 42)
          ..lineTo(x + 3, 33)
          ..lineTo(x + 7, 42)
          ..close(),
        body,
      );
      canvas.drawRect(Rect.fromLTRB(x - 1.5, 50, x + 7.5, 53), _fill(_gold));
    }
    // Porte en arc brisé.
    canvas.drawPath(
      Path()
        ..moveTo(45, 76)
        ..lineTo(45, 69)
        ..quadraticBezierTo(45, 64, 50, 62)
        ..quadraticBezierTo(55, 64, 55, 69)
        ..lineTo(55, 76)
        ..close(),
      _fill(background),
    );
    canvas.drawLine(const Offset(50, 31), const Offset(50, 25), _stroke(_gold, 2));
    canvas.drawPath(_crescent(const Offset(50, 20), 5, const Offset(2.2, -1.4)), _fill(_gold));
  }

  /// Boussole et Kaaba.
  void _qibla(Canvas canvas) {
    const c = Offset(50, 52);
    canvas.drawCircle(c, 29, _stroke(Colors.white, 3.5));
    for (var i = 0; i < 12; i++) {
      final a = i * math.pi / 6;
      final dir = Offset(math.sin(a), -math.cos(a));
      canvas.drawLine(
        c + dir * 23,
        c + dir * (i % 3 == 0 ? 18 : 20.5),
        _stroke(Colors.white.withValues(alpha: 0.8), 1.8),
      );
    }
    // Repère du nord.
    canvas.drawPath(
      Path()
        ..moveTo(50, 12)
        ..lineTo(45, 20)
        ..lineTo(55, 20)
        ..close(),
      _fill(_gold),
    );
    paintKaaba(canvas, c, 22, 0);
  }

  /// Soleil et croissant : adhkar du matin et du soir.
  void _sunAndMoon(Canvas canvas, Color background) {
    const sun = Offset(40, 42);
    const light = Color(0xFFFFF3C4);
    canvas.drawCircle(sun, 12, _fill(light));
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final dir = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(sun + dir * 16, sun + dir * 21, _stroke(light, 3.2));
    }
    // Le croissant passe devant le soleil : disque de fond pour les séparer.
    const moon = Offset(60, 60);
    canvas.drawCircle(moon, 18, _fill(background.withValues(alpha: 0.9)));
    canvas.drawPath(_crescent(moon, 15.5, const Offset(6.5, -5.5)), _fill(Colors.white));
  }

  /// Chapelet : boucle de grains, grain principal et pompon.
  void _tasbih(Canvas canvas) {
    const c = Offset(50, 44);
    final bead = _fill(const Color(0xFFE6F4FF));
    for (var i = 0; i < 22; i++) {
      final a = math.pi / 2 + (i + 1) * (2 * math.pi - 0.9) / 23 + 0.45;
      canvas.drawCircle(c + Offset(math.cos(a) * 23, math.sin(a) * 21), 3.4, bead);
    }
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(50, 68), width: 9, height: 11),
      _fill(_gold),
    );
    final tassel = _stroke(_gold, 2.4);
    for (final dx in [-6.0, -2.0, 2.0, 6.0]) {
      canvas.drawLine(const Offset(50, 72), Offset(50 + dx, 86), tassel);
    }
  }

  /// Rouleau de parchemin.
  void _scroll(Canvas canvas) {
    canvas.drawRect(const Rect.fromLTRB(31, 30, 69, 72), _fill(const Color(0xFFFFF3D6)));
    final roll = _fill(const Color(0xFFF0D7A2));
    final edge = _stroke(const Color(0xFF7E5222).withValues(alpha: 0.45), 1.2);
    for (final y in [24.0, 68.0]) {
      final r = RRect.fromLTRBR(26, y, 74, y + 9, const Radius.circular(4.5));
      canvas.drawRRect(r, roll);
      canvas.drawRRect(r, edge);
    }
    final lines = _stroke(const Color(0xFF7E5222).withValues(alpha: 0.55), 2);
    for (final (y, end) in [(41.0, 63.0), (48.0, 63.0), (55.0, 63.0), (62.0, 54.0)]) {
      canvas.drawLine(Offset(37, y), Offset(end, y), lines);
    }
  }

  /// Étoile à huit branches et « 99 ».
  void _star(Canvas canvas, Color background) {
    const c = Offset(50, 50);
    Path square(double angle) {
      final path = Path();
      for (var i = 0; i < 4; i++) {
        final a = angle + i * math.pi / 2;
        final p = c + Offset(math.cos(a), math.sin(a)) * 27;
        i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      return path..close();
    }

    final star = Path.combine(PathOperation.union, square(0), square(math.pi / 4));
    canvas.drawPath(
      star,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_gold, _goldDeep],
        ).createShader(const Rect.fromLTWH(20, 20, 60, 60)),
    );
    canvas.drawCircle(c, 14, _fill(background));
    final text = TextPainter(
      text: const TextSpan(
        text: '99',
        style: TextStyle(
          fontFamily: uiFontFamily,
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, c - Offset(text.width / 2, text.height / 2));
    text.dispose();
  }

  /// Feuille de calendrier et croissant.
  void _calendar(Canvas canvas, Color background) {
    canvas.drawRRect(
      RRect.fromLTRBR(26, 30, 74, 76, const Radius.circular(7)),
      _fill(Colors.white),
    );
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        26,
        30,
        74,
        42,
        topLeft: const Radius.circular(7),
        topRight: const Radius.circular(7),
      ),
      _fill(_gold),
    );
    for (final x in [36.0, 60.0]) {
      canvas.drawRRect(
        RRect.fromLTRBR(x, 24, x + 4, 35, const Radius.circular(2)),
        _fill(background),
      );
    }
    canvas.drawPath(
      _crescent(const Offset(49, 59), 11, const Offset(4.5, -3.5)),
      _fill(background),
    );
  }

  /// Livre fermé entouré d'un anneau de progression.
  void _khatma(Canvas canvas, Color background) {
    const c = Offset(50, 50);
    canvas.drawCircle(c, 30, _stroke(Colors.white.withValues(alpha: 0.28), 4.5));
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: 30),
      -math.pi / 2,
      math.pi * 1.5,
      false,
      _stroke(_gold, 4.5),
    );
    canvas.drawRRect(RRect.fromLTRBR(37, 34, 63, 66, const Radius.circular(3)), _fill(_cream));
    canvas.drawRect(const Rect.fromLTRB(37, 34, 42, 66), _fill(background.withValues(alpha: 0.55)));
    canvas.drawPath(
      Path()
        ..moveTo(52.5, 43)
        ..lineTo(57, 50)
        ..lineTo(52.5, 57)
        ..lineTo(48, 50)
        ..close(),
      _fill(_goldDeep),
    );
  }

  @override
  bool shouldRepaint(_FeatureIconPainter old) => old.feature != feature;
}
