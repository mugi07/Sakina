/// Règles d'affichage du texte coranique. Le texte stocké (Tanzil) n'est
/// jamais modifié : on choisit seulement comment le présenter.
library;

const _arabicIndicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

/// Toutes les sourates commencent par la basmala, sauf At-Tawba (9).
/// Pour Al-Fatiha (1), la basmala est le premier verset lui-même.
bool showsBasmalaHeader(int surah) => surah != 1 && surah != 9;

/// Tanzil inclut la basmala au début du premier verset des sourates
/// 2 à 114 (sauf 9). On l'affiche à part, en en-tête : on retire donc ses
/// quatre premiers mots du verset 1 pour ne pas la montrer deux fois.
String ayahDisplayText({required int surah, required int number, required String text}) {
  if (number != 1 || !showsBasmalaHeader(surah)) return text;
  final words = text.split(' ');
  return words.length > 4 ? words.sublist(4).join(' ') : text;
}

String toArabicIndicDigits(int n) =>
    n.toString().split('').map((d) => _arabicIndicDigits[int.parse(d)]).join();

/// Marque de fin de verset (U+06DD) suivie du numéro, que la police
/// coranique affiche dans un médaillon.
String ayahEndMark(int number) => '\u06DD${toArabicIndicDigits(number)}';
