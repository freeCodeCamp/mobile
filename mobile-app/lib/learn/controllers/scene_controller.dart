import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/scene_assets_model.dart';
import 'package:freecodecamp/learn/services/curriculum_service.dart';
import 'package:freecodecamp/services/audio_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scene_controller.freezed.dart';
part 'scene_controller.g.dart';

const _mouthInterval = (min: 85, max: 105);
const _blinkInterval = (min: 2000, max: 4000);
const _blinkDuration = Duration(milliseconds: 150);

@riverpod
Future<SceneAssets> sceneAssets(Ref ref) =>
    ref.watch(learnCurriculumServiceProvider).getSceneAssets();

@freezed
abstract class CharacterState with _$CharacterState {
  const factory CharacterState({
    required String name,
    required ScenePosition position,
    @Default(false) bool mouthOpen,
    @Default(false) bool eyesClosed,
    @Default(1) double opacity,
  }) = _CharacterState;
}

typedef SceneLine = ({String character, String text, String align});

typedef CharacterSprites = ({
  String base,
  String brows,
  String eyes,
  String? glasses,
  String mouth,
});

@freezed
abstract class SceneState with _$SceneState {
  const factory SceneState({
    required String background,
    required List<CharacterState> characters,
    SceneLine? line,
    @Default(false) bool showCaptions,
    // NOTE: Whether the audio handler currently holds this scene's clip.
    @Default(false) bool isActive,
  }) = _SceneState;
}

String sceneBackgroundUrl(SceneAssets assets, String name) =>
    '${assets.backgrounds}/${name.endsWith('.png') ? name : '$name.png'}';

CharacterSprites? characterSprites(SceneAssets assets, CharacterState c) {
  final a = assets.characterAssets[c.name];
  if (a == null) return null;

  return (
    base: a.base,
    brows: a.brows,
    eyes: c.eyesClosed ? a.eyesClosed : a.eyesOpen,
    glasses: a.glasses,
    mouth: c.mouthOpen ? a.mouthOpen : a.mouthClosed,
  );
}

@riverpod
class SceneNotifier extends _$SceneNotifier {
  late AudioPlayerHandler _handler;

  final _applied = <int>{};
  final _mouthTimers = <String, Timer>{};
  final _blinkTimers = <String, Timer>{};
  final _random = Random();

  bool _started = false;
  bool _completed = false;
  bool _playing = false;

  @override
  SceneState build(Scene scene, String title) {
    _handler = ref.read(audioHandlerProvider);

    final subs = [
      _handler.positionStream.listen(_onPosition),
      _handler.playbackState.listen(_onPlayback),
    ];
    ref.onDispose(() {
      for (final sub in subs) {
        sub.cancel();
      }
      _stopTimers(_mouthTimers);
      _stopTimers(_blinkTimers);
      if (_isActive) _handler.stop();
    });

    return _initial();
  }

  AudioClip get _clip => scene.setup.audio;

  double get _audioOffset => _clip.startTime.toDouble();

  bool get _isActive => _handler.curriculumClipId == _clip.id;

  void toggleCaptions() =>
      state = state.copyWith(showCaptions: !state.showCaptions);

  Future<void> play() async {
    if (_started && !_completed && _isActive) return _handler.play();

    if (!_isActive) {
      final loaded = await _handler.loadCurriculumAudio(
        _clip.url,
        clipId: _clip.id,
        title: title,
        start: _clip.start,
        end: _clip.end,
      );
      if (!loaded || !ref.mounted) return;
    } else if (_completed) {
      await _handler.seek(Duration.zero);
      if (!ref.mounted) return;
    }

    _stopTimers(_mouthTimers);
    _stopTimers(_blinkTimers);
    _started = true;
    _completed = false;
    _applied.clear();

    state = _applyDue(
      _initial().copyWith(showCaptions: state.showCaptions, isActive: true),
      (start) => start < _audioOffset,
    );

    await Future<void>.delayed(
      Duration(milliseconds: (_audioOffset * 1000).round()),
    );
    if (ref.mounted && _isActive) await _handler.play();
  }

  Future<void> pause() => _handler.pause();

  SceneState _initial() => SceneState(
    background: scene.setup.background,
    characters: [
      for (final c in scene.setup.characters)
        CharacterState(
          name: c.character,
          position: c.position,
          opacity: c.opacity?.toDouble() ?? 1,
        ),
    ],
  );

