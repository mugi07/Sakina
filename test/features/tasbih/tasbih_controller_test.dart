import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina/core/providers.dart';
import 'package:sakina/features/tasbih/application/tasbih_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> _container([Map<String, Object> prefs = const {}]) async {
  SharedPreferences.setMockInitialValues(prefs);
  final sp = await SharedPreferences.getInstance();
  return ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(sp)]);
}

void main() {
  test('compte, objectif atteint, remise à zéro', () async {
    final c = await _container();
    addTearDown(c.dispose);
    final tasbih = c.read(tasbihProvider.notifier);
    for (var i = 0; i < 33; i++) {
      tasbih.increment();
    }
    expect(c.read(tasbihProvider).count, 33);
    expect(c.read(tasbihProvider).targetReached, isTrue);
    expect(c.read(tasbihProvider).todayTotal, 33);
    tasbih.reset();
    expect(c.read(tasbihProvider).count, 0);
    expect(c.read(tasbihProvider).todayTotal, 33);
  });

  test('changer de formule ou d\'objectif repart de zéro', () async {
    final c = await _container();
    addTearDown(c.dispose);
    final tasbih = c.read(tasbihProvider.notifier)
      ..increment()
      ..setPhrase(DhikrPhrase.alhamdulillah);
    expect(
      (c.read(tasbihProvider).count, c.read(tasbihProvider).phrase),
      (0, DhikrPhrase.alhamdulillah),
    );
    tasbih
      ..increment()
      ..setTarget(0);
    expect((c.read(tasbihProvider).count, c.read(tasbihProvider).targetReached), (0, false));
  });

  test('sauvegardé, et le total du jour repart de zéro le lendemain', () async {
    final c = await _container();
    final tasbih = c.read(tasbihProvider.notifier)..now = () => DateTime(2026, 9, 26, 22);
    tasbih
      ..increment()
      ..increment();
    final saved = (await SharedPreferences.getInstance()).getString('tasbih.v1')!;
    c.dispose();

    final next = await _container({'tasbih.v1': saved});
    addTearDown(next.dispose);
    final restored = next.read(tasbihProvider);
    expect(restored.count, 2);

    final nextDay = next.read(tasbihProvider.notifier)..now = (() => DateTime(2026, 9, 27, 6));
    nextDay.increment();
    expect(next.read(tasbihProvider).todayTotal, 1);
    expect(next.read(tasbihProvider).day, '2026-09-27');
  });
}
