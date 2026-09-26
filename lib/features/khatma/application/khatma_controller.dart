import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../quran/domain/page_layout.dart';
import '../domain/khatma_plan.dart';

final khatmaProvider = NotifierProvider<KhatmaController, KhatmaPlan?>(KhatmaController.new);

/// Khatma en cours (null : aucune), sauvegardée sur le téléphone.
class KhatmaController extends Notifier<KhatmaPlan?> {
  static const _key = 'khatma.v1';

  /// Horloge injectable pour les tests.
  DateTime Function() now = DateTime.now;

  @override
  KhatmaPlan? build() {
    final raw = ref.watch(sharedPreferencesProvider).getString(_key);
    if (raw == null) return null;
    try {
      return KhatmaPlan.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return null;
    }
  }

  void _save(KhatmaPlan? plan) {
    state = plan;
    final prefs = ref.read(sharedPreferencesProvider);
    if (plan == null) {
      prefs.remove(_key);
    } else {
      prefs.setString(_key, jsonEncode(plan.toJson()));
    }
  }

  /// Commence une khatma aujourd'hui (le nombre de khatmas terminées est gardé).
  void start({required int days, int startPage = 1, int? reminderMinutes = 20 * 60}) {
    final today = now();
    _save(
      KhatmaPlan(
        startDate: DateTime(today.year, today.month, today.day),
        days: days,
        startPage: startPage.clamp(1, mushafPageCount),
        reminderMinutes: reminderMinutes,
        completedCount: state?.completedCount ?? 0,
      ),
    );
  }

  /// Enregistre la lecture jusqu'à [page] (jamais de retour en arrière).
  /// Renvoie true si la khatma vient d'être terminée.
  bool markReadUpTo(int page) {
    final plan = state;
    if (plan == null || page <= plan.lastPageRead) return false;
    final wasCompleted = plan.isCompleted;
    final next = plan.copyWith(lastPageRead: page.clamp(plan.startPage, mushafPageCount));
    final finished = !wasCompleted && next.isCompleted;
    _save(finished ? next.copyWith(completedCount: next.completedCount + 1) : next);
    return finished;
  }

  void setReminder(int? minutes) {
    final plan = state;
    if (plan != null) _save(plan.copyWith(reminderMinutes: minutes));
  }

  void stop() => _save(null);
}
