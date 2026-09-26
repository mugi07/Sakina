import 'package:geomag/geomag.dart';

/// Déclinaison magnétique (degrés, positive vers l'est) selon le modèle
/// magnétique mondial WMM-2025 (NOAA), calculée hors-ligne.
double magneticDeclination(double latitude, double longitude, DateTime date) =>
    GeoMag().calculate(latitude, longitude, 0, date).dec;

/// Angle ramené entre 0 (inclus) et 360 (exclu).
double normalize360(double degrees) {
  final r = degrees % 360;
  return r < 0 ? r + 360 : r;
}

/// Angle ramené entre -180 et 180.
double normalize180(double degrees) {
  final r = normalize360(degrees);
  return r > 180 ? r - 360 : r;
}

/// Cap par rapport au nord géographique.
///
/// Android fournit un cap magnétique : on ajoute la déclinaison. iOS
/// fournit déjà le cap géographique.
double trueHeading({
  required double rawHeading,
  required bool isMagnetic,
  required double declination,
}) => normalize360(rawHeading + (isMagnetic ? declination : 0));

/// Angle à tourner pour faire face à la Qibla : positif = vers la droite
/// (sens des aiguilles d'une montre), négatif = vers la gauche.
double turnToQibla({required double qiblaBearing, required double heading}) =>
    normalize180(qiblaBearing - heading);

/// Considéré comme aligné à ±3° près (précision réaliste d'un téléphone).
bool isFacingQibla(double turn, {double tolerance = 3}) => turn.abs() <= tolerance;
