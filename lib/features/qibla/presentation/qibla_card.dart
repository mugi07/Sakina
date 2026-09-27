import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../../../core/geo/geo_math.dart';
import '../../../core/location/saved_location.dart';
import '../../../l10n/app_localizations.dart';
import 'dial_glyphs.dart';

/// Ouvre la boussole Qibla en plein écran.
void openQiblaCompass(BuildContext context) => context.push('/qibla');

/// Direction de la Qibla par rapport au nord (cadran fixe, nord en haut),
/// avec l'accès à la boussole en direct.
class QiblaCard extends StatelessWidget {
  const QiblaCard({required this.location, super.key});

  final SavedLocation location;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final bearing = qiblaBearing(location.latitude, location.longitude);
    final km = distanceToKaabaKm(location.latitude, location.longitude);
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            QiblaDial(angle: bearing),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.qiblaTitle, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    l.qiblaBearing(NumberFormat('0.0', locale).format(bearing)),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: scheme.primary,
                    ),
                  ),
                  Text(l.qiblaDistance(NumberFormat.decimalPattern(locale).format(km.round()))),
                  const SizedBox(height: 8),
                  Text(l.qiblaHint, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  FilledButton.tonalIcon(
                    onPressed: () => openQiblaCompass(context),
                    icon: const Icon(Icons.explore_outlined),
                    label: Text(l.openCompass),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cadran fixe : repère en haut (le nord, ou le soleil si [sunAtTop]) et
/// aiguille vers la Kaaba à [angle] degrés de ce repère, dans le sens des
/// aiguilles d'une montre. Jamais inversé en arabe.
class QiblaDial extends StatelessWidget {
  const QiblaDial({required this.angle, this.sunAtTop = false, this.size = 96, super.key});

  final double angle;
  final bool sunAtTop;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _DialPainter(
          bearingDeg: angle,
          sunAtTop: sunAtTop,
          ring: scheme.outlineVariant,
          needle: scheme.tertiary,
          label: scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter({
    required this.bearingDeg,
    required this.sunAtTop,
    required this.ring,
    required this.needle,
    required this.label,
  });

  final double bearingDeg;
  final bool sunAtTop;
  final Color ring;
  final Color needle;
  final Color label;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final scale = size.shortestSide / 96;
    // Avec le soleil, le cadran rétrécit pour laisser le soleil au-dessus
    // du cercle, hors de portée de la Kaaba.
    final r = size.shortestSide / 2 - (sunAtTop ? 13 * scale : 4);
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * scale.clamp(0.75, 1.5)
        ..color = ring,
    );

    // Graduation tous les 30° (sauf sur les petits cadrans, où elle ferait
    // penser à une horloge).
    for (var i = 0; i < (size.shortestSide >= 64 ? 12 : 0); i++) {
      final a = i * math.pi / 6;
      final outer = c + Offset(math.sin(a), -math.cos(a)) * r;
      final inner = c + Offset(math.sin(a), -math.cos(a)) * (r - (i % 3 == 0 ? 8 : 4) * scale);
      canvas.drawLine(
        inner,
        outer,
        Paint()
          ..strokeWidth = 1.5 * scale.clamp(0.75, 1.5)
          ..color = ring,
      );
    }

    if (sunAtTop) {
      paintSun(canvas, c + Offset(0, -r - 4 * scale), 4 * scale);
    } else if (size.shortestSide >= 64) {
      final n = TextPainter(
        text: TextSpan(
          text: 'N',
          style: TextStyle(color: label, fontSize: 11, fontWeight: FontWeight.w700),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      n.paint(canvas, c + Offset(-n.width / 2, -r + 10));
      n.dispose();
    } else {
      // Petit cadran : un point rouge marque le nord.
      canvas.drawCircle(c + Offset(0, -r + 5), 2.5, Paint()..color = const Color(0xFFD32F2F));
    }

    final a = bearingDeg * math.pi / 180;
    final dir = Offset(math.sin(a), -math.cos(a));
    // Aiguille terminée par la Kaaba.
    final kaaba = math.max(9, 15 * scale);
    final tip = c + dir * (r - kaaba);
    canvas.drawLine(
      c,
      c + dir * (r - kaaba * 1.5),
      Paint()
        ..strokeWidth = 3 * scale.clamp(0.75, 1.5)
        ..strokeCap = StrokeCap.round
        ..color = needle,
    );
    paintKaaba(canvas, tip, kaaba.toDouble(), a);
    canvas.drawCircle(c, 3 * scale.clamp(0.6, 1.5), Paint()..color = needle);
  }

  @override
  bool shouldRepaint(_DialPainter old) =>
      old.bearingDeg != bearingDeg ||
      old.sunAtTop != sunAtTop ||
      old.ring != ring ||
      old.needle != needle;
}
