import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../domain/prayer_calculator.dart';

/// Null tant que l'utilisateur n'a pas choisi de lieu.
final prayerCalculatorProvider = Provider<PrayerCalculator?>((ref) {
  final settings = ref.watch(settingsProvider);
  final location = settings.location;
  if (location == null) return null;
  return PrayerCalculator(location, PrayerConfig.resolve(settings, location));
});

/// Prochaine prière, recalculée à chaque tic de l'horloge.
final nextPrayerProvider = Provider<NextPrayer?>((ref) {
  final calculator = ref.watch(prayerCalculatorProvider);
  final now = ref.watch(clockProvider).value ?? DateTime.now();
  return calculator?.nextPrayer(now);
});
