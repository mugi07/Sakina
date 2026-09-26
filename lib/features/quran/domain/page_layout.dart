import '../../../core/database/content_database.dart';
import 'quran_text.dart';

/// Nombre de pages du mushaf de Médine.
const mushafPageCount = 604;

/// Bloc d'une page du mushaf : un en-tête de sourate, ou une suite de
/// versets consécutifs d'une même sourate (affichée en un seul paragraphe).
sealed class PageBlock {
  const PageBlock();
}

class SurahHeaderBlock extends PageBlock {
  const SurahHeaderBlock(this.surah);

  final int surah;

  bool get showsBasmala => showsBasmalaHeader(surah);
}

class AyahRunBlock extends PageBlock {
  const AyahRunBlock(this.rows);

  final List<AyahsOfPageResult> rows;
}

/// Découpe les versets d'une page : un en-tête avant chaque début de
/// sourate, puis les versets à la suite.
List<PageBlock> buildPageBlocks(List<AyahsOfPageResult> rows) {
  final blocks = <PageBlock>[];
  var run = <AyahsOfPageResult>[];
  for (final row in rows) {
    if (row.a.number == 1) {
      if (run.isNotEmpty) blocks.add(AyahRunBlock(run));
      run = [];
      blocks.add(SurahHeaderBlock(row.a.surah));
    }
    run.add(row);
  }
  if (run.isNotEmpty) blocks.add(AyahRunBlock(run));
  return blocks;
}

/// Numéro du hizb (1..60) à partir du quart de hizb (1..240).
int hizbOfQuarter(int quarter) => (quarter + 3) ~/ 4;
