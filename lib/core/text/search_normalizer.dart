/// Normalisation de texte pour la recherche (arabe et latin).
///
/// Dart pur, sans dépendance à Flutter : ce fichier est aussi utilisé par
/// tool/content_pipeline pour construire les colonnes de recherche. Toute
/// modification ici impose de reconstruire content.sqlite.
library;

/// Supprime les signes diacritiques arabes et unifie les variantes de lettres,
/// pour que « الصَّلاة », « الصلاة » et « ٱلصلاة » donnent le même résultat.
String normalizeArabic(String input, {bool unifyTaMarbuta = true}) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    if (_isArabicMark(rune)) continue;
    buffer.writeCharCode(
      _arabicLetterMap[rune] ?? (unifyTaMarbuta && rune == 0x0629 ? 0x0647 : rune),
    );
  }
  return buffer.toString();
}

/// Minuscules et suppression des accents latins (« Fès » → « fes »).
String foldLatin(String input) {
  final buffer = StringBuffer();
  for (final char in input.toLowerCase().split('')) {
    buffer.write(_latinFoldMap[char] ?? char);
  }
  return buffer.toString();
}

/// Normalisation complète pour une clé ou une requête de recherche :
/// arabe + latin, ponctuation retirée, espaces compactés.
String normalizeForSearch(String input) {
  final folded = foldLatin(normalizeArabic(input));
  final cleaned = folded.replaceAll(_nonSearchable, ' ');
  return cleaned.replaceAll(_spaces, ' ').trim();
}

final _nonSearchable = RegExp(r'[^\p{L}\p{N} ]', unicode: true);
final _spaces = RegExp(r'\s+');

bool _isArabicMark(int rune) =>
    (rune >= 0x0610 && rune <= 0x061A) || // signes honorifiques, petites lettres
    (rune >= 0x064B && rune <= 0x065F) || // harakat, tanwin, shadda, soukoun…
    rune == 0x0670 || // alif suscrit
    (rune >= 0x06D6 && rune <= 0x06ED) || // signes coraniques
    (rune >= 0x08D3 && rune <= 0x08FF) || // signes coraniques étendus
    rune == 0x0640; // tatwil

const _arabicLetterMap = <int, int>{
  0x0622: 0x0627, // آ → ا
  0x0623: 0x0627, // أ → ا
  0x0625: 0x0627, // إ → ا
  0x0671: 0x0627, // ٱ → ا
  0x0672: 0x0627, // ٲ → ا
  0x0673: 0x0627, // ٳ → ا
  0x0649: 0x064A, // ى → ي
  0x06CC: 0x064A, // ی (persan) → ي
  0x06A9: 0x0643, // ک (persan) → ك
};

const _latinFoldMap = <String, String>{
  'à': 'a',
  'á': 'a',
  'â': 'a',
  'ã': 'a',
  'ä': 'a',
  'å': 'a',
  'ā': 'a',
  'ç': 'c',
  'č': 'c',
  'è': 'e',
  'é': 'e',
  'ê': 'e',
  'ë': 'e',
  'ē': 'e',
  'ì': 'i',
  'í': 'i',
  'î': 'i',
  'ï': 'i',
  'ī': 'i',
  'ı': 'i',
  'ñ': 'n',
  'ò': 'o',
  'ó': 'o',
  'ô': 'o',
  'õ': 'o',
  'ö': 'o',
  'ø': 'o',
  'ō': 'o',
  'ù': 'u',
  'ú': 'u',
  'û': 'u',
  'ü': 'u',
  'ū': 'u',
  'ý': 'y',
  'ÿ': 'y',
  'ş': 's',
  'š': 's',
  'ș': 's',
  'ğ': 'g',
  'ž': 'z',
  'ţ': 't',
  'ț': 't',
  'œ': 'oe',
  'æ': 'ae',
  'ß': 'ss',
  'ʿ': '',
  'ʾ': '',
  '’': '',
  "'": '',
};
