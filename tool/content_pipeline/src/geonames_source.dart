import 'dart:io';

import 'package:sakina/core/text/search_normalizer.dart';
import 'package:sqlite3/sqlite3.dart';

import 'downloads.dart';

const _geonames = 'https://download.geonames.org/export/dump';

class _City {
  _City(this.id, this.name, this.countryCode, this.lat, this.lng, this.timezone, this.population);

  final int id;
  final String name;
  final String countryCode;
  final double lat;
  final double lng;
  final String timezone;
  final int population;
}

class _Country {
  _Country(this.code, this.nameEn, this.geonameId);

  final String code;
  final String nameEn;
  final int geonameId;
}

/// Meilleur nom trouvé pour une langue, avec son score de préférence.
class _BestName {
  _BestName(this.name, this.score);

  final String name;
  final int score;
}

/// Construit les tables countries et cities (villes de plus de 15 000 habitants),
/// avec les noms français et arabes tirés de alternateNamesV2.
Future<({int cities, int countries})> buildCities(SourceCache cache, Database db) async {
  final citiesZip = await cache.fetch('$_geonames/cities15000.zip', 'geonames-cities15000.zip');
  final countryInfo = await cache.fetch('$_geonames/countryInfo.txt', 'geonames-countryInfo.txt');
  final altNamesZip = await cache.fetch(
    '$_geonames/alternateNamesV2.zip',
    'geonames-alternateNamesV2.zip',
  );

  final countries = <String, _Country>{};
  for (final line in countryInfo.readAsLinesSync()) {
    if (line.startsWith('#') || line.trim().isEmpty) continue;
    final f = line.split('\t');
    countries[f[0]] = _Country(f[0], f[4], int.parse(f[16]));
  }

  final cities = <_City>[];
  await for (final line in zipEntryLines(citiesZip, 'cities15000.txt')) {
    if (line.isEmpty) continue;
    final f = line.split('\t');
    if (!countries.containsKey(f[8]) || f[17].isEmpty) continue;
    cities.add(
      _City(
        int.parse(f[0]),
        f[1],
        f[8],
        double.parse(f[4]),
        double.parse(f[5]),
        f[17],
        int.tryParse(f[14]) ?? 0,
      ),
    );
  }

  stdout.writeln('  … lecture des noms alternatifs (fr, ar)');
  final wanted = {for (final c in cities) c.id, for (final c in countries.values) c.geonameId};
  final countryIds = {for (final c in countries.values) c.geonameId};
  final names = <(int, String), _BestName>{};
  await for (final line in zipEntryLines(altNamesZip, 'alternateNamesV2.txt')) {
    // alternateNameId, geonameid, isolanguage, name, isPreferred, isShort,
    // isColloquial, isHistoric, from, to
    final f = line.split('\t');
    if (f.length < 8) continue;
    final lang = f[2];
    if (lang != 'fr' && lang != 'ar') continue;
    final id = int.parse(f[1]);
    if (!wanted.contains(id)) continue;
    if (f[6] == '1' || f[7] == '1') continue; // familier ou historique
    final isCountry = countryIds.contains(id);
    final score = (f[4] == '1' ? 2 : 0) + (isCountry && f[5] == '1' ? 1 : 0);
    final key = (id, lang);
    final previous = names[key];
    if (previous == null || score > previous.score) {
      names[key] = _BestName(f[3], score);
    }
  }

  final insertCountry = db.prepare('INSERT INTO countries VALUES (?, ?, ?, ?)');
  for (final c in countries.values) {
    insertCountry.execute([
      c.code,
      c.nameEn,
      names[(c.geonameId, 'fr')]?.name,
      names[(c.geonameId, 'ar')]?.name,
    ]);
  }
  insertCountry.close();

  final insertCity = db.prepare('INSERT INTO cities VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');
  for (final c in cities) {
    final fr = names[(c.id, 'fr')]?.name;
    final ar = names[(c.id, 'ar')]?.name;
    final searchKey = {
      for (final n in [c.name, ?fr, ?ar]) normalizeForSearch(n),
    }.join(' ');
    insertCity.execute([
      c.id,
      c.name,
      fr == c.name ? null : fr,
      ar,
      c.countryCode,
      c.lat,
      c.lng,
      c.timezone,
      c.population,
      searchKey,
    ]);
  }
  insertCity.close();

  return (cities: cities.length, countries: countries.length);
}
