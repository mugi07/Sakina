import 'package:flutter_test/flutter_test.dart';
import 'package:sakina/core/geo/geo_math.dart';

void main() {
  group('direction de la Qibla', () {
    test('Paris ≈ 119°', () => expect(qiblaBearing(48.8566, 2.3522), closeTo(119.2, 0.3)));
    test('New York ≈ 58°', () => expect(qiblaBearing(40.7128, -74.0060), closeTo(58.5, 0.3)));
    test('Casablanca ≈ 94°', () => expect(qiblaBearing(33.5883, -7.6114), closeTo(93.7, 0.3)));
    test('Jakarta ≈ 295°', () => expect(qiblaBearing(-6.2088, 106.8456), closeTo(295.2, 0.3)));
    test('toujours entre 0 et 360°', () {
      for (var lat = -80.0; lat <= 80; lat += 20) {
        for (var lng = -180.0; lng < 180; lng += 30) {
          expect(qiblaBearing(lat, lng), inInclusiveRange(0, 360));
        }
      }
    });
  });

  group('distances', () {
    test('Paris → Kaaba ≈ 4 500 km', () {
      expect(distanceToKaabaKm(48.8566, 2.3522), closeTo(4500, 30));
    });
    test('Casablanca → Kaaba ≈ 4 800 km', () {
      expect(distanceToKaabaKm(33.5883, -7.6114), closeTo(4830, 30));
    });
    test('distance nulle au même point', () {
      expect(distanceKm(21.4225, 39.8262, 21.4225, 39.8262), 0);
    });
  });
}
