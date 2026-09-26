import 'package:timezone/timezone.dart' as tz;

import 'prayer_calculator.dart';

enum AdhanKind {
  /// À l'heure de la prière.
  prayer,

  /// Quelques minutes avant la prière.
  reminder,

  /// Adhkar du matin (après le Fajr) et du soir (après le Asr).
  morningAdhkar,
  eveningAdhkar,
}

/// Une notification à programmer.
class ScheduledAdhan {
  const ScheduledAdhan({
    required this.id,
    required this.salah,
    required this.prayerTime,
    required this.fireAt,
    required this.kind,
  });

  /// Identifiant stable : même notification le même jour → même identifiant.
  final int id;
  final Salah salah;
  final tz.TZDateTime prayerTime;
  final tz.TZDateTime fireAt;
  final AdhanKind kind;

  bool get isReminder => kind == AdhanKind.reminder;
}

/// Délai des rappels d'adhkar après le Fajr (matin) et le Asr (soir).
const adhkarReminderDelay = Duration(minutes: 30);

/// Notifications des [days] prochains jours, triées par heure, limitées à
/// [maxCount] (iOS n'accepte que 64 notifications programmées à la fois :
/// l'app les reprogramme à chaque ouverture).
List<ScheduledAdhan> buildAdhanSchedule({
  required PrayerCalculator calculator,
  required DateTime now,
  required Set<Salah> muted,
  int reminderMinutes = 0,
  bool adhkarReminders = false,
  bool prayers = true,
  int days = 10,
  int maxCount = 60,
}) {
  final today = calculator.localToday(now);
  final result = <ScheduledAdhan>[];

  void add(int id, Salah salah, tz.TZDateTime prayerTime, tz.TZDateTime fireAt, AdhanKind kind) {
    if (fireAt.isAfter(now)) {
      result.add(
        ScheduledAdhan(id: id, salah: salah, prayerTime: prayerTime, fireAt: fireAt, kind: kind),
      );
    }
  }

  for (var d = 0; d < days; d++) {
    final day = calculator.forDay(DateTime(today.year, today.month, today.day + d));
    // id < 2^31 : date AAMMJJ, prière, type.
    final dayKey = (day.date.year % 100) * 10000 + day.date.month * 100 + day.date.day;
    if (prayers) {
      for (final salah in Salah.values.where((s) => s.isPrayer && !muted.contains(s))) {
        final time = day[salah];
        final baseId = dayKey * 100 + salah.index * 10;
        add(baseId, salah, time, time, AdhanKind.prayer);
        if (reminderMinutes > 0) {
          add(
            baseId + 1,
            salah,
            time,
            time.subtract(Duration(minutes: reminderMinutes)),
            AdhanKind.reminder,
          );
        }
      }
    }
    if (adhkarReminders) {
      final fajr = day[Salah.fajr];
      final asr = day[Salah.asr];
      add(
        dayKey * 100 + 90,
        Salah.fajr,
        fajr,
        fajr.add(adhkarReminderDelay),
        AdhanKind.morningAdhkar,
      );
      add(dayKey * 100 + 91, Salah.asr, asr, asr.add(adhkarReminderDelay), AdhanKind.eveningAdhkar);
    }
  }
  result.sort((a, b) => a.fireAt.compareTo(b.fireAt));
  return result.take(maxCount).toList();
}
