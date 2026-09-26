import 'quran_text.dart';

/// Récitateurs disponibles sur EveryAyah (un fichier MP3 par verset).
enum Reciter {
  alafasy('Alafasy_128kbps', 'مشاري العفاسي', 'Mishary Alafasy'),
  husary('Husary_128kbps', 'محمود خليل الحصري', 'Mahmoud Khalil Al-Husary'),
  abdulBasit('Abdul_Basit_Murattal_192kbps', 'عبد الباسط عبد الصمد', 'Abdul Basit Abdus-Samad'),
  minshawi('Minshawy_Murattal_128kbps', 'محمد صديق المنشاوي', 'Mohamed Siddiq Al-Minshawi'),
  sudais('Abdurrahmaan_As-Sudais_192kbps', 'عبد الرحمن السديس', 'Abdurrahman As-Sudais'),
  shuraim('Saood_ash-Shuraym_128kbps', 'سعود الشريم', 'Saud Ash-Shuraim'),
  muaiqly('Maher_AlMuaiqly_64kbps', 'ماهر المعيقلي', 'Maher Al-Muaiqly'),
  ghamdi('Ghamadi_40kbps', 'سعد الغامدي', 'Saad Al-Ghamdi');

  const Reciter(this.folder, this.nameAr, this.nameLatin);

  /// Dossier du récitateur sur everyayah.com.
  final String folder;
  final String nameAr;
  final String nameLatin;

  String displayName(String languageCode) => languageCode == 'ar' ? nameAr : nameLatin;
}

/// Nom de fichier EveryAyah : sourate et verset sur 3 chiffres (002255.mp3).
String ayahAudioFile(int surah, int number) =>
    '${surah.toString().padLeft(3, '0')}${number.toString().padLeft(3, '0')}.mp3';

String ayahAudioUrl(Reciter reciter, int surah, int number) =>
    'https://everyayah.com/data/${reciter.folder}/${ayahAudioFile(surah, number)}';

/// Un élément de la liste de lecture : un fichier audio, et le verset à
/// surligner pendant sa lecture.
typedef RecitationItem = ({int surah, int number, int ayahId, int page});

/// Liste de lecture à partir d'un verset jusqu'à la fin de la sourate. La
/// basmala (fichier 001001) est jouée avant le verset 1 de chaque sourate,
/// sauf Al-Fatiha (où elle est le verset 1) et At-Tawba.
List<RecitationItem> buildRecitationQueue(
  List<({int id, int surah, int number, int page})> ayahs,
) => [
  for (final a in ayahs) ...[
    if (a.number == 1 && showsBasmalaHeader(a.surah))
      (surah: 1, number: 1, ayahId: a.id, page: a.page),
    (surah: a.surah, number: a.number, ayahId: a.id, page: a.page),
  ],
];
