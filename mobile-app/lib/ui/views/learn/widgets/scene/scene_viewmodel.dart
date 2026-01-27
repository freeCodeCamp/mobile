import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
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
  final String eyeState;
  final double opacity;

  CharacterState({
    required this.characterName,
    required this.position,
    this.showMouth = false,
    this.mouthType = 'smile',
    this.eyeState = 'open',
    this.opacity = 1.0,
  });

  CharacterState copyWith({
    String? characterName,
    SceneCharacterPosition? position,
    bool? showMouth,
    String? mouthType,
    String? eyeState,
    double? opacity,
  }) {
    return CharacterState(
      characterName: characterName ?? this.characterName,
      position: position ?? this.position,
      showMouth: showMouth ?? this.showMouth,
      mouthType: mouthType ?? this.mouthType,
      eyeState: eyeState ?? this.eyeState,
      opacity: opacity ?? this.opacity,
    );
  }
}

class SceneViewModel extends BaseViewModel {
  static const String _cdnBase = 'https://cdn.freecodecamp.org/curriculum/english/animation-assets/images';
  static const int _minMouthInterval = 85;
  static const int _maxMouthInterval = 105;
  static const int _minBlinkInterval = 2000;
  static const int _maxBlinkInterval = 4000;
  static const int _blinkDuration = 150;

  final audioService = locator<AppAudioService>().audioHandler;
  final _sceneAssetsService = SceneAssetsService();
  SceneAssets? _sceneAssets;
  final StreamController<Duration> position = StreamController<Duration>.broadcast();
  final Map<String, Timer> _mouthAnimationTimers = {};
  final Map<String, Timer> _blinkTimers = {};
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
  bool _backgroundsPreloaded = false;

  String? _currentDialogueCharacter;
  String? _currentDialogueText;
  String? _currentDialogueAlign;
  String? get currentDialogueCharacter => _currentDialogueCharacter;
  String? get currentDialogueText => _currentDialogueText;
  String? get currentDialogueAlign => _currentDialogueAlign;

  bool _showCaptions = false;
  bool get showCaptions => _showCaptions;
  void toggleCaptions() {
    _showCaptions = !_showCaptions;
    notifyListeners();
  }

  // Helper methods for DRY code
  int _findCharacterIndex(String characterName) {
    return _availableCharacters.indexWhere((c) => c.characterName == characterName);
  }

  void _clearTimers(Map<String, Timer> timers) {
    for (final timer in timers.values) {
      timer.cancel();
    }
    timers.clear();
  }

  void _clearDialogue() {
    _currentDialogueCharacter = null;
    _currentDialogueText = null;
    _currentDialogueAlign = null;
  }

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

      if (_isPlaying) {
        _startBlinkAnimations();
      } else {
        _stopAllMouthAnimations();  
        _stopAllBlinkAnimations();
      }

