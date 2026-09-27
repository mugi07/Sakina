import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/geo/sun_position.dart';
import '../../../core/providers.dart';

/// Hauteur minimale du soleil pour s'en servir comme repère, et hauteur
/// au-delà de laquelle sa direction devient trop imprécise.
const sunGuideMinElevation = 1.0;
const sunGuideMaxElevation = 70.0;

/// Le soleil comme repère pour trouver la Qibla sans boussole :
/// - [sun] : sa position actuelle ;
/// - [nextSunrise] : quand il sera de nouveau utilisable (null s'il l'est) ;
/// - [kaabaTransit] : prochain passage au zénith de la Kaaba, s'il est
///   visible depuis le lieu (null sinon).
typedef SunGuide = ({SunPosition sun, DateTime? nextSunrise, DateTime? kaabaTransit});

/// L'heure à la minute près : les calculs du soleil ne sont refaits qu'une
/// fois par minute, même si la boussole redessine l'écran en continu.
final _minuteProvider = Provider<DateTime>((ref) {
  final now = ref.watch(clockProvider).value ?? DateTime.now();
  return DateTime(now.year, now.month, now.day, now.hour, now.minute);
});

final sunGuideProvider = Provider<SunGuide?>((ref) {
  final location = ref.watch(settingsProvider.select((s) => s.location));
  if (location == null) return null;
  final now = ref.watch(_minuteProvider);
  final (lat, lng) = (location.latitude, location.longitude);
  final sun = sunPosition(lat, lng, now);
  final transit = nextKaabaTransit(now);
  return (
    sun: sun,
    nextSunrise: sun.elevation >= sunGuideMinElevation
        ? null
        : nextSunAbove(lat, lng, now, elevation: sunGuideMinElevation),
    kaabaTransit: sunPosition(lat, lng, transit).elevation > 5 ? transit : null,
  );
});
