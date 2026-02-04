import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:freecodecamp/models/learn/scene_assets_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';

class SceneAssetsService {
  static final SceneAssetsService _instance = SceneAssetsService._internal();
  factory SceneAssetsService() => _instance;
  SceneAssetsService._internal();

  final Dio _dio = DioService.dio;
  static final _baseUrl = '${AuthenticationService.baseURL}/curriculum-data/v2';

  SceneAssets? _cachedAssets;
  bool _isLoading = false;

  SceneAssets? get cachedAssets => _cachedAssets;
  bool get isLoaded => _cachedAssets != null;

  Future<SceneAssets?> fetchSceneAssets() async {
    if (_cachedAssets != null) return _cachedAssets;
    if (_isLoading) return null;

    _isLoading = true;

    try {
      developer.log('Fetching scene assets...', name: 'SceneAssetsService');
      final response = await _dio.get('$_baseUrl/scene-assets.json');
      _cachedAssets = SceneAssets.fromJson(response.data);
      developer.log(
        'Scene assets loaded: ${_cachedAssets!.characterAssets.length} characters',
        name: 'SceneAssetsService',
      );
      return _cachedAssets;
    } catch (e) {
      developer.log('Failed to fetch scene assets: $e', name: 'SceneAssetsService');
      return null;
    } finally {
      _isLoading = false;
    }
  }

  CharacterAssets? getCharacterAssets(String characterName) {
    return _cachedAssets?.characterAssets[characterName];
  }

  String? getBackgroundUrl(String backgroundName) {
    if (_cachedAssets == null) return null;
    final cleanName = backgroundName.endsWith('.png') ? backgroundName : '$backgroundName.png';
    return '${_cachedAssets!.backgrounds}/$cleanName';
  }
}
