import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';

import '../database/content_database.dart';
import '../geo/geo_math.dart';
import '../providers.dart';
import '../text/search_normalizer.dart';
import 'saved_location.dart';

enum LocationFailure { serviceDisabled, permissionDenied, unavailable }

class LocationException implements Exception {
  const LocationException(this.failure);

  final LocationFailure failure;
}

final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(ref.watch(contentDatabaseProvider)),
);

/// Localisation hors-ligne : GPS du téléphone + base des villes embarquée.
class LocationService {
  const LocationService(this._db);

  final ContentDatabase _db;

  /// Distance maximale pour associer une position GPS à une ville connue.
  static const _maxCityDistanceKm = 50.0;

  Future<List<SavedLocation>> searchCities(String query, {int limit = 30}) async {
    final normalized = normalizeForSearch(query);
    if (normalized.length < 2) return const [];
    final rows = await _db.searchCities(pattern: '%$normalized%', limit: limit).get();
    return [for (final r in rows) _fromCity(r.c, r.co)];
  }

  Future<SavedLocation> currentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(LocationFailure.serviceDisabled);
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      throw const LocationException(LocationFailure.permissionDenied);
    }

    final Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 20),
        ),
      );
    } on Exception {
      throw const LocationException(LocationFailure.unavailable);
    }

    final nearest = await nearestCity(position.latitude, position.longitude);
    if (nearest != null && nearest.distanceKm <= _maxCityDistanceKm) {
      // Coordonnées GPS (plus précises), noms et fuseau de la ville proche.
      final city = nearest.location;
      return SavedLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        timezone: city.timezone,
        countryCode: city.countryCode,
        name: city.name,
        nameFr: city.nameFr,
        nameAr: city.nameAr,
        countryNameEn: city.countryNameEn,
        countryNameFr: city.countryNameFr,
        countryNameAr: city.countryNameAr,
        fromGps: true,
      );
    }
    final timezone = await FlutterTimezone.getLocalTimezone();
    return SavedLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      timezone: timezone.identifier,
      countryCode: nearest?.location.countryCode ?? '',
      fromGps: true,
    );
  }

  Future<({SavedLocation location, double distanceKm})?> nearestCity(
    double latitude,
    double longitude,
  ) async {
    for (final radiusDeg in const [1.0, 3.0]) {
      final lngRadius = radiusDeg / math.max(0.1, math.cos(latitude * math.pi / 180));
      final rows = await _db
          .citiesInBox(
            minLat: latitude - radiusDeg,
            maxLat: latitude + radiusDeg,
            minLng: longitude - lngRadius,
            maxLng: longitude + lngRadius,
          )
          .get();
      if (rows.isEmpty) continue;
      ({SavedLocation location, double distanceKm})? best;
      for (final r in rows) {
        final d = distanceKm(latitude, longitude, r.c.latitude, r.c.longitude);
        if (best == null || d < best.distanceKm) {
          best = (location: _fromCity(r.c, r.co), distanceKm: d);
        }
      }
      return best;
    }
    return null;
  }

  SavedLocation _fromCity(City city, Country country) => SavedLocation(
    latitude: city.latitude,
    longitude: city.longitude,
    timezone: city.timezone,
    countryCode: city.countryCode,
    name: city.name,
    nameFr: city.nameFr,
    nameAr: city.nameAr,
    countryNameEn: country.nameEn,
    countryNameFr: country.nameFr,
    countryNameAr: country.nameAr,
  );
}
