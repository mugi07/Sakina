import 'package:timezone/timezone.dart' as tz;

import 'prayer_calculator.dart';

/// Une notification à programmer : l'heure d'une prière, ou un rappel
/// quelques minutes avant.
class ScheduledAdhan {
  const ScheduledAdhan({
    required this.id,
    required this.salah,
    required this.prayerTime,
    required this.fireAt,
    required this.isReminder,
  });

  /// Identifiant stable : même prière le même jour → même identifiant.
  final int id;
  final Salah salah;
  final tz.TZDateTime prayerTime;
  final tz.TZDateTime fireAt;
  final bool isReminder;
}

/// Notifications des [days] prochains jours, triées par heure, limitées à
/// [maxCount] (iOS n'accepte que 64 notifications programmées à la fois :
/// l'app les reprogramme à chaque ouverture).
List<ScheduledAdhan> buildAdhanSchedule({
  required PrayerCalculator calculator,
  required DateTime now,
  required Set<Salah> muted,
  int reminderMinutes = 0,
  int days = 10,
  int maxCount = 60,
}) {
  final today = calculator.localToday(now);
  final result = <ScheduledAdhan>[];
  for (var d = 0; d < days; d++) {
    final day = calculator.forDay(DateTime(today.year, today.month, today.day + d));
    final dayKey = day.date.year * 10000 + day.date.month * 100 + day.date.day;
    for (final salah in Salah.values.where((s) => s.isPrayer && !muted.contains(s))) {
      final time = day[salah];
      // id < 2^31 : date sur 8 chiffres + prière + type.
      final baseId = (dayKey % 1000000) * 100 + salah.index * 10;
      if (time.isAfter(now)) {
        result.add(
          ScheduledAdhan(
            id: baseId,
            salah: salah,
            prayerTime: time,
            fireAt: time,
            isReminder: false,
          ),
        );
      }
      if (reminderMinutes > 0) {
        final before = time.subtract(Duration(minutes: reminderMinutes));
        if (before.isAfter(now)) {
          result.add(
            ScheduledAdhan(
              id: baseId + 1,
              salah: salah,
              prayerTime: time,
              fireAt: before,
              isReminder: true,
            ),
          );
        }
      }
    }
  }
  result.sort((a, b) => a.fireAt.compareTo(b.fireAt));
  return result.take(maxCount).toList();
}
