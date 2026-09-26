import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/settings/app_settings.dart';
import '../../khatma/application/khatma_controller.dart';
import '../domain/prayer_calculator.dart';

/// Null tant que l'utilisateur n'a pas choisi de lieu. Ne dépend que des
/// réglages de calcul (tourner une page du Coran ne le recalcule pas).
final prayerCalculatorProvider = Provider<PrayerCalculator?>((ref) {
  final (location, method, madhab, rule) = ref.watch(
    settingsProvider.select((s) => (s.location, s.calculationMethod, s.madhab, s.highLatitudeRule)),
  );
  if (location == null) return null;
  final settings = AppSettings(
    location: location,
    calculationMethod: method,
    madhab: madhab,
    highLatitudeRule: rule,
  );
  return PrayerCalculator(location, PrayerConfig.resolve(settings, location));
});

/// Prochaine prière, recalculée à chaque tic de l'horloge.
final nextPrayerProvider = Provider<NextPrayer?>((ref) {
  final calculator = ref.watch(prayerCalculatorProvider);
  final now = ref.watch(clockProvider).value ?? DateTime.now();
  return calculator?.nextPrayer(now);
});

/// Tout ce qui change les notifications d'adhan : quand cette valeur
/// change, elles sont reprogrammées.
final adhanInputsProvider = Provider<Object>((ref) {
  final calculator = ref.watch(prayerCalculatorProvider);
  final khatma = ref.watch(
    khatmaProvider.select((k) => (k?.startDate, k?.days, k?.reminderMinutes, k?.isCompleted)),
  );
  return ref.watch(
    settingsProvider.select(
      (s) => (
        calculator,
        s.adhanEnabled,
        (s.adhanMuted.toList()..sort()).join(','),
        s.adhanReminderMinutes,
        s.adhkarReminders,
        s.language,
        khatma,
      ),
    ),
  );
});
