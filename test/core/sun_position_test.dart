import 'package:flutter_test/flutter_test.dart';
import 'package:sakina/core/geo/geo_math.dart';
import 'package:sakina/core/geo/sun_position.dart';
import 'package:sakina/features/qibla/domain/qibla_compass.dart';

void main() {
  const makkahOffset = Duration(hours: 3);

  test('passages au zénith de la Kaaba : fin mai et mi-juillet, vers midi à La Mecque', () {
    final may = nextKaabaTransit(DateTime.utc(2026));
    final makkahMay = may.add(makkahOffset);
    expect(makkahMay.month, 5);
    expect(makkahMay.day, inInclusiveRange(26, 29));
    expect(makkahMay.hour * 60 + makkahMay.minute, inInclusiveRange(12 * 60 + 15, 12 * 60 + 21));
    expect(sunPosition(kaabaLatitude, kaabaLongitude, may).elevation, greaterThan(89.5));

    final july = nextKaabaTransit(may.add(const Duration(days: 1)));
    final makkahJuly = july.add(makkahOffset);
    expect(makkahJuly.month, 7);
    expect(makkahJuly.day, inInclusiveRange(14, 17));
    expect(makkahJuly.hour * 60 + makkahJuly.minute, inInclusiveRange(12 * 60 + 24, 12 * 60 + 30));
    expect(sunPosition(kaabaLatitude, kaabaLongitude, july).elevation, greaterThan(89.5));

    // Après juillet : le passage de mai de l'année suivante.
    expect(nextKaabaTransit(july.add(const Duration(days: 1))).year, 2027);
  });

  test('au passage, le soleil est dans la direction de la Qibla', () {
    final transit = nextKaabaTransit(DateTime.utc(2026));
    for (final (lat, lng) in [(33.5883, -7.6114), (48.8566, 2.3522), (-6.2088, 106.8456)]) {
      final sun = sunPosition(lat, lng, transit);
      expect(sun.elevation, greaterThan(0));
      expect(normalize180(sun.azimuth - qiblaBearing(lat, lng)).abs(), lessThan(0.6));
    }
  });

  test('midi solaire : plein sud au nord du tropique, plein nord au sud', () {
    final casablanca = solarNoonUtc(DateTime.utc(2026, 3, 20), -7.6114);
    final noon = sunPosition(33.5883, -7.6114, casablanca);
    expect(noon.azimuth, closeTo(180, 1.5));
    // Équinoxe : hauteur à midi = 90° − latitude.
    expect(noon.elevation, closeTo(90 - 33.5883, 0.6));

    final johannesburg = solarNoonUtc(DateTime.utc(2026, 6, 21), 28.0473);
    final south = sunPosition(-26.2041, 28.0473, johannesburg);
    expect(normalize180(south.azimuth).abs(), lessThan(1.5));
    // Solstice de juin : hauteur = 90° − |latitude − 23,44°|.
    expect(south.elevation, closeTo(90 - (26.2041 + 23.44), 0.6));
  });

  test('le matin à l\'est, le soir à l\'ouest, la nuit sous l\'horizon', () {
    // Casablanca, 26 septembre 2026 (UTC+1).
    final morning = sunPosition(33.5883, -7.6114, DateTime.utc(2026, 9, 26, 7, 30));
    expect(morning.azimuth, inInclusiveRange(80, 120));
    expect(morning.elevation, greaterThan(0));
    final evening = sunPosition(33.5883, -7.6114, DateTime.utc(2026, 9, 26, 17, 30));
    expect(evening.azimuth, inInclusiveRange(240, 280));
    final night = sunPosition(33.5883, -7.6114, DateTime.utc(2026, 9, 26, 0, 30));
    expect(night.elevation, lessThan(-30));
  });

  test('prochain lever : le lendemain matin, rien pendant la nuit polaire', () {
    // Lever à Casablanca le 27 septembre : 06:22 UTC selon adhan_dart (06:19
    // affiché, ajustement marocain de −3 min compris), bord supérieur du
    // disque à −0,833° (réfraction).
    final sunrise = nextSunAbove(
      33.5883,
      -7.6114,
      DateTime.utc(2026, 9, 26, 20),
      elevation: -0.833,
    )!;
    expect(
      sunrise.difference(DateTime.utc(2026, 9, 27, 6, 22)).inMinutes.abs(),
      lessThanOrEqualTo(2),
    );
    // Tromsø (69,6° N) fin décembre : le soleil ne se lève pas.
    expect(nextSunAbove(69.6492, 18.9553, DateTime.utc(2026, 12, 20)), isNull);
  });
}
