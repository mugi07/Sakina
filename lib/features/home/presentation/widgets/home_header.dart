import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/calendar/hijri_date.dart';
import '../../../../core/providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../prayer_times/application/prayer_providers.dart';
import '../../../prayer_times/domain/prayer_calculator.dart';
import '../../../prayer_times/presentation/prayer_labels.dart';

/// Moment de la journée, d'après les horaires de prière du lieu.
enum SkyPeriod { night, dawn, day, afternoon, dusk }

SkyPeriod skyPeriod(DayPrayerTimes? times, DateTime now) {
  if (times == null) return SkyPeriod.day;
  if (now.isBefore(times[Salah.fajr])) return SkyPeriod.night;
  if (now.isBefore(times[Salah.sunrise])) return SkyPeriod.dawn;
  if (now.isBefore(times[Salah.asr])) return SkyPeriod.day;
  if (now.isBefore(times[Salah.maghrib])) return SkyPeriod.afternoon;
  if (now.isBefore(times[Salah.isha])) return SkyPeriod.dusk;
  return SkyPeriod.night;
}

/// Couleurs du ciel, de haut en bas (le texte blanc reste lisible partout).
const skyColors = {
  SkyPeriod.night: [Color(0xFF0B1630), Color(0xFF1B2C54), Color(0xFF34457A)],
  SkyPeriod.dawn: [Color(0xFF2C3E70), Color(0xFF7D6497), Color(0xFFD98F6E)],
  SkyPeriod.day: [Color(0xFF1C69AB), Color(0xFF3F8DC9), Color(0xFF79B6E0)],
  SkyPeriod.afternoon: [Color(0xFF2F5F93), Color(0xFFB9824C), Color(0xFFD9A462)],
  SkyPeriod.dusk: [Color(0xFF2A2350), Color(0xFF7E3A66), Color(0xFFC96A52)],
};

/// En-tête de l'accueil : ciel du moment, silhouette de mosquée, prochaine
/// prière en grand avec compte à rebours, dates et horaires du jour.
class HomeHeader extends ConsumerWidget {
  const HomeHeader({required this.period, super.key});

  final SkyPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final calculator = ref.watch(prayerCalculatorProvider);
    final hijriAdjustment = ref.watch(settingsProvider.select((s) => s.hijriAdjustment));
    final now = ref.watch(clockProvider).value ?? DateTime.now();
    final today = calculator?.localToday(now) ?? DateTime(now.year, now.month, now.day);
    final hijri = HijriDate.fromGregorian(today, adjustmentDays: hijriAdjustment);
    final dates = '${hijri.format(locale)} · ${DateFormat.yMMMMEEEEd(locale).format(today)}';

    return CustomPaint(
      painter: _SkyPainter(period),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 40),
          child: Column(
            children: [
              const _TopBar(),
              if (calculator == null) ...[
                const SizedBox(height: 24),
                Text(l.homeGreeting, style: _white(28, FontWeight.w700)),
                const SizedBox(height: 8),
                Text(dates, textAlign: TextAlign.center, style: _white(14, FontWeight.w500, 0.9)),
                const SizedBox(height: 20),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: skyColors[period]!.first,
                  ),
                  onPressed: () => context.push('/location'),
                  icon: const Icon(Icons.location_on_outlined),
                  label: Text(l.chooseLocation),
                ),
                const SizedBox(height: 32),
              ] else
                ..._prayer(context, l, locale, calculator, now, today, dates),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _prayer(
    BuildContext context,
    AppLocalizations l,
    String locale,
    PrayerCalculator calculator,
    DateTime now,
    DateTime today,
    String dates,
  ) {
    final next = calculator.nextPrayer(now);
    final day = calculator.forDay(today);
    return [
      const SizedBox(height: 4),
      Text(l.nextPrayer, style: _white(14, FontWeight.w500, 0.85)),
      Text(l.salahName(next.salah), style: _white(24, FontWeight.w600)),
      Text(
        formatTime(next.time, locale),
        style: _white(
          56,
          FontWeight.w700,
        ).copyWith(height: 1.15, fontFeatures: const [FontFeature.tabularFigures()]),
      ),
      Text(
        l.timeRemaining(formatCountdown(next.time.difference(now), locale)),
        style: _white(
          16,
          FontWeight.w500,
        ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(dates, textAlign: TextAlign.center, style: _white(13, FontWeight.w500, 0.9)),
      ),
      const SizedBox(height: 14),
      Row(
        children: [
          for (final salah in Salah.values.where((s) => s.isPrayer))
            Expanded(
              child: _PrayerChip(
                label: l.salahName(salah),
                time: formatTime(day[salah], locale),
                highlighted: salah == next.salah && next.time.day == day[salah].day,
              ),
            ),
        ],
      ),
    ];
  }
}

TextStyle _white(double size, FontWeight weight, [double opacity = 1]) => TextStyle(
  color: Colors.white.withValues(alpha: opacity),
  fontSize: size,
  fontWeight: weight,
  shadows: const [Shadow(color: Color(0x55000000), blurRadius: 6, offset: Offset(0, 1))],
);

/// Lieu (ouvre le choix du lieu) et accès aux réglages.
class _TopBar extends ConsumerWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final location = ref.watch(settingsProvider.select((s) => s.location));
    final lang = Localizations.localeOf(context).languageCode;
    final label = location == null
        ? l.chooseLocation
        : [
            location.cityName(lang) ?? l.myPosition,
            ?location.countryName(lang),
          ].join(lang == 'ar' ? '، ' : ', ');
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () => context.push('/location'),
              icon: Icon(
                location?.fromGps ?? false ? Icons.my_location : Icons.location_on_outlined,
              ),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: _white(15, FontWeight.w600),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          tooltip: l.settingsTitle,
          color: Colors.white,
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => context.go('/more/settings'),
        ),
      ],
    );
  }
}

