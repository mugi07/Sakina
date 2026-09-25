/// Lieu utilisé pour les horaires de prière et la Qibla.
///
/// Les noms sont copiés depuis la base des villes pour pouvoir être affichés
/// sans requête. [name] vaut null pour une position GPS sans ville proche.
class SavedLocation {
  const SavedLocation({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.countryCode,
    this.name,
    this.nameFr,
    this.nameAr,
    this.countryNameEn,
    this.countryNameFr,
    this.countryNameAr,
    this.fromGps = false,
  });

  factory SavedLocation.fromJson(Map<String, dynamic> json) => SavedLocation(
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    timezone: json['timezone'] as String,
    countryCode: json['countryCode'] as String,
    name: json['name'] as String?,
    nameFr: json['nameFr'] as String?,
    nameAr: json['nameAr'] as String?,
    countryNameEn: json['countryNameEn'] as String?,
    countryNameFr: json['countryNameFr'] as String?,
    countryNameAr: json['countryNameAr'] as String?,
    fromGps: json['fromGps'] as bool? ?? false,
  );

  final double latitude;
  final double longitude;
  final String timezone;

  /// Code ISO 3166-1 alpha-2 (« MA », « FR »…), vide si inconnu.
  final String countryCode;
  final String? name;
  final String? nameFr;
  final String? nameAr;
  final String? countryNameEn;
  final String? countryNameFr;
  final String? countryNameAr;
  final bool fromGps;

  /// Nom de la ville dans la langue demandée, ou null s'il n'y en a pas.
  String? cityName(String languageCode) => switch (languageCode) {
    'ar' => nameAr ?? name,
    'fr' => nameFr ?? name,
    _ => name,
  };

  String? countryName(String languageCode) => switch (languageCode) {
    'ar' => countryNameAr ?? countryNameEn,
    'fr' => countryNameFr ?? countryNameEn,
    _ => countryNameEn,
  };

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'timezone': timezone,
    'countryCode': countryCode,
    'name': name,
    'nameFr': nameFr,
    'nameAr': nameAr,
    'countryNameEn': countryNameEn,
    'countryNameFr': countryNameFr,
    'countryNameAr': countryNameAr,
    'fromGps': fromGps,
  };
}
