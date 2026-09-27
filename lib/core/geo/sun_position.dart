import 'dart:math' as math;

/// Position du soleil vue d'un lieu : azimut (degrés depuis le nord
/// géographique, sens des aiguilles d'une montre) et hauteur au-dessus de
/// l'horizon (degrés, négative quand il est couché).
typedef SunPosition = ({double azimuth, double elevation});

/// Latitude et longitude de la Kaaba (mêmes valeurs que le calcul de la Qibla).
const kaabaLatitude = 21.4225;
const kaabaLongitude = 39.8262;

double _rad(double deg) => deg * math.pi / 180;
double _deg(double rad) => rad * 180 / math.pi;

/// Déclinaison du soleil (degrés) et équation du temps (minutes) à l'instant
/// [utc], selon les formules de la NOAA (précision de l'ordre de la minute
/// d'arc, sans réfraction).
({double declination, double equationOfTime}) _solar(DateTime utc) {
  final julianDay = utc.millisecondsSinceEpoch / 86400000 + 2440587.5;
  final t = (julianDay - 2451545) / 36525;
  final l0 = (280.46646 + t * (36000.76983 + t * 0.0003032)) % 360;
  final m = 357.52911 + t * (35999.05029 - 0.0001537 * t);
  final e = 0.016708634 - t * (0.000042037 + 0.0000001267 * t);
  final center =
      math.sin(_rad(m)) * (1.914602 - t * (0.004817 + 0.000014 * t)) +
      math.sin(_rad(2 * m)) * (0.019993 - 0.000101 * t) +
      math.sin(_rad(3 * m)) * 0.000289;
  final omega = 125.04 - 1934.136 * t;
  final lambda = l0 + center - 0.00569 - 0.00478 * math.sin(_rad(omega));
  final obliquity =
      23 +
      (26 + (21.448 - t * (46.815 + t * (0.00059 - t * 0.001813))) / 60) / 60 +
      0.00256 * math.cos(_rad(omega));
  final declination = _deg(math.asin(math.sin(_rad(obliquity)) * math.sin(_rad(lambda))));
  final y = math.pow(math.tan(_rad(obliquity / 2)), 2).toDouble();
  final equationOfTime =
      4 *
      _deg(
        y * math.sin(2 * _rad(l0)) -
            2 * e * math.sin(_rad(m)) +
            4 * e * y * math.sin(_rad(m)) * math.cos(2 * _rad(l0)) -
            0.5 * y * y * math.sin(4 * _rad(l0)) -
            1.25 * e * e * math.sin(2 * _rad(m)),
      );
  return (declination: declination, equationOfTime: equationOfTime);
}

/// Position du soleil à l'instant [time] pour un observateur situé en
/// ([latitude], [longitude]).
SunPosition sunPosition(double latitude, double longitude, DateTime time) {
  final utc = time.toUtc();
  final (:declination, :equationOfTime) = _solar(utc);
  final minutes = utc.hour * 60 + utc.minute + utc.second / 60 + utc.millisecond / 60000;
  final trueSolarTime = (minutes + equationOfTime + 4 * longitude) % 1440;
  final hourAngle = _rad(trueSolarTime / 4 - 180);
  final lat = _rad(latitude);
  final dec = _rad(declination);
  final cosZenith =
      math.sin(lat) * math.sin(dec) + math.cos(lat) * math.cos(dec) * math.cos(hourAngle);
  final elevation = 90 - _deg(math.acos(cosZenith.clamp(-1.0, 1.0)));
  final azimuth =
      (_deg(
            math.atan2(
              math.sin(hourAngle),
              math.cos(hourAngle) * math.sin(lat) - math.tan(dec) * math.cos(lat),
            ),
          ) +
          180) %
      360;
  return (azimuth: azimuth, elevation: elevation);
}

/// Midi solaire (passage du soleil au méridien) en [longitude], le jour
/// civil UTC [day].
DateTime solarNoonUtc(DateTime day, double longitude) {
  final midnight = DateTime.utc(day.year, day.month, day.day);
  // Deux passes : l'équation du temps dépend (un peu) de l'instant.
  var noon = midnight.add(const Duration(hours: 12));
  for (var i = 0; i < 2; i++) {
    final minutes = 720 - 4 * longitude - _solar(noon).equationOfTime;
    noon = midnight.add(Duration(milliseconds: (minutes * 60000).round()));
  }
  return noon;
}

/// Prochain passage du soleil au zénith de la Kaaba après [after] (vers le
/// 27-28 mai et le 15-16 juillet, vers midi heure de La Mecque). À cet
/// instant, partout où le soleil est levé, il se trouve exactement dans la
/// direction de la Qibla.
DateTime nextKaabaTransit(DateTime after) {
  final start = after.toUtc();
  for (var year = start.year; ; year++) {
    // Le soleil monte vers le tropique (mai) puis redescend (juillet).
    for (final (from, to) in [(DateTime.utc(year, 5, 15), 30), (DateTime.utc(year, 7, 3), 30)]) {
      DateTime? best;
      var bestGap = double.infinity;
      for (var d = 0; d < to; d++) {
        final noon = solarNoonUtc(from.add(Duration(days: d)), kaabaLongitude);
        final gap = (_solar(noon).declination - kaabaLatitude).abs();
        if (gap < bestGap) {
          bestGap = gap;
          best = noon;
        }
      }
      if (best!.isAfter(start)) return best;
    }
  }
}

/// Premier instant, à partir de [from], où le soleil dépasse [elevation]
/// degrés (au pas de 2 minutes) ; null s'il ne se lève pas dans les
/// 48 heures (nuit polaire).
DateTime? nextSunAbove(double latitude, double longitude, DateTime from, {double elevation = 0}) {
  for (var m = 0; m <= 48 * 60; m += 2) {
    final t = from.add(Duration(minutes: m));
    if (sunPosition(latitude, longitude, t).elevation >= elevation) return t;
  }
  return null;
}
