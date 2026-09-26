import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina/core/providers.dart';
import 'package:sakina/features/quran/application/bookmarks.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('ajouter, retirer, et retrouver les signets au redémarrage', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final c = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
    c.read(bookmarksProvider.notifier)
      ..toggle(262)
      ..toggle(1)
      ..toggle(6236)
      ..toggle(1);
    expect(c.read(bookmarksProvider), {262, 6236});
    c.dispose();

    final again = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(again.dispose);
    expect(again.read(bookmarksProvider), {262, 6236});
  });
}
