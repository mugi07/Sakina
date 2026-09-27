import 'dart:math' as math;

import 'package:flutter/painting.dart';

/// Couleur du soleil sur les cadrans (lisible en thème clair et sombre).
const sunColor = Color(0xFFF2A516);

/// Dessine un petit soleil (disque et 8 rayons) centré en [center].
void paintSun(Canvas canvas, Offset center, double radius, {Color color = sunColor}) {
  final rays = Paint()
    ..color = color
    ..strokeWidth = radius * 0.28
    ..strokeCap = StrokeCap.round;
  for (var i = 0; i < 8; i++) {
    final a = i * math.pi / 4;
    final dir = Offset(math.cos(a), math.sin(a));
    canvas.drawLine(center + dir * radius * 1.45, center + dir * radius * 2.05, rays);
  }
  canvas.drawCircle(center, radius, Paint()..color = color);
}

/// Dessine la Kaaba (carré noir et bande dorée) de côté [side], centrée en
/// [center] et tournée de [angle] radians (bande vers l'extérieur).
void paintKaaba(Canvas canvas, Offset center, double side, double angle) {
  canvas.save();
  canvas.translate(center.dx, center.dy);
  canvas.rotate(angle);
  final body = Rect.fromCenter(center: Offset.zero, width: side, height: side);
  canvas.drawRRect(
    RRect.fromRectAndRadius(body, Radius.circular(side * 0.12)),
    Paint()..color = const Color(0xFF1B1B1B),
  );
  canvas.drawRect(
    Rect.fromLTWH(body.left, body.top + side * 0.23, side, side * 0.16),
    Paint()..color = const Color(0xFFD4AF37),
  );
  canvas.restore();
}