  void _onPlayback(PlaybackState playback) {
    final active = _isActive;
    if (active != state.isActive) state = state.copyWith(isActive: active);
    if (!active) return;

    _playing = playback.playing;
    if (_playing) {
      for (final c in state.characters) {
        _startBlinking(c.name);
      }
    } else {
      _stopTimers(_mouthTimers);
      _stopTimers(_blinkTimers);
      state = state.copyWith(
        characters: [
          for (final c in state.characters)
            c.copyWith(mouthOpen: false, eyesClosed: false),
        ],
      );
    }

    if (playback.processingState == AudioProcessingState.completed &&
        _started &&
        !_completed) {
      _complete();
    }
  }

  void _complete() {
    _completed = true;
    state = _applyDue(state.copyWith(line: null), (_) => true);
  }

  void _onPosition(Duration position) {
    if (!_isActive || !_playing || _completed) return;

    final seconds = position.inMilliseconds / 1000 + _audioOffset;
    var next = _applyDue(state, (start) => seconds >= start);
    final speaking = <String>{};
    SceneLine? active;

    for (final command in scene.commands) {
      final start = command.startTime.toDouble();
      final finish = command.finishTime?.toDouble();

      if (command.dialogue case final dialogue?) {
        if (seconds >= start && (finish == null || seconds <= finish)) {
          speaking.add(command.character);
          active = (
            character: command.character,
            text: dialogue.text,
            align: dialogue.align,
          );
        }
      }
    }

    if (active != null && active != next.line) {
      next = next.copyWith(line: active);
    }
    state = next;

    for (final name in speaking) {
      if (!_mouthTimers.containsKey(name)) _startTalking(name);
    }
    for (final name in [..._mouthTimers.keys]) {
      if (!speaking.contains(name)) {
        _mouthTimers.remove(name)?.cancel();
        _update(name, (c) => c.copyWith(mouthOpen: false));
      }
    }
  }

  SceneState _applyDue(SceneState current, bool Function(num start) due) {
    var next = current;
    for (final (i, command) in scene.commands.indexed) {
      if (due(command.startTime) && _applied.add(i)) {
        next = _apply(next, command);
      }
    }
    return next;
  }

  SceneState _apply(SceneState current, SceneCommand command) {
    final characters = [...current.characters];
    final index = characters.indexWhere((c) => c.name == command.character);

    if (index == -1) {
      characters.add(
        CharacterState(
          name: command.character,
          position: command.position ?? const ScenePosition(x: 0, y: 0, z: 0),
          opacity: command.opacity?.toDouble() ?? 1,
        ),
      );
    } else if (command.position != null || command.opacity != null) {
      final character = characters[index];
      characters[index] = character.copyWith(
        position: command.position ?? character.position,
        opacity: command.opacity?.toDouble() ?? character.opacity,
      );
    }

    return current.copyWith(
      background: command.background ?? current.background,
      characters: characters,
    );
  }

  int _between(({int min, int max}) range) =>
      range.min + _random.nextInt(range.max - range.min + 1);

  void _startTalking(String name) {
    void toggle(bool open) {
      _update(name, (c) => c.copyWith(mouthOpen: open));
      _mouthTimers[name] = Timer(
        Duration(milliseconds: _between(_mouthInterval)),
        () {
          if (_mouthTimers.containsKey(name)) toggle(!open);
        },
      );
    }

    toggle(true);
  }

  void _startBlinking(String name) {
    if (_blinkTimers.containsKey(name)) return;

    void schedule() {
      _blinkTimers[name] = Timer(
        Duration(milliseconds: _between(_blinkInterval)),
        () {
          _update(name, (c) => c.copyWith(eyesClosed: true));
          Timer(_blinkDuration, () {
            if (_blinkTimers.containsKey(name)) {
              _update(name, (c) => c.copyWith(eyesClosed: false));
            }
          });
          if (_blinkTimers.containsKey(name)) schedule();
        },
      );
    }

    schedule();
  }

  void _stopTimers(Map<String, Timer> timers) {
    for (final timer in timers.values) {
      timer.cancel();
    }
    timers.clear();
  }

  void _update(String name, CharacterState Function(CharacterState) change) {
    if (!ref.mounted) return;
    state = state.copyWith(
      characters: [
        for (final c in state.characters) c.name == name ? change(c) : c,
      ],
    );
  }
}
