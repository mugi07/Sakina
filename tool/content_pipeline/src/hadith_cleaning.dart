/// Nettoyage des textes de hadith-api, qui reprennent parfois des restes de
/// pages web :
/// - balises HTML (`<br>` dans an-Nawawi et les hadiths qudsi) ;
/// - Muwatta en français : titre du chapitre ou du livre suivant collé en fin
///   de texte (« … Chapitre II Le moment de la prière du Vendredi »,
///   « … MOUATTAA Livre 2 La pureté rituelle … »), et même un script
///   JavaScript entier ; formule de salutation doublée par une lettre
///   isolée (« (salallahou alayhi wa salam) r (Sur lui la grâce et la paix
///   d'Allah) »).
String cleanHadithText(String text) {
  var s = text
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&quot;', '"')
      .replaceAll('&amp;', '&');
  // En-tête de livre (et script) collé à la fin : tout couper.
  final book = RegExp(r'\s*(MOUATTA|// Author:)').firstMatch(s);
  if (book != null) s = s.substring(0, book.start);
  // Titre du chapitre suivant collé à la fin.
  final chapter = RegExp(r'\s+Chapitre (?:[IVXLC]+|premier)\b').firstMatch(s);
  if (chapter != null) s = s.substring(0, chapter.start);
  s = s.replaceAll(RegExp(r'\) r \(Sur lui[^)]*\)'), ')');
  return s.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).join('\n');
}
