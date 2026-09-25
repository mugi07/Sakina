import 'package:flutter_test/flutter_test.dart';
import 'package:sakina/core/text/search_normalizer.dart';

void main() {
  group('normalizeArabic', () {
    test('retire les voyelles, la shadda et le tatwil', () {
      expect(normalizeArabic('بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ'), 'بسم الله الرحمن الرحيم');
    });

    test('unifie les formes de l\'alif et le alif maqsura', () {
      expect(normalizeArabic('أإآٱا'), 'ااااا');
      expect(normalizeArabic('موسى'), 'موسي');
    });

    test('ta marbuta → ha (désactivable)', () {
      expect(normalizeArabic('الصلاة'), 'الصلاه');
      expect(normalizeArabic('الصلاة', unifyTaMarbuta: false), 'الصلاة');
    });

    test('retire les signes coraniques', () {
      expect(normalizeArabic('لَا رَيْبَ ۛ فِيهِ ۛ'), 'لا ريب  فيه ');
    });
  });

  group('foldLatin', () {
    test('minuscules et accents retirés', () {
      expect(foldLatin('Fès Méknès ÇA œuvre'), 'fes meknes ca oeuvre');
    });
  });

  group('normalizeForSearch', () {
    test('requête avec voyelles = requête sans voyelles', () {
      expect(normalizeForSearch('الصَّلَاةُ'), normalizeForSearch('الصلاة'));
    });

    test('ponctuation retirée et espaces compactés', () {
      expect(normalizeForSearch("  Ta'if,   (Arabie)  "), 'taif arabie');
    });

    test('les jokers SQL sont neutralisés', () {
      expect(normalizeForSearch('%_paris'), 'paris');
    });
  });
}
