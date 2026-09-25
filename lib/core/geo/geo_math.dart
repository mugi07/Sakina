import 'dart:math' as math;

import 'package:adhan_dart/adhan_dart.dart';

const _earthRadiusKm = 6371.0088;

/// Distance orthodromique (formule de haversine), en kilomètres.
double distanceKm(double lat1, double lng1, double lat2, double lng2) {
  double rad(double deg) => deg * math.pi / 180;
  final dLat = rad(lat2 - lat1);
  final dLng = rad(lng2 - lng1);
  final a =
      math.pow(math.sin(dLat / 2), 2) +
      math.cos(rad(lat1)) * math.cos(rad(lat2)) * math.pow(math.sin(dLng / 2), 2);
  return 2 * _earthRadiusKm * math.asin(math.min(1, math.sqrt(a)));
}

/// Direction de la Qibla en degrés depuis le nord géographique (0–360),
/// dans le sens des aiguilles d'une montre.
double qiblaBearing(double latitude, double longitude) =>
    Qibla.qibla(Coordinates(latitude, longitude));

double distanceToKaabaKm(double latitude, double longitude) =>
    distanceKm(latitude, longitude, Qibla.makkah.latitude, Qibla.makkah.longitude);
