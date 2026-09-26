import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../../../core/geo/geo_math.dart';
import '../../../core/location/saved_location.dart';
import '../../../l10n/app_localizations.dart';

/// Direction de la Qibla par rapport au nord (cadran fixe, nord en haut).
/// La boussole en direct, qui suit l'orientation du téléphone, viendra
/// ensuite (correction de la déclinaison magnétique, calibrage).
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
            SizedBox.square(
              dimension: 96,
              child: CustomPaint(
                painter: _DialPainter(
                  bearingDeg: bearing,
                  ring: scheme.outlineVariant,
                  needle: scheme.tertiary,
                  label: scheme.onSurfaceVariant,
                  textDirection: Directionality.of(context),
                ),
              ),
            ),
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
                    onPressed: () => context.go('/prayer/qibla'),
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

class _DialPainter extends CustomPainter {
  _DialPainter({
    required this.bearingDeg,
    required this.ring,
    required this.needle,
    required this.label,
    required this.textDirection,
  });

  final double bearingDeg;
  final Color ring;
  final Color needle;
  final Color label;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2 - 4;
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = ring,
    );

    // Graduation tous les 30°.
    for (var i = 0; i < 12; i++) {
      final a = i * math.pi / 6;
      final outer = c + Offset(math.sin(a), -math.cos(a)) * r;
      final inner = c + Offset(math.sin(a), -math.cos(a)) * (r - (i % 3 == 0 ? 8 : 4));
      canvas.drawLine(
        inner,
        outer,
        Paint()
          ..strokeWidth = 1.5
          ..color = ring,
      );
    }

    final n = TextPainter(
      text: TextSpan(
        text: 'N',
        style: TextStyle(color: label, fontSize: 11, fontWeight: FontWeight.w700),
      ),
      textDirection: textDirection,
    )..layout();
    n.paint(canvas, c + Offset(-n.width / 2, -r + 10));

    final a = bearingDeg * math.pi / 180;
    final dir = Offset(math.sin(a), -math.cos(a));
    final tip = c + dir * (r - 10);
    canvas.drawLine(
      c,
      tip,
      Paint()
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = needle,
    );
    canvas.drawCircle(tip, 5, Paint()..color = needle);
    canvas.drawCircle(c, 3, Paint()..color = needle);
  }

  @override
  bool shouldRepaint(_DialPainter old) =>
      old.bearingDeg != bearingDeg || old.ring != ring || old.needle != needle;
}