      if (state.processingState == AudioProcessingState.completed && !_isCompleted) {
        _handleAudioComplete();
      }
    });
  }

  void _handleAudioComplete() {
    if (_isCompleted) return;
    _isCompleted = true;
    _clearDialogue();
    _stopAllMouthAnimations();
    _stopAllBlinkAnimations();
    _applyRemainingCommands();
  }

  void _applyRemainingCommands() {
    if (_scene == null) return;

    for (int i = 0; i < _scene!.commands.length; i++) {
      if (!_appliedCommandIndices.contains(i)) {
        final command = _scene!.commands[i];
        _appliedCommandIndices.add(i);

        if (command.background != null && _currentBackground != command.background) {
          _currentBackground = command.background;
        }
        _updateCharacterState(command);
      }
    }
    notifyListeners();
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

    await fetchSceneAssets();
  }

  void preloadBackgrounds(BuildContext context) {
    if (_scene == null || _backgroundsPreloaded) return;
    _backgroundsPreloaded = true;

    final backgrounds = <String>{_scene!.setup.background};
    for (final command in _scene!.commands) {
      if (command.background != null) {
        backgrounds.add(command.background!);
      }
    }

    for (final background in backgrounds) {
      final url = getBackgroundUrl(background);
      precacheImage(CachedNetworkImageProvider(url), context);
    }
  }

  void _initializeCharactersFromSetup() {
    if (_scene == null) return;
    _availableCharacters = _scene!.setup.characters
        .map((char) => CharacterState(
              characterName: char.character,
              position: SceneCharacterPosition(
                x: char.position.x,
                y: char.position.y,
                z: char.position.z,
              ),
              showMouth: true,
              mouthType: 'closed',
              opacity: char.opacity?.toDouble() ?? 1.0,

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
    await audioService.stop();
    await audioService.seek(Duration.zero);
    _reinitializeCharacters();
  }

  void _updateSceneForTime(Duration currentTime) {
    if (_scene == null || !_isPlaying || _isCompleted) return;

    final currentSeconds = (currentTime.inMilliseconds / 1000) + _audioStartOffset;
    bool sceneChanged = false;
    final Map<String, bool> charactersSpeaking = {};

    String? activeDialogueCharacter;
    String? activeDialogueText;
    String? activeDialogueAlign;

    for (int i = 0; i < _scene!.commands.length; i++) {
      final command = _scene!.commands[i];
      final startTime = command.startTime.toDouble();
      final finishTime = command.finishTime?.toDouble();

      if (command.dialogue != null) {
        final isSpeaking = finishTime != null
            ? currentSeconds >= startTime && currentSeconds <= finishTime
            : currentSeconds >= startTime;

        if (isSpeaking) {
          charactersSpeaking[command.character] = true;
          activeDialogueCharacter = command.character;
          activeDialogueText = command.dialogue!.text;
          activeDialogueAlign = command.dialogue!.align;
        }
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

    // Only update dialogue when there's a new active dialogue (keep last one visible)
    if (activeDialogueText != null &&
        (_currentDialogueCharacter != activeDialogueCharacter ||
            _currentDialogueText != activeDialogueText)) {
      _currentDialogueCharacter = activeDialogueCharacter;
      _currentDialogueText = activeDialogueText;
      _currentDialogueAlign = activeDialogueAlign;
      sceneChanged = true;
    }

    _updateMouthAnimations(charactersSpeaking);

    if (sceneChanged) notifyListeners();
  }

  bool _updateCharacterState(SceneCommand command) {
    final characterIndex = _findCharacterIndex(command.character);

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
    final random = Random();

    final characterIndex = _findCharacterIndex(characterName);
    if (characterIndex >= 0) {
      _availableCharacters[characterIndex] = _availableCharacters[characterIndex].copyWith(
        showMouth: true,
        mouthType: 'open',
      );
      notifyListeners();
    }

    void scheduleMouthUpdate(String nextMouthType) {
      final interval = _minMouthInterval + random.nextInt(_maxMouthInterval - _minMouthInterval + 1);

      _mouthAnimationTimers[characterName] = Timer(
        Duration(milliseconds: interval),
        () {
          final idx = _findCharacterIndex(characterName);

          if (idx >= 0) {
            _availableCharacters[idx] = _availableCharacters[idx].copyWith(
              showMouth: true,
              mouthType: nextMouthType,
            );
            notifyListeners();
          }

          if (_mouthAnimationTimers.containsKey(characterName)) {
            scheduleMouthUpdate(nextMouthType == 'open' ? 'closed' : 'open');
          }
        },
      );
    }

    scheduleMouthUpdate('closed');
  }

  void _stopMouthAnimationForCharacter(String characterName) {
    _mouthAnimationTimers[characterName]?.cancel();
    _mouthAnimationTimers.remove(characterName);

    final characterIndex = _findCharacterIndex(characterName);
    if (characterIndex >= 0) {
      _availableCharacters[characterIndex] = _availableCharacters[characterIndex].copyWith(
        showMouth: true,
        mouthType: 'closed',
      );
      notifyListeners();
    }
  }

  void _stopAllMouthAnimations() {
    _clearTimers(_mouthAnimationTimers);
    _updateAllCharacters(showMouth: true, mouthType: 'closed');
  }

  void _startBlinkAnimations() {
    for (final character in _availableCharacters) {
      _startBlinkAnimation(character.characterName);
    }
  }

  void _startBlinkAnimation(String characterName) {
    if (_blinkTimers.containsKey(characterName)) return;

    final random = Random();

    void scheduleNextBlink() {
      final interval =
          _minBlinkInterval + random.nextInt(_maxBlinkInterval - _minBlinkInterval + 1);

      _blinkTimers[characterName] = Timer(
        Duration(milliseconds: interval),
        () {
          final characterIndex = _findCharacterIndex(characterName);

          if (characterIndex >= 0) {
            // Close eyes
            _availableCharacters[characterIndex] =
                _availableCharacters[characterIndex].copyWith(eyeState: 'closed');
            notifyListeners();

            // Open eyes after blink duration
            Future.delayed(Duration(milliseconds: _blinkDuration), () {
              final idx = _findCharacterIndex(characterName);
              if (idx >= 0 && _blinkTimers.containsKey(characterName)) {
                _availableCharacters[idx] =
                    _availableCharacters[idx].copyWith(eyeState: 'open');
                notifyListeners();
              }
            });
          }

          if (_blinkTimers.containsKey(characterName)) {
            scheduleNextBlink();
          }
        },
      );
    }

    scheduleNextBlink();
  }

  void _stopAllBlinkAnimations() {
    _clearTimers(_blinkTimers);
  }

  void _reinitializeCharacters() {
    _clearDialogue();
    _stopAllBlinkAnimations();
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

  String getCharacterEyesUrl(String characterName, String eyeState) {
    final assets = _getCharacterAssets(characterName);
    if (assets != null) {
      return eyeState == 'closed' ? assets.eyesClosed : assets.eyesOpen;
    }
    return _buildFallbackUrl(
        characterName, eyeState == 'closed' ? 'eyes-closed.png' : 'eyes-open.png');
  }

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
    _clearTimers(_mouthAnimationTimers);
    _clearTimers(_blinkTimers);
    audioService.stop();
  }
}
