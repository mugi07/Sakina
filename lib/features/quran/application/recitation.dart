import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/providers.dart';
import '../domain/reciters.dart';

@immutable
class RecitationState {
  const RecitationState({
    this.reciter = Reciter.alafasy,
    this.active = false,
    this.playing = false,
    this.ayahId,
    this.page,
    this.repeatOne = false,
    this.error = false,
  });

  final Reciter reciter;

  /// Une récitation est chargée (lecture ou pause).
  final bool active;
  final bool playing;

  /// Verset en cours (à surligner) et sa page (pour tourner les pages).
  final int? ayahId;
  final int? page;
  final bool repeatOne;

  /// Échec de lecture (souvent : pas de connexion à la première écoute).
  final bool error;

  RecitationState copyWith({
    Reciter? reciter,
    bool? active,
    bool? playing,
    int? ayahId,
    int? page,
    bool? repeatOne,
    bool? error,
  }) => RecitationState(
    reciter: reciter ?? this.reciter,
    active: active ?? this.active,
    playing: playing ?? this.playing,
    ayahId: ayahId ?? this.ayahId,
    page: page ?? this.page,
    repeatOne: repeatOne ?? this.repeatOne,
    error: error ?? this.error,
  );
}

final recitationProvider = NotifierProvider<RecitationController, RecitationState>(
  RecitationController.new,
);

/// Récitation verset par verset (EveryAyah), avec lecture en arrière-plan
/// et commandes sur l'écran de verrouillage. Chaque verset écouté est gardé
/// en cache : il est ensuite disponible hors-ligne.
class RecitationController extends Notifier<RecitationState> {
  static const _reciterKey = 'recitation.reciter';

  AudioPlayer? _player;
  final _subscriptions = <StreamSubscription<Object?>>[];
  List<RecitationItem> _queue = const [];
  String Function(int surah, int number) _titleOf = (s, n) => '$s:$n';

  @override
  RecitationState build() {
    ref.onDispose(_disposePlayer);
    final saved = ref.watch(sharedPreferencesProvider).getString(_reciterKey);
    return RecitationState(reciter: Reciter.values.asNameMap()[saved] ?? Reciter.alafasy);
  }

  AudioPlayer _ensurePlayer() {
    final existing = _player;
    if (existing != null) return existing;
    final player = AudioPlayer();
    _subscriptions
      ..add(
        player.currentIndexStream.listen((index) {
          if (index == null || index >= _queue.length) return;
          final item = _queue[index];
          state = state.copyWith(ayahId: item.ayahId, page: item.page);
        }),
      )
      ..add(
        player.playerStateStream.listen((s) {
          final finished = s.processingState == ProcessingState.completed;
          state = state.copyWith(playing: s.playing && !finished);
          if (finished) stop();
        }, onError: (Object _) => state = state.copyWith(error: true, playing: false)),
      );
    return _player = player;
  }

  /// Lit les versets donnés (en général : d'un verset à la fin de la sourate).
  Future<void> play(
    List<({int id, int surah, int number, int page})> ayahs, {
    required String Function(int surah, int number) titleOf,
  }) async {
    if (ayahs.isEmpty) return;
    _titleOf = titleOf;
    await _load(buildRecitationQueue(ayahs));
  }

  /// Charge [queue] avec le récitateur actuel et lance la lecture.
  Future<void> _load(List<RecitationItem> queue) async {
    final player = _ensurePlayer();
    final reciter = state.reciter;
    _queue = queue;
    final dir = Directory(
      p.join((await getApplicationSupportDirectory()).path, 'audio', reciter.folder),
    );
    await dir.create(recursive: true);

    final sources = <AudioSource>[
      for (final item in _queue)
        _source(
          reciter,
          item,
          File(p.join(dir.path, ayahAudioFile(item.surah, item.number))),
          _titleOf,
        ),
    ];
    state = state.copyWith(
      active: true,
      error: false,
      ayahId: _queue.first.ayahId,
      page: _queue.first.page,
    );
    try {
      await player.setAudioSources(sources);
      await player.setLoopMode(state.repeatOne ? LoopMode.one : LoopMode.off);
      unawaited(player.play());
    } on Exception {
      state = state.copyWith(error: true, playing: false);
    }
  }

  AudioSource _source(
    Reciter reciter,
    RecitationItem item,
    File cache,
    String Function(int surah, int number) titleOf,
  ) {
    final tag = MediaItem(
      id: '${reciter.folder}/${ayahAudioFile(item.surah, item.number)}',
      title: titleOf(item.surah, item.number),
      artist: reciter.nameLatin,
      album: 'Sakinah',
    );
    if (cache.existsSync() && cache.lengthSync() > 0) {
      return AudioSource.file(cache.path, tag: tag);
    }
    // Expérimental dans just_audio, mais c'est la seule source qui lit et met
    // en cache en même temps (écoute hors-ligne ensuite).
    // ignore: experimental_member_use
    return LockCachingAudioSource(
      Uri.parse(ayahAudioUrl(reciter, item.surah, item.number)),
      cacheFile: cache,
      tag: tag,
    );
  }

  Future<void> togglePlay() async {
    final player = _player;
    if (player == null) return;
    if (player.playing) {
      await player.pause();
    } else {
      unawaited(player.play());
    }
  }

  Future<void> next() async => _player?.seekToNext();

  Future<void> previous() async => _player?.seekToPrevious();

  Future<void> toggleRepeat() async {
    final repeat = !state.repeatOne;
    state = state.copyWith(repeatOne: repeat);
    await _player?.setLoopMode(repeat ? LoopMode.one : LoopMode.off);
  }

  /// Change de récitateur ; une lecture en cours reprend au verset actuel
  /// avec la nouvelle voix.
  Future<void> setReciter(Reciter reciter) async {
    if (reciter == state.reciter) return;
    state = state.copyWith(reciter: reciter);
    await ref.read(sharedPreferencesProvider).setString(_reciterKey, reciter.name);
    final index = _player?.currentIndex;
    if (state.active && index != null && index < _queue.length) {
      await _load(_queue.sublist(index));
    }
  }

  Future<void> stop() async {
    await _player?.stop();
    _queue = const [];
    state = RecitationState(reciter: state.reciter, repeatOne: state.repeatOne);
  }

  void _disposePlayer() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    _player?.dispose();
    _player = null;
  }
}
