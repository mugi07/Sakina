import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

/// Compare le Coran de content.sqlite à des valeurs de référence connues
/// (mushaf de Médine, numérotation de Koufa), indépendantes du pipeline.
void main() {
  late Database db;

  setUpAll(() => db = sqlite3.open('assets/db/content.sqlite', mode: OpenMode.readOnly));
  tearDownAll(() => db.close());

  List<Object?> column(String sql) => [for (final r in db.select(sql)) r.values.first];
  List<(int, int)> refs(String sql) => [
    for (final r in db.select(sql)) (r['surah'] as int, r['number'] as int),
  ];

  test('nombre de versets de chacune des 114 sourates', () {
    const counts = [
      7, 286, 200, 176, 120, 165, 206, 75, 129, 109, 123, 111, 43, 52, 99, 128, 111, 110, 98, //
      135, 112, 78, 118, 64, 77, 227, 93, 88, 69, 60, 34, 30, 73, 54, 45, 83, 182, 88, 75, 85, //
      54, 53, 89, 59, 37, 35, 38, 29, 18, 45, 60, 49, 62, 55, 78, 96, 29, 22, 24, 13, 14, 11, //
      11, 18, 12, 12, 30, 52, 52, 44, 28, 28, 20, 56, 40, 31, 50, 40, 46, 42, 29, 19, 36, 25, //
      22, 17, 19, 26, 30, 20, 15, 21, 11, 8, 8, 19, 5, 8, 8, 11, 11, 8, 3, 9, 5, 4, 7, 3, 6, //
      3, 5, 4, 5, 6,
    ];
    expect(column('SELECT ayah_count FROM surahs ORDER BY id'), counts);
    expect(column('SELECT count(*) FROM ayahs GROUP BY surah ORDER BY surah'), counts);
  });

  test('début des 30 juz', () {
    expect(
      refs(
        'SELECT surah, number FROM ayahs a WHERE juz != '
        'coalesce((SELECT juz FROM ayahs b WHERE b.id = a.id - 1), 0) ORDER BY id',
      ),
      const [
        (1, 1), (2, 142), (2, 253), (3, 93), (4, 24), (4, 148), (5, 82), (6, 111), (7, 88), //
        (8, 41), (9, 93), (11, 6), (12, 53), (15, 1), (17, 1), (18, 75), (21, 1), (23, 1), //
        (25, 21), (27, 56), (29, 46), (33, 31), (36, 28), (39, 32), (41, 47), (46, 1), //
        (51, 31), (58, 1), (67, 1), (78, 1),
      ],
    );
  });

  test('les 15 versets de prosternation', () {
    expect(refs('SELECT surah, number FROM ayahs WHERE sajda IS NOT NULL ORDER BY id'), const [
      (7, 206), (13, 15), (16, 50), (17, 109), (19, 58), (22, 18), (22, 77), (25, 60), //
      (27, 26), (32, 15), (38, 24), (41, 38), (53, 62), (84, 21), (96, 19),
    ]);
  });

  test('page de début de chaque sourate (mushaf de Médine, 604 pages)', () {
    const pages = [
      1, 2, 50, 77, 106, 128, 151, 177, 187, 208, 221, 235, 249, 255, 262, 267, 282, 293, //
      305, 312, 322, 332, 342, 350, 359, 367, 377, 385, 396, 404, 411, 415, 418, 428, 434, //
      440, 446, 453, 458, 467, 477, 483, 489, 496, 499, 502, 507, 511, 515, 518, 520, 523, //
      526, 528, 531, 534, 537, 542, 545, 549, 551, 553, 554, 556, 558, 560, 562, 564, 566, //
      568, 570, 572, 574, 575, 577, 578, 580, 582, 583, 585, 586, 587, 587, 589, 590, 591, //
      591, 592, 593, 594, 595, 595, 596, 596, 597, 597, 598, 598, 599, 599, 600, 600, 601, //
      601, 601, 602, 602, 602, 603, 603, 603, 604, 604, 604,
    ];
    expect(column('SELECT page FROM ayahs WHERE number = 1 ORDER BY surah'), pages);
    // Pages et quarts de hizb croissants, sans saut.
    for (final col in ['page', 'hizb_quarter']) {
      final values = column('SELECT $col FROM ayahs ORDER BY id').cast<int>();
      for (var i = 1; i < values.length; i++) {
        expect(values[i] - values[i - 1], inInclusiveRange(0, 1), reason: '$col, verset ${i + 1}');
      }
    }
  });

  test('aucun texte ni traduction vide', () {
    expect(column("SELECT count(*) FROM ayahs WHERE trim(text_uthmani) = ''").single, 0);
    expect(column("SELECT count(*) FROM ayah_translations WHERE trim(content) = ''").single, 0);
  });
}
