import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../../../core/geo/geo_math.dart';
import '../../../core/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/qibla_compass.dart';

/// Boussole Qibla en direct.
///
/// Android fournit un cap magnétique, corrigé ici par la déclinaison du
/// modèle WMM-2025 ; iOS fournit directement le cap géographique.
class QiblaCompassScreen extends ConsumerStatefulWidget {
  const QiblaCompassScreen({super.key});

  @override
  ConsumerState<QiblaCompassScreen> createState() => _QiblaCompassScreenState();
}

class _QiblaCompassScreenState extends ConsumerState<QiblaCompassScreen> {
  StreamSubscription<CompassEvent>? _subscription;
  Timer? _noDataTimer;

  /// Cap lissé (moyenne circulaire exponentielle, pour éviter les sauts).
  double? _heading;
  double? _accuracy;
  bool _unavailable = false;
  bool _needsLocation = false;
  bool _wasAligned = false;

  @override
  void initState() {
    super.initState();
    _listen();
  }

  void _listen() {
    final events = FlutterCompass.events;
    if (events == null) {
      _unavailable = true;
      return;
    }
    _subscription = events.listen(_onEvent);
    _noDataTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && _heading == null && !_needsLocation) setState(() => _unavailable = true);
    });
  }

  void _onEvent(CompassEvent event) {
    final raw = event.heading;
    if (raw == null) return;
    // iOS renvoie -1 tant que le cap géographique n'est pas disponible
    // (localisation non autorisée).
    if (Platform.isIOS && raw < 0) {
      if (!_needsLocation) setState(() => _needsLocation = true);
      return;
    }
    final location = ref.read(settingsProvider).location;
    final declination = location == null
        ? 0.0
        : magneticDeclination(location.latitude, location.longitude, DateTime.now());
    final heading = trueHeading(
      rawHeading: raw,
      isMagnetic: Platform.isAndroid,
      declination: declination,
    );
    setState(() {
      _needsLocation = false;
      _unavailable = false;
      _accuracy = event.accuracy;
      _heading = _heading == null ? heading : _smooth(_heading!, heading);
    });

    // Vibration brève au moment où le téléphone s'aligne sur la Qibla.
    if (location != null) {
      final turn = turnToQibla(
        qiblaBearing: qiblaBearing(location.latitude, location.longitude),
        heading: _heading!,
      );
      final aligned = isFacingQibla(turn);
      if (aligned && !_wasAligned) HapticFeedback.mediumImpact();
      _wasAligned = aligned;
    }
  }

  double _smooth(double previous, double next) {
    const alpha = 0.25;
    final p = previous * math.pi / 180;
    final n = next * math.pi / 180;
    final x = (1 - alpha) * math.cos(p) + alpha * math.cos(n);
    final y = (1 - alpha) * math.sin(p) + alpha * math.sin(n);
    return normalize360(math.atan2(y, x) * 180 / math.pi);
  }

  Future<void> _requestLocation() async {
    await Geolocator.requestPermission();
    await _subscription?.cancel();
    _noDataTimer?.cancel();
    _listen();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _noDataTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final location = ref.watch(settingsProvider.select((s) => s.location));
    final scheme = Theme.of(context).colorScheme;

    if (location == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.qiblaCompassTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l.noLocationBody, textAlign: TextAlign.center),
          ),
        ),
      );
    }

    final bearing = qiblaBearing(location.latitude, location.longitude);
    final heading = _heading;
    final turn = heading == null ? null : turnToQibla(qiblaBearing: bearing, heading: heading);
    final aligned = turn != null && isFacingQibla(turn);

    final degrees = NumberFormat('0', locale);
    final declination = magneticDeclination(location.latitude, location.longitude, DateTime.now());

    return Scaffold(
      appBar: AppBar(title: Text(l.qiblaCompassTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          Text(
            l.qiblaBearing(NumberFormat('0.0', locale).format(bearing)),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1,
            child: Directionality(
              // Une boussole ne s'inverse jamais, même en arabe.
              textDirection: TextDirection.ltr,
              child: CustomPaint(
                painter: _CompassPainter(
                  heading: heading ?? 0,
                  qiblaBearing: bearing,
                  live: heading != null,
                  aligned: aligned,
                  ring: aligned ? scheme.primary : scheme.outlineVariant,
                  text: scheme.onSurface,
                  accent: scheme.tertiary,
                  north: scheme.error,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_unavailable)
            _Notice(icon: Icons.explore_off_outlined, text: l.compassUnavailable)
          else if (_needsLocation)
            _Notice(
              icon: Icons.location_off_outlined,
              text: l.compassNeedsLocation,
              action: TextButton(onPressed: _requestLocation, child: Text(l.allow)),
            )
          else if (turn == null)
            const Center(child: CircularProgressIndicator())
          else
            Text(
              aligned
                  ? l.qiblaAligned
                  : (turn > 0
                        ? l.turnRight(degrees.format(turn.abs()))
                        : l.turnLeft(degrees.format(turn.abs()))),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: aligned ? scheme.primary : scheme.onSurface,
              ),
            ),
          const SizedBox(height: 16),
          if ((_accuracy ?? 0) > 25) _Notice(icon: Icons.sync_problem, text: l.calibrateTip),
          _Notice(icon: Icons.info_outline, text: l.metalWarning),
          if (Platform.isAndroid)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l.declinationNote(NumberFormat('+0.0;-0.0', locale).format(declination)),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
              ),
            ),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text, this.action});

  final IconData icon;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: scheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
          ),
          ?action,
        ],
      ),
    );
  }
}

