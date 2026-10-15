import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/scene_assets_model.dart';
import 'package:mobile_app_new/learn/services/curriculum_service.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scene_viewmodel.freezed.dart';
part 'scene_viewmodel.g.dart';

const _cdn =
    'https://cdn.freecodecamp.org/curriculum/english/animation-assets/images';
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

String sceneBackgroundUrl(SceneAssets? assets, String name) {
  final file = name.endsWith('.png') ? name : '$name.png';
  return '${assets?.backgrounds ?? '$_cdn/backgrounds'}/$file';
}

// NOTE: Falls back to the CDN's folder layout when scene-assets.json hasn't loaded.
CharacterSprites characterSprites(SceneAssets? assets, CharacterState c) {
  final a = assets?.characterAssets[c.name];
  String fallback(String file) =>
      '$_cdn/characters/${c.name.toLowerCase()}/$file';

  return (
    base: a?.base ?? fallback('base.png'),
    brows: a?.brows ?? fallback('brows.png'),
    eyes: c.eyesClosed
        ? a?.eyesClosed ?? fallback('eyes-closed.png')
        : a?.eyesOpen ?? fallback('eyes-open.png'),
    glasses: a?.glasses,
    mouth: c.mouthOpen
        ? a?.mouthOpen ?? fallback('mouth-open.png')
        : a?.mouthClosed ?? fallback('mouth-closed.png'),
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

    var next = _initial().copyWith(
      showCaptions: state.showCaptions,
      isActive: true,
    );
    for (final (i, command) in scene.commands.indexed) {
      if (command.startTime < _audioOffset) {
        _applied.add(i);
        next = _apply(next, command);
      }
    }
    state = next;

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
    var next = state.copyWith(line: null);
    for (final (i, command) in scene.commands.indexed) {
      if (_applied.add(i)) next = _apply(next, command);
    }
    state = next;
  }

  void _onPosition(Duration position) {
    if (!_isActive || !_playing || _completed) return;

    final seconds = position.inMilliseconds / 1000 + _audioOffset;
    var next = state;
    final speaking = <String>{};
    SceneLine? active;

    for (final (i, command) in scene.commands.indexed) {
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

      if (seconds >= start && _applied.add(i)) next = _apply(next, command);
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