class _PrayerChip extends StatelessWidget {
  const _PrayerChip({required this.label, required this.time, required this.highlighted});

  final String label;
  final String time;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: highlighted
            ? Colors.white.withValues(alpha: 0.28)
            : Colors.black.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(14),
        border: highlighted ? Border.all(color: Colors.white.withValues(alpha: 0.8)) : null,
      ),
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _white(12, highlighted ? FontWeight.w700 : FontWeight.w500, 0.9),
          ),
          const SizedBox(height: 2),
          Text(time, style: _white(14, FontWeight.w700)),
        ],
      ),
    );
  }
}

/// Ciel en dégradé, soleil ou lune, étoiles la nuit, et silhouette de
/// mosquée en bas (jamais inversée en arabe).
class _SkyPainter extends CustomPainter {
  _SkyPainter(this.period);

  final SkyPeriod period;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: skyColors[period]!,
        ).createShader(rect),
    );

    final w = size.width;
    final h = size.height;
    switch (period) {
      case SkyPeriod.night:
        final random = math.Random(7);
        for (var i = 0; i < 40; i++) {
          canvas.drawCircle(
            Offset(random.nextDouble() * w, random.nextDouble() * h * 0.7),
            random.nextDouble() * 1.2 + 0.4,
            Paint()..color = Colors.white.withValues(alpha: random.nextDouble() * 0.5 + 0.2),
          );
        }
        _moon(canvas, Offset(w * 0.84, h * 0.34));
      case SkyPeriod.dusk:
        _moon(canvas, Offset(w * 0.84, h * 0.34));
      case SkyPeriod.dawn:
        _sun(canvas, Offset(w * 0.12, h * 0.62), 20);
      case SkyPeriod.day:
        _sun(canvas, Offset(w * 0.84, h * 0.34), 18);
      case SkyPeriod.afternoon:
        _sun(canvas, Offset(w * 0.88, h * 0.55), 20);
    }
    _skyline(canvas, size);
  }

  void _sun(Canvas canvas, Offset c, double r) {
    canvas.drawCircle(
      c,
      r * 3,
      Paint()
        ..shader = RadialGradient(
          colors: [const Color(0xFFFFE9A8).withValues(alpha: 0.55), const Color(0x00FFE9A8)],
        ).createShader(Rect.fromCircle(center: c, radius: r * 3)),
    );
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFFFFF1C2));
  }

  void _moon(Canvas canvas, Offset c) {
    final moon = Path.combine(
      PathOperation.difference,
      Path()..addOval(Rect.fromCircle(center: c, radius: 16)),
      Path()..addOval(Rect.fromCircle(center: c + const Offset(7, -5), radius: 14)),
    );
    canvas.drawPath(moon, Paint()..color = const Color(0xFFFFF1C2));
  }

  /// Deux plans de coupoles et de minarets, en ombre chinoise translucide.
  void _skyline(Canvas canvas, Size size) {
    final w = size.width;
    final base = size.height;

    Path dome(double cx, double width, double top, double bottom) => Path()
      ..moveTo(cx - width / 2, bottom)
      ..lineTo(cx - width / 2, bottom - (bottom - top) * 0.25)
      ..cubicTo(
        cx - width / 2,
        top + (bottom - top) * 0.25,
        cx - width * 0.1,
        top + (bottom - top) * 0.15,
        cx,
        top,
      )
      ..cubicTo(
        cx + width * 0.1,
        top + (bottom - top) * 0.15,
        cx + width / 2,
        top + (bottom - top) * 0.25,
        cx + width / 2,
        bottom - (bottom - top) * 0.25,
      )
      ..lineTo(cx + width / 2, bottom)
      ..close();

    Path minaret(double cx, double width, double top) => Path()
      ..addRect(Rect.fromLTRB(cx - width / 2, top, cx + width / 2, base))
      ..addPolygon([
        Offset(cx - width / 2 - 1, top),
        Offset(cx, top - width * 1.6),
        Offset(cx + width / 2 + 1, top),
      ], true);

    final far = Path()
      ..addPath(dome(w * 0.72, 70, base - 58, base - 18), Offset.zero)
      ..addRect(Rect.fromLTRB(w * 0.72 - 45, base - 22, w * 0.72 + 45, base))
      ..addPath(minaret(w * 0.72 - 52, 7, base - 70), Offset.zero)
      ..addPath(minaret(w * 0.72 + 52, 7, base - 70), Offset.zero)
      ..addPath(dome(w * 0.93, 34, base - 36, base - 12), Offset.zero)
      ..addRect(Rect.fromLTRB(w * 0.93 - 22, base - 14, w * 0.93 + 22, base));
    canvas.drawPath(far, Paint()..color = Colors.black.withValues(alpha: 0.13));

    final near = Path()
      ..addPath(dome(w * 0.2, 86, base - 74, base - 22), Offset.zero)
      ..addRect(Rect.fromLTRB(w * 0.2 - 60, base - 26, w * 0.2 + 60, base))
      ..addPath(dome(w * 0.2 - 44, 30, base - 44, base - 22), Offset.zero)
      ..addPath(dome(w * 0.2 + 44, 30, base - 44, base - 22), Offset.zero)
      ..addPath(minaret(w * 0.2 + 76, 9, base - 92), Offset.zero)
      ..addRect(Rect.fromLTRB(0, base - 10, w, base));
    canvas.drawPath(near, Paint()..color = Colors.black.withValues(alpha: 0.2));
    // Croissant au sommet de la grande coupole.
    canvas.drawLine(
      Offset(w * 0.2, base - 74),
      Offset(w * 0.2, base - 82),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_SkyPainter old) => old.period != period;
}
