import 'package:flutter_test/flutter_test.dart';
import 'package:sakina/features/qibla/domain/qibla_compass.dart';

void main() {
  group('déclinaison magnétique (valeurs de test officielles WMM2025, NOAA)', () {
    // Date, latitude, longitude, déclinaison attendue (degrés), altitude 0 km.
    final cases = [
      (DateTime.utc(2025), 80.0, 0.0, 1.28),
      (DateTime.utc(2025), 0.0, 120.0, -0.16),
      (DateTime.utc(2025), -80.0, 240.0, 68.78),
      (DateTime.utc(2027, 7, 2, 12), 80.0, 0.0, 2.59),
      (DateTime.utc(2027, 7, 2, 12), 0.0, 120.0, -0.24),
      (DateTime.utc(2027, 7, 2, 12), -80.0, 240.0, 68.49),
    ];
    for (final (date, lat, lng, expected) in cases) {
      test('$lat°, $lng° en ${date.year}', () {
        expect(magneticDeclination(lat, lng, date), closeTo(expected, 0.25));
      });
    }
  });

  group('normalisation des angles', () {
    test('0..360', () {
      expect(normalize360(-10), 350);
      expect(normalize360(370), 10);
      expect(normalize360(360), 0);
    });
    test('-180..180', () {
      expect(normalize180(190), -170);
      expect(normalize180(-190), 170);
      expect(normalize180(45), 45);
    });
  });

  group('cap et direction à suivre', () {
    test('Android : cap magnétique corrigé de la déclinaison', () {
      expect(trueHeading(rawHeading: 358, isMagnetic: true, declination: 3), closeTo(1, 1e-9));
      expect(trueHeading(rawHeading: 10, isMagnetic: true, declination: -12.5), 357.5);
    });

    test('iOS : cap déjà géographique, pas de correction', () {
      expect(trueHeading(rawHeading: 120, isMagnetic: false, declination: 3), 120);
    });

    test('tourner à droite, à gauche, ou aligné', () {
      // Casablanca : Qibla ≈ 93,7°.
      expect(turnToQibla(qiblaBearing: 93.7, heading: 0), closeTo(93.7, 1e-9));
      expect(turnToQibla(qiblaBearing: 93.7, heading: 180), closeTo(-86.3, 1e-9));
      expect(turnToQibla(qiblaBearing: 10, heading: 350), closeTo(20, 1e-9));
      expect(isFacingQibla(turnToQibla(qiblaBearing: 93.7, heading: 95)), isTrue);
      expect(isFacingQibla(turnToQibla(qiblaBearing: 93.7, heading: 100)), isFalse);
    });
  });
}
