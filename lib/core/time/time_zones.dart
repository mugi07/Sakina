import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Charge la base des fuseaux horaires (IANA) embarquée par le paquet
/// timezone, puis y applique les changements officiels plus récents.
void initTimeZones() {
  tzdata.initializeTimeZones();
  _moroccoBackToGmt();
}

/// Instant du retour du Maroc à GMT : 20 septembre 2026 à 02:00 (+01),
/// soit 01:00 UTC.
final moroccoGmtSince = DateTime.utc(2026, 9, 20, 1);

/// Maroc (et Sahara occidental) : retour définitif à GMT, sans heure d'été
/// ni changement pendant le Ramadan (décret n° 2.26.530, IANA tzdata 2026c).
///
/// Le paquet timezone 0.11.1 embarque tzdata 2025c, qui prévoit encore +01
/// avec un retour à GMT pendant le Ramadan. On garde l'historique jusqu'au
/// 20 septembre 2026 et on passe ensuite à +00 pour de bon. Sans effet si
/// une version plus récente du paquet contient déjà ce changement.
void _moroccoBackToGmt() {
  final switchAt = moroccoGmtSince.millisecondsSinceEpoch;
  for (final name in const ['Africa/Casablanca', 'Africa/El_Aaiun']) {
    final tz.Location old;
    try {
      old = tz.getLocation(name);
    } on tz.LocationNotFoundException {
      continue;
    }
    final upToDate =
        old.timeZone(switchAt).offset == Duration.zero &&
        old.transitionAt.every((t) => t <= switchAt);
    if (upToDate) continue;
    final kept = [
      for (var i = 0; i < old.transitionAt.length; i++)
        if (old.transitionAt[i] < switchAt) i,
    ];
    tz.timeZoneDatabase.add(
      tz.Location(
        name,
        [for (final i in kept) old.transitionAt[i], switchAt],
        [for (final i in kept) old.transitionZone[i], old.zones.length],
        [...old.zones, const tz.TimeZone(Duration.zero, isDst: false, abbreviation: '+00')],
      ),
    );
  }
}
