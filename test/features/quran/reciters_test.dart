import 'package:flutter_test/flutter_test.dart';
import 'package:sakina/features/quran/domain/reciters.dart';

void main() {
  test('URL EveryAyah : sourate et verset sur 3 chiffres', () {
    expect(
      ayahAudioUrl(Reciter.alafasy, 2, 255),
      'https://everyayah.com/data/Alafasy_128kbps/002255.mp3',
    );
    expect(ayahAudioFile(114, 6), '114006.mp3');
  });

  test('basmala jouée avant le verset 1, sauf Al-Fatiha et At-Tawba', () {
    final queue = buildRecitationQueue([
      (id: 8, surah: 2, number: 1, page: 2),
      (id: 9, surah: 2, number: 2, page: 2),
    ]);
    expect(queue.map((q) => (q.surah, q.number, q.ayahId)), [(1, 1, 8), (2, 1, 8), (2, 2, 9)]);

    final fatiha = buildRecitationQueue([(id: 1, surah: 1, number: 1, page: 1)]);
    expect(fatiha.map((q) => (q.surah, q.number)), [(1, 1)]);

    final tawba = buildRecitationQueue([(id: 1236, surah: 9, number: 1, page: 187)]);
    expect(tawba.map((q) => (q.surah, q.number)), [(9, 1)]);
  });

  test('reprendre au milieu d\'une sourate : pas de basmala', () {
    final queue = buildRecitationQueue([(id: 262, surah: 2, number: 255, page: 42)]);
    expect(queue.single.number, 255);
  });
}
