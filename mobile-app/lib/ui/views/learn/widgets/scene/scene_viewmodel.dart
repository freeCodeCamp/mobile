import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/scheduler.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/scene_assets_model.dart';
import 'package:freecodecamp/service/audio/audio_service.dart';
import 'package:freecodecamp/service/learn/scene_assets_service.dart';
import 'package:stacked/stacked.dart';

class CharacterState {
  final String characterName;
  final SceneCharacterPosition position;
  final bool showMouth;
  final String mouthType;
  final double opacity;

  CharacterState({
    required this.characterName,
    required this.position,
    this.showMouth = false,
    this.mouthType = 'smile',
    this.opacity = 1.0,
  });

  CharacterState copyWith({
    String? characterName,
    SceneCharacterPosition? position,
    bool? showMouth,
    String? mouthType,
    double? opacity,
  }) {
    return CharacterState(
      characterName: characterName ?? this.characterName,
      position: position ?? this.position,
      showMouth: showMouth ?? this.showMouth,
      mouthType: mouthType ?? this.mouthType,
      opacity: opacity ?? this.opacity,
    );
  }
}

class SceneViewModel extends BaseViewModel {
  static const String _cdnBase = 'https://cdn.freecodecamp.org/curriculum/english/animation-assets/images';
  static const List<String> _mouthTypes = ['closed', 'open'];
  static const int _minMouthInterval = 85;
  static const int _maxMouthInterval = 105;

  final audioService = locator<AppAudioService>().audioHandler;
  final _sceneAssetsService = SceneAssetsService();
  SceneAssets? _sceneAssets;
  final StreamController<Duration> position = StreamController<Duration>.broadcast();
  final Map<String, Timer> _mouthAnimationTimers = {};
  final Set<int> _appliedCommandIndices = {};

  Scene? _scene;
  String? _currentBackground;
  String? get currentBackground => _currentBackground;

  List<CharacterState> _availableCharacters = [];
  List<CharacterState> get visibleCharacters {
    final sorted = List<CharacterState>.from(_availableCharacters);
    sorted.sort((a, b) => b.position.z.compareTo(a.position.z));
    return sorted;
  }

  bool _isPlaying = false;
  bool _isCompleted = false;
  double _audioStartOffset = 0.0;
  bool _hasStarted = false;

