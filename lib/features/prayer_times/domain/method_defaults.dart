import 'package:adhan_dart/adhan_dart.dart';

/// Méthode de calcul proposée par défaut selon le pays (code ISO alpha-2).
/// L'utilisateur peut toujours la changer dans les réglages.
CalculationMethod defaultMethodForCountry(String countryCode) =>
    switch (countryCode.toUpperCase()) {
      'MA' => CalculationMethod.morocco,
      'DZ' => CalculationMethod.algerian,
      'TN' => CalculationMethod.tunisia,
      'FR' => CalculationMethod.france,
      'SA' || 'YE' => CalculationMethod.ummAlQura,
      'EG' || 'SD' || 'LY' => CalculationMethod.egyptian,
      'TR' => CalculationMethod.turkiye,
      'US' || 'CA' => CalculationMethod.northAmerica,
      'PK' || 'IN' || 'BD' || 'AF' => CalculationMethod.karachi,
      'AE' => CalculationMethod.dubai,
      'QA' => CalculationMethod.qatar,
      'KW' => CalculationMethod.kuwait,
      'BH' || 'OM' => CalculationMethod.gulfRegion,
      'JO' => CalculationMethod.jordan,
      'ID' => CalculationMethod.indonesian,
      'SG' || 'MY' || 'BN' => CalculationMethod.singapore,
      'IR' => CalculationMethod.tehran,
      'RU' => CalculationMethod.russia,
      'PT' => CalculationMethod.portugal,
      _ => CalculationMethod.muslimWorldLeague,
    };

/// Pays où l'Asr est majoritairement calculé selon l'école hanafite.
const _hanafiCountries = {
  'TR',
  'PK',
  'IN',
  'BD',
  'AF',
  'KZ',
  'UZ',
  'TJ',
  'KG',
  'TM',
  'RU',
  'BA',
  'AL',
  'XK',
};

Madhab defaultMadhabForCountry(String countryCode) =>
    _hanafiCountries.contains(countryCode.toUpperCase()) ? Madhab.hanafi : Madhab.shafi;

/// Méthodes proposées dans les réglages (« other » exige des angles saisis
/// à la main, prévu plus tard).
final selectableMethods = CalculationMethod.values
    .where((m) => m != CalculationMethod.other)
    .toList(growable: false);

CalculationParameters parametersFor(CalculationMethod method) => switch (method) {
  CalculationMethod.algerian => CalculationMethodParameters.algerian(),
  CalculationMethod.dubai => CalculationMethodParameters.dubai(),
  CalculationMethod.egyptian => CalculationMethodParameters.egyptian(),
  CalculationMethod.france => CalculationMethodParameters.france(),
  CalculationMethod.gulfRegion => CalculationMethodParameters.gulfRegion(),
  CalculationMethod.indonesian => CalculationMethodParameters.indonesian(),
  CalculationMethod.jafari => CalculationMethodParameters.jafari(),
  CalculationMethod.jordan => CalculationMethodParameters.jordan(),
  CalculationMethod.karachi => CalculationMethodParameters.karachi(),
  CalculationMethod.kuwait => CalculationMethodParameters.kuwait(),
  CalculationMethod.moonsightingCommittee => CalculationMethodParameters.moonsightingCommittee(),
  CalculationMethod.morocco => CalculationMethodParameters.morocco(),
  CalculationMethod.muslimWorldLeague => CalculationMethodParameters.muslimWorldLeague(),
  CalculationMethod.northAmerica => CalculationMethodParameters.northAmerica(),
  CalculationMethod.other => CalculationMethodParameters.other(),
  CalculationMethod.portugal => CalculationMethodParameters.portugal(),
  CalculationMethod.qatar => CalculationMethodParameters.qatar(),
  CalculationMethod.russia => CalculationMethodParameters.russia(),
  CalculationMethod.singapore => CalculationMethodParameters.singapore(),
  CalculationMethod.tehran => CalculationMethodParameters.tehran(),
  CalculationMethod.tunisia => CalculationMethodParameters.tunisia(),
  CalculationMethod.turkiye => CalculationMethodParameters.turkiye(),
  CalculationMethod.ummAlQura => CalculationMethodParameters.ummAlQura(),
};
