import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/audio/audio_service.dart';
import 'package:stacked/stacked.dart';

class CharacterState {
  final String characterName;
  final SceneCharacterPosition position;
  final double opacity;
  final bool showMouth;
  final String mouthType;

  CharacterState({
    required this.characterName,
    required this.position,
    required this.opacity,
    this.showMouth = false,
    this.mouthType = 'smile',
  });

  CharacterState copyWith({
    String? characterName,
    SceneCharacterPosition? position,
    double? opacity,
    bool? showMouth,
    String? mouthType,
  }) {
    return CharacterState(
      characterName: characterName ?? this.characterName,
      position: position ?? this.position,
      opacity: opacity ?? this.opacity,
      showMouth: showMouth ?? this.showMouth,
      mouthType: mouthType ?? this.mouthType,
    );
  }
}

class SceneViewModel extends BaseViewModel {
  static const String _cdnBase = 'https://cdn.freecodecamp.org';
  static const List<String> _mouthTypes = ['neutral', 'laugh'];
  static const int _minMouthInterval = 85;
  static const int _maxMouthInterval = 105;
  static const int _fadeInDuration = 1000;

  final audioService = locator<AppAudioService>().audioHandler;
  final StreamController<Duration> position = StreamController<Duration>.broadcast();
  final Map<String, Timer> _mouthAnimationTimers = {};

  Scene? _scene;
  String? _currentBackground;
  String? get currentBackground => _currentBackground;

  List<CharacterState> _visibleCharacters = [];
  List<CharacterState> get visibleCharacters {
    final sorted = List<CharacterState>.from(_visibleCharacters);
    sorted.sort((a, b) => b.position.z.compareTo(a.position.z));
    return sorted;
  }

  bool _isPlaying = false;
  bool _isFadingIn = false;
  double _audioStartOffset = 0.0;

  Duration searchTimeStamp(bool forwards, int currentPosition, EnglishAudio audio) {
    return Duration(milliseconds: currentPosition + (forwards ? 2000 : -2));
  }

  void initPositionListener() {
    AudioService.position.listen((event) {
      if (position.isClosed) return;
      position.add(event);
      _updateSceneForTime(event);
    });

    audioService.playbackState.listen((state) {
      _isPlaying = state.playing;

      if (!_isPlaying) {
        _stopAllMouthAnimations();
      }

      if (state.processingState == AudioProcessingState.completed) {
        _handleAudioComplete();
      }
    });
  }

  void _handleAudioComplete() {
    _stopAllMouthAnimations();
    _fadeOutCharacters();
  }

  void initScene(Scene scene) {
    _scene = scene;
    _currentBackground = scene.setup.background;

    _visibleCharacters = scene.setup.characters
        .map((char) => CharacterState(
              characterName: char.character,
              position: char.position,
              opacity: 0.0,
              showMouth: true,
              mouthType: 'neutral',
            ))
        .toList();

    notifyListeners();
  }

  Future<void> playWithFadeIn() async {
    if (_isFadingIn) return;

    developer.log('Starting fade-in animation', name: 'SceneViewModel');
    _isFadingIn = true;

    if (_isPlaying) {
      await audioService.pause();
    }

    _updateAllCharacters(opacity: 1.0);
    await Future.delayed(const Duration(milliseconds: _fadeInDuration));
    developer.log('Fade-in complete', name: 'SceneViewModel');

    if (_scene != null) {
      final startTime = double.parse(_scene!.setup.audio.startTime);
      _audioStartOffset = startTime;
      await Future.delayed(Duration(milliseconds: (startTime * 1000).toInt()));
      developer.log('Waited ${startTime}s, now starting audio', name: 'SceneViewModel');
    }

    _isFadingIn = false;
    await audioService.play();
  }

  void _updateSceneForTime(Duration currentTime) {
    if (_scene == null || !_isPlaying) return;

    final currentSeconds = (currentTime.inMilliseconds / 1000) + _audioStartOffset;
    bool sceneChanged = false;
    final Map<String, bool> charactersSpeaking = {};

    for (final command in _scene!.commands) {
      final startTime = command.startTime.toDouble();
      final finishTime = command.finishTime?.toDouble();

      // Track speaking characters
      if (command.dialogue != null) {
        final isSpeaking = finishTime != null
            ? currentSeconds >= startTime && currentSeconds <= finishTime
            : currentSeconds >= startTime;

        if (isSpeaking) charactersSpeaking[command.character] = true;
      }

      // Apply active commands
      if (currentSeconds >= startTime) {
        if (command.background != null && _currentBackground != command.background) {
          _currentBackground = command.background;
          sceneChanged = true;
        }

        sceneChanged |= _updateCharacterState(command);

        // Remove character if expired
        if (finishTime != null && currentSeconds > finishTime && command.opacity == 0) {
          _visibleCharacters.removeWhere((c) => c.characterName == command.character);
          sceneChanged = true;
        }
      }
    }

    _updateMouthAnimations(charactersSpeaking);

    if (sceneChanged) notifyListeners();
  }

