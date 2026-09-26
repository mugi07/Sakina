import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database/content_database.dart';
import 'settings/app_settings.dart';

/// Fournis dans main() via des overrides, une fois initialisés.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider non initialisé'),
);

final contentDatabaseProvider = Provider<ContentDatabase>(
  (ref) => throw UnimplementedError('contentDatabaseProvider non initialisé'),
);

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

/// Réglages de l'utilisateur, persistés en JSON dans SharedPreferences.
class SettingsController extends Notifier<AppSettings> {
  static const _key = 'settings.v1';

  /// Lit les réglages enregistrés (valeurs par défaut s'il n'y en a pas).
  static AppSettings load(SharedPreferences prefs) {
    final raw = prefs.getString(_key);
    if (raw == null) return const AppSettings();
    try {
      return AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return const AppSettings();
    }
  }

  @override
  AppSettings build() => load(ref.watch(sharedPreferencesProvider));

  void update(AppSettings Function(AppSettings current) change) {
    state = change(state);
    ref.read(sharedPreferencesProvider).setString(_key, jsonEncode(state.toJson()));
  }
}

/// Heure courante, rafraîchie chaque seconde (comptes à rebours).
final clockProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});