/// Rose des vents qui tourne avec le téléphone (le nord reste au nord),
/// repère de la Kaaba placé à l'angle de la Qibla, index fixe en haut.
class _CompassPainter extends CustomPainter {
  _CompassPainter({
    required this.heading,
    required this.qiblaBearing,
    required this.live,
    required this.aligned,
    required this.ring,
    required this.text,
    required this.accent,
    required this.north,
  });

  final double heading;
  final double qiblaBearing;
  final bool live;
  final bool aligned;
  final Color ring;
  final Color text;
  final Color accent;
  final Color north;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2 - 12;

    // Index fixe : la direction vers laquelle pointe le haut du téléphone.
    final index = Path()
      ..moveTo(c.dx, c.dy - r - 10)
      ..lineTo(c.dx - 9, c.dy - r - 26)
      ..lineTo(c.dx + 9, c.dy - r - 26)
      ..close();
    canvas.drawPath(index, Paint()..color = aligned ? ring : text);

    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(-heading * math.pi / 180);

    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = aligned ? 5 : 3
        ..color = ring,
    );

    for (var deg = 0; deg < 360; deg += 5) {
      final a = deg * math.pi / 180;
      final dir = Offset(math.sin(a), -math.cos(a));
      final len = deg % 90 == 0 ? 16.0 : (deg % 30 == 0 ? 11.0 : 6.0);
      canvas.drawLine(
        dir * (r - len),
        dir * r,
        Paint()
          ..strokeWidth = deg % 30 == 0 ? 2 : 1
          ..color = text.withValues(alpha: deg % 30 == 0 ? 0.8 : 0.4),
      );
    }

    for (final (deg, label) in const [(0, 'N'), (90, 'E'), (180, 'S'), (270, 'W')]) {
      final a = deg * math.pi / 180;
      final painter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: deg == 0 ? north : text,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final pos = Offset(math.sin(a), -math.cos(a)) * (r - 34);
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(a);
      painter.paint(canvas, Offset(-painter.width / 2, -painter.height / 2));
      canvas.restore();
      painter.dispose();
    }

    // Aiguille vers la Qibla, terminée par la Kaaba.
    final q = qiblaBearing * math.pi / 180;
    final dir = Offset(math.sin(q), -math.cos(q));
    canvas.drawLine(
      Offset.zero,
      dir * (r - 52),
      Paint()
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..color = live ? accent : accent.withValues(alpha: 0.5),
    );
    canvas.save();
    canvas.translate(dir.dx * (r - 52), dir.dy * (r - 52));
    canvas.rotate(q);
    final kaaba = Rect.fromCenter(center: Offset.zero, width: 26, height: 26);
    canvas.drawRRect(
      RRect.fromRectAndRadius(kaaba, const Radius.circular(3)),
      Paint()..color = const Color(0xFF1B1B1B),
    );
    canvas.drawRect(
      Rect.fromLTWH(kaaba.left, kaaba.top + 6, kaaba.width, 4),
      Paint()..color = const Color(0xFFD4AF37),
    );
    canvas.restore();

    canvas.drawCircle(Offset.zero, 6, Paint()..color = accent);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CompassPainter old) =>
      old.heading != heading ||
      old.qiblaBearing != qiblaBearing ||
      old.aligned != aligned ||
      old.live != live ||
      old.ring != ring;
}