  bool _updateCharacterState(SceneCommand command) {
    final characterIndex = _visibleCharacters.indexWhere((c) => c.characterName == command.character);

    if (characterIndex >= 0) {
      final currentChar = _visibleCharacters[characterIndex];
      _visibleCharacters[characterIndex] = currentChar.copyWith(
        position: command.position ?? currentChar.position,
        opacity: command.opacity?.toDouble() ?? 1.0,
      );
      return true;
    } else {
      _visibleCharacters.add(CharacterState(
        characterName: command.character,
        position: command.position ?? const SceneCharacterPosition(x: 0, y: 0, z: 0),
        opacity: command.opacity?.toDouble() ?? 1.0,
      ));
      return true;
    }
  }

  void _updateMouthAnimations(Map<String, bool> charactersSpeaking) {
    // Start animations for speaking characters
    charactersSpeaking.keys
        .where((char) => !_mouthAnimationTimers.containsKey(char))
        .forEach(_startMouthAnimation);

    // Stop animations for silent characters
    _mouthAnimationTimers.keys
        .where((char) => !charactersSpeaking.containsKey(char))
        .toList()
        .forEach(_stopMouthAnimationForCharacter);
  }

  void _startMouthAnimation(String characterName) {
    developer.log('Starting mouth animation for $characterName', name: 'SceneViewModel');

    int cycleCount = 0;
    final random = Random();

    void scheduleMouthUpdate() {
      final interval = _minMouthInterval + random.nextInt(_maxMouthInterval - _minMouthInterval + 1);

      _mouthAnimationTimers[characterName] = Timer(
        Duration(milliseconds: interval),
        () {
          final characterIndex = _visibleCharacters.indexWhere((c) => c.characterName == characterName);

          if (characterIndex >= 0) {
            _visibleCharacters[characterIndex] = _visibleCharacters[characterIndex].copyWith(
              showMouth: true,
              mouthType: _mouthTypes[cycleCount % _mouthTypes.length],
            );
            cycleCount++;
            notifyListeners();
          }

          if (_mouthAnimationTimers.containsKey(characterName)) {
            scheduleMouthUpdate();
          }
        },
      );
    }

    scheduleMouthUpdate();
  }

  void _stopMouthAnimationForCharacter(String characterName) {
    developer.log('Stopping mouth animation for $characterName', name: 'SceneViewModel');

    _mouthAnimationTimers[characterName]?.cancel();
    _mouthAnimationTimers.remove(characterName);

    final characterIndex = _visibleCharacters.indexWhere((c) => c.characterName == characterName);
    if (characterIndex >= 0) {
      _visibleCharacters[characterIndex] = _visibleCharacters[characterIndex].copyWith(
        showMouth: true,
        mouthType: 'neutral',
      );
      notifyListeners();
    }
  }

  void _stopAllMouthAnimations() {
    for (final timer in _mouthAnimationTimers.values) {
      timer.cancel();
    }
    _mouthAnimationTimers.clear();
    _updateAllCharacters(showMouth: true, mouthType: 'neutral');
  }

  void _fadeOutCharacters() {
    _updateAllCharacters(opacity: 0.0);
  }

  void _updateAllCharacters({double? opacity, bool? showMouth, String? mouthType}) {
    for (int i = 0; i < _visibleCharacters.length; i++) {
      _visibleCharacters[i] = _visibleCharacters[i].copyWith(
        opacity: opacity,
        showMouth: showMouth,
        mouthType: mouthType,
      );
    }
    notifyListeners();
  }

  String _buildCharacterUrl(String characterName, String path) {
    final lowerName = characterName.toLowerCase();
    return '$_cdnBase/curriculum/english/animation-assets/images/characters/$lowerName/$path';
  }

  String getBackgroundUrl(String backgroundName) {
    final cleanName = backgroundName.endsWith('.png') ? backgroundName : '$backgroundName.png';
    return '$_cdnBase/curriculum/english/animation-assets/images/backgrounds/$cleanName';
  }

  String getCharacterBaseUrl(String characterName) => _buildCharacterUrl(characterName, 'base.png');
  String getCharacterEyesUrl(String characterName) => _buildCharacterUrl(characterName, 'eyes-open.png');
  String getCharacterMouthUrl(String characterName, String mouthType) =>
      _buildCharacterUrl(characterName, 'mouth-$mouthType.png');

  void onDispose() {
    position.close();
    for (final timer in _mouthAnimationTimers.values) {
      timer.cancel();
    }
    _mouthAnimationTimers.clear();
    audioService.stop();
  }
}
