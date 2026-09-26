import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../quran/domain/page_layout.dart';

/// Où en est la lecture par rapport à l'objectif.
enum KhatmaStatus { ahead, onTrack, behind, completed }

/// Plan de lecture du Coran entier en [days] jours, à partir de [startPage].
@immutable
class KhatmaPlan {
  const KhatmaPlan({
    required this.startDate,
    required this.days,
    this.startPage = 1,
    int? lastPageRead,
    this.reminderMinutes,
    this.completedCount = 0,
  }) : lastPageRead = lastPageRead ?? startPage - 1;

  factory KhatmaPlan.fromJson(Map<String, dynamic> json) => KhatmaPlan(
    startDate: DateTime.parse(json['startDate'] as String),
    days: json['days'] as int,
    startPage: json['startPage'] as int? ?? 1,
    lastPageRead: json['lastPageRead'] as int?,
    reminderMinutes: json['reminderMinutes'] as int?,
    completedCount: json['completedCount'] as int? ?? 0,
  );

  /// Premier jour du plan (date civile).
  final DateTime startDate;
  final int days;
  final int startPage;

  /// Dernière page lue (startPage - 1 si rien n'est encore lu).
  final int lastPageRead;

  /// Heure du rappel quotidien en minutes depuis minuit (null : pas de rappel).
  final int? reminderMinutes;

  /// Nombre de khatmas déjà terminées.
  final int completedCount;

  int get totalPages => mushafPageCount - startPage + 1;
  int get pagesRead => lastPageRead - (startPage - 1);
  int get pagesPerDay => (totalPages / days).ceil();
  bool get isCompleted => lastPageRead >= mushafPageCount;
  double get progress => pagesRead / totalPages;
  DateTime get endDate => DateTime(startDate.year, startDate.month, startDate.day + days - 1);

  /// Jour du plan (1..days) pour une date donnée.
  int dayNumber(DateTime today) {
    final d = DateTime(today.year, today.month, today.day);
    return (d.difference(DateTime(startDate.year, startDate.month, startDate.day)).inDays + 1)
        .clamp(1, days);
  }

  /// Page à atteindre à la fin de la journée [today].
  int targetPage(DateTime today) =>
      math.min(mushafPageCount, startPage - 1 + pagesPerDay * dayNumber(today));

  /// Pages qu'il reste à lire aujourd'hui pour tenir l'objectif.
  int remainingToday(DateTime today) => math.max(0, targetPage(today) - lastPageRead);

  /// Retard par rapport à l'objectif de la veille (0 si à jour).
  int pagesBehind(DateTime today) {
    final day = dayNumber(today);
    if (day <= 1) return 0;
    final yesterdayTarget = math.min(mushafPageCount, startPage - 1 + pagesPerDay * (day - 1));
    return math.max(0, yesterdayTarget - lastPageRead);
  }

  KhatmaStatus status(DateTime today) {
    if (isCompleted) return KhatmaStatus.completed;
    if (pagesBehind(today) > 0) return KhatmaStatus.behind;
    if (lastPageRead >= targetPage(today)) return KhatmaStatus.ahead;
    return KhatmaStatus.onTrack;
  }

  KhatmaPlan copyWith({int? lastPageRead, Object? reminderMinutes = _unset, int? completedCount}) =>
      KhatmaPlan(
        startDate: startDate,
        days: days,
        startPage: startPage,
        lastPageRead: lastPageRead ?? this.lastPageRead,
        reminderMinutes: reminderMinutes == _unset ? this.reminderMinutes : reminderMinutes as int?,
        completedCount: completedCount ?? this.completedCount,
      );

  static const _unset = Object();

  Map<String, dynamic> toJson() => {
    'startDate': startDate.toIso8601String().substring(0, 10),
    'days': days,
    'startPage': startPage,
    'lastPageRead': lastPageRead,
    'reminderMinutes': reminderMinutes,
    'completedCount': completedCount,
  };
}

/// Durées proposées (en jours).
const khatmaDurations = [7, 10, 15, 20, 30, 40, 60];

/// Heures des rappels quotidiens des [days] prochains jours (dans le fuseau
/// [zone]), jusqu'à la fin du plan ; aucun si la khatma est finie ou sans rappel.
List<tz.TZDateTime> khatmaReminderTimes(
  KhatmaPlan plan,
  tz.Location zone,
  DateTime now, {
  int days = 10,
}) {
  final minutes = plan.reminderMinutes;
  if (minutes == null || plan.isCompleted) return const [];
  final local = tz.TZDateTime.from(now, zone);
  final end = plan.endDate;
  return [
    for (var d = 0; d < days; d++)
      if (tz.TZDateTime(zone, local.year, local.month, local.day + d, minutes ~/ 60, minutes % 60)
          case final t when t.isAfter(now) && !DateTime(t.year, t.month, t.day).isAfter(end))
        t,
  ];
}
