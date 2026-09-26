import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';

/// Formules de dhikr proposées par le compteur.
enum DhikrPhrase {
  subhanallah('سُبْحَانَ اللهِ', 'Subhan Allah'),
  alhamdulillah('الْحَمْدُ لِلهِ', 'Al-hamdu lillah'),
  allahuakbar('اللهُ أَكْبَرُ', 'Allahu akbar'),
  lailaha('لَا إِلَهَ إِلَّا اللهُ', 'La ilaha illa Allah'),
  astaghfirullah('أَسْتَغْفِرُ اللهَ', 'Astaghfirullah'),
  salawat('اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ', "Allahumma salli 'ala Muhammad");

  const DhikrPhrase(this.arabic, this.transliteration);

  final String arabic;
  final String transliteration;
}

/// Objectifs proposés (0 : compteur libre).
const tasbihTargets = [33, 99, 100, 0];

@immutable
class TasbihState {
  const TasbihState({
    this.count = 0,
    this.target = 33,
    this.phrase = DhikrPhrase.subhanallah,
    this.todayTotal = 0,
    this.day = '',
  });

  factory TasbihState.fromJson(Map<String, dynamic> json) => TasbihState(
    count: json['count'] as int? ?? 0,
    target: json['target'] as int? ?? 33,
    phrase: DhikrPhrase.values.asNameMap()[json['phrase']] ?? DhikrPhrase.subhanallah,
    todayTotal: json['todayTotal'] as int? ?? 0,
    day: json['day'] as String? ?? '',
  );

  final int count;
  final int target;
  final DhikrPhrase phrase;

  /// Total de la journée [day] (AAAA-MM-JJ), toutes formules confondues.
  final int todayTotal;
  final String day;

  bool get targetReached => target > 0 && count >= target;

  TasbihState copyWith({
    int? count,
    int? target,
    DhikrPhrase? phrase,
    int? todayTotal,
    String? day,
  }) => TasbihState(
    count: count ?? this.count,
    target: target ?? this.target,
    phrase: phrase ?? this.phrase,
    todayTotal: todayTotal ?? this.todayTotal,
    day: day ?? this.day,
  );

  Map<String, dynamic> toJson() => {
    'count': count,
    'target': target,
    'phrase': phrase.name,
    'todayTotal': todayTotal,
    'day': day,
  };
}

final tasbihProvider = NotifierProvider<TasbihController, TasbihState>(TasbihController.new);

/// Compteur de dhikr, sauvegardé à chaque appui (clé à part des réglages,
/// pour ne pas reconstruire toute l'app à chaque compte).
class TasbihController extends Notifier<TasbihState> {
  static const _key = 'tasbih.v1';

  /// Horloge injectable pour les tests.
  DateTime Function() now = DateTime.now;

  String get _today {
    final d = now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  TasbihState build() {
    final raw = ref.watch(sharedPreferencesProvider).getString(_key);
    var state = raw == null
        ? const TasbihState()
        : TasbihState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    if (state.day != _today) state = state.copyWith(todayTotal: 0, day: _today);
    return state;
  }

  void _save(TasbihState next) {
    state = next;
    ref.read(sharedPreferencesProvider).setString(_key, jsonEncode(next.toJson()));
  }

  /// Un appui : +1 (le total du jour repart de zéro chaque jour).
  void increment() {
    final today = _today;
    final todayTotal = state.day == today ? state.todayTotal + 1 : 1;
    _save(state.copyWith(count: state.count + 1, todayTotal: todayTotal, day: today));
  }

  void reset() => _save(state.copyWith(count: 0));

  void setTarget(int target) => _save(state.copyWith(target: target, count: 0));

  void setPhrase(DhikrPhrase phrase) => _save(state.copyWith(phrase: phrase, count: 0));
}