  Future<void> onPlay() async {
    if (_hasStarted && !_isCompleted) {
      await audioService.play();
      return;
    }

    if (_isCompleted) {
      await prepareForReplay();
    }

    _hasStarted = true;
    _applyInitialCommands();
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));
    await startAudio();
  }

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

      if (state.processingState == AudioProcessingState.completed && !_isCompleted) {
        _handleAudioComplete();
      }
    });
  }

  void _handleAudioComplete() {
    if (_isCompleted) return;
    _isCompleted = true;
    _stopAllMouthAnimations();
  }

  Future<void> initScene(Scene scene) async {
    _scene = scene;
    _currentBackground = scene.setup.background;
    _initializeCharactersFromSetup();

    notifyListeners();

    // Force another rebuild after the first frame to ensure correct layout constraints
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    fetchSceneAssets();
  }

  void _initializeCharactersFromSetup() {
    if (_scene == null) return;
    _availableCharacters = _scene!.setup.characters
        .map((char) => CharacterState(
              characterName: char.character,
              position: SceneCharacterPosition(
                x: char.position.x,
                y: char.position.y,
                z: 1.0,
              ),
              showMouth: true,
              mouthType: 'closed',
            ))
        .toList();
  }

  void _applyInitialCommands() {
    if (_scene == null) return;

    // Apply all commands that happen before the audio starts
    final audioStartTime = double.tryParse(_scene!.setup.audio.startTime) ?? 0.0;

    for (final command in _scene!.commands) {
      final startTime = command.startTime.toDouble();
      // Apply commands that happen before audio starts (characters should be in position)
      if (startTime < audioStartTime) {
        if (command.background != null) {
          _currentBackground = command.background;
        }
        _updateCharacterState(command);
      }
    }
  }

  Future<void> startAudio() async {
    _isCompleted = false;
    _appliedCommandIndices.clear();

    if (_scene != null) {
      final startTime = double.parse(_scene!.setup.audio.startTime);
      _audioStartOffset = startTime;
      if (startTime > 0) {
        await Future.delayed(Duration(milliseconds: (startTime * 1000).toInt()));
      }
    }

    await audioService.play();
  }

  Future<void> prepareForReplay() async {
    await audioService.seek(Duration.zero);
    _reinitializeCharacters();
  }

  void _updateSceneForTime(Duration currentTime) {
    if (_scene == null || !_isPlaying || _isCompleted) return;

    final currentSeconds = (currentTime.inMilliseconds / 1000) + _audioStartOffset;
    bool sceneChanged = false;
    final Map<String, bool> charactersSpeaking = {};

    for (int i = 0; i < _scene!.commands.length; i++) {
      final command = _scene!.commands[i];
      final startTime = command.startTime.toDouble();
      final finishTime = command.finishTime?.toDouble();

      if (command.dialogue != null) {
        final isSpeaking = finishTime != null
            ? currentSeconds >= startTime && currentSeconds <= finishTime
            : currentSeconds >= startTime;

        if (isSpeaking) charactersSpeaking[command.character] = true;
      }

      if (currentSeconds >= startTime && !_appliedCommandIndices.contains(i)) {
        _appliedCommandIndices.add(i);

        if (command.background != null && _currentBackground != command.background) {
          _currentBackground = command.background;
          sceneChanged = true;
        }

        sceneChanged |= _updateCharacterState(command);
      }
    }

    _updateMouthAnimations(charactersSpeaking);

    if (sceneChanged) notifyListeners();
  }

  bool _updateCharacterState(SceneCommand command) {
    final characterIndex = _availableCharacters.indexWhere((c) => c.characterName == command.character);

    if (characterIndex >= 0) {
      final newPosition = command.position;
      final newOpacity = command.opacity;

      if (newPosition == null && newOpacity == null) return false;

      _availableCharacters[characterIndex] = _availableCharacters[characterIndex].copyWith(
        position: newPosition,
        opacity: newOpacity?.toDouble(),
      );
      return true;
    } else {
      _availableCharacters.add(CharacterState(
        characterName: command.character,
        position: command.position ?? const SceneCharacterPosition(x: 0, y: 0, z: 0),
        showMouth: true,
        mouthType: 'closed',
        opacity: command.opacity?.toDouble() ?? 1.0,
      ));
      return true;
    }
  }

  void _updateMouthAnimations(Map<String, bool> charactersSpeaking) {
    charactersSpeaking.keys
        .where((char) => !_mouthAnimationTimers.containsKey(char))
        .forEach(_startMouthAnimation);

    _mouthAnimationTimers.keys
        .where((char) => !charactersSpeaking.containsKey(char))
        .toList()
        .forEach(_stopMouthAnimationForCharacter);
  }

  void _startMouthAnimation(String characterName) {
    int cycleCount = 0;
    final random = Random();

    void scheduleMouthUpdate() {
      final interval = _minMouthInterval + random.nextInt(_maxMouthInterval - _minMouthInterval + 1);

      _mouthAnimationTimers[characterName] = Timer(
        Duration(milliseconds: interval),
        () {
          final characterIndex = _availableCharacters.indexWhere((c) => c.characterName == characterName);

          if (characterIndex >= 0) {
            _availableCharacters[characterIndex] = _availableCharacters[characterIndex].copyWith(
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
    _mouthAnimationTimers[characterName]?.cancel();
    _mouthAnimationTimers.remove(characterName);

    final characterIndex = _availableCharacters.indexWhere((c) => c.characterName == characterName);
    if (characterIndex >= 0) {
      _availableCharacters[characterIndex] = _availableCharacters[characterIndex].copyWith(
        showMouth: true,
        mouthType: 'closed',
      );
      notifyListeners();
    }
  }

  void _stopAllMouthAnimations() {
    for (final timer in _mouthAnimationTimers.values) {
      timer.cancel();
    }
    _mouthAnimationTimers.clear();
    _updateAllCharacters(showMouth: true, mouthType: 'closed');
  }

  void _reinitializeCharacters() {
    _initializeCharactersFromSetup();
    notifyListeners();
  }

  void _updateAllCharacters({bool? showMouth, String? mouthType}) {
    for (int i = 0; i < _availableCharacters.length; i++) {
      _availableCharacters[i] = _availableCharacters[i].copyWith(
        showMouth: showMouth,
        mouthType: mouthType,
      );
    }
    notifyListeners();
  }

  Future<void> fetchSceneAssets() async {
    _sceneAssets = await _sceneAssetsService.fetchSceneAssets();
  }

  CharacterAssets? _getCharacterAssets(String characterName) {
    return _sceneAssets?.characterAssets[characterName];
  }

  String _buildFallbackUrl(String characterName, String asset) {
    return '$_cdnBase/characters/${characterName.toLowerCase()}/$asset';
  }

  String getBackgroundUrl(String backgroundName) {
    final cleanName = backgroundName.endsWith('.png') ? backgroundName : '$backgroundName.png';
    if (_sceneAssets != null) {
      return '${_sceneAssets!.backgrounds}/$cleanName';
    }
    return '$_cdnBase/backgrounds/$cleanName';
  }

  String getCharacterBaseUrl(String characterName) =>
      _getCharacterAssets(characterName)?.base ?? _buildFallbackUrl(characterName, 'base.png');

  String getCharacterBrowsUrl(String characterName) =>
      _getCharacterAssets(characterName)?.brows ?? _buildFallbackUrl(characterName, 'brows.png');

  String getCharacterEyesUrl(String characterName) =>
      _getCharacterAssets(characterName)?.eyesOpen ?? _buildFallbackUrl(characterName, 'eyes-open.png');

  String? getCharacterGlassesUrl(String characterName) => _getCharacterAssets(characterName)?.glasses;

  String getCharacterMouthUrl(String characterName, String mouthType) {
    final assets = _getCharacterAssets(characterName);
    if (assets != null) {
      return mouthType == 'open' ? assets.mouthOpen : assets.mouthClosed;
    }
    return _buildFallbackUrl(characterName, mouthType == 'open' ? 'mouth-open.png' : 'mouth-closed.png');
  }

  void onDispose() {
    position.close();
    for (final timer in _mouthAnimationTimers.values) {
      timer.cancel();
    }
    _mouthAnimationTimers.clear();
    audioService.stop();
  }
}
