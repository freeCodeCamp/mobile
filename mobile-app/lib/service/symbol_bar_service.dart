/// Symbol Bar Service
///
/// Responsibilities:
/// - Load and save symbol bar state to SharedPreferences
/// - Switch between predefined symbol sets
/// - Create, update, delete custom symbol sets
/// - Provide reactive updates via listeners
/// - Handle backward compatibility with legacy hardcoded symbols
library;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:freecodecamp/models/symbol_set_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SymbolBarService {
  static const String _activeSetKey = 'symbol_bar_active_set';
  static const String _customSetKey = 'symbol_bar_custom_sets';
  static const String _customEnabledKey = 'symbol_bar_custom_enabled';

  late SharedPreferences _prefs;
  late SymbolBarState _state;

  /// List of listeners called when state changes
  final List<Function(SymbolBarState)> _listeners = [];

  /// Whether the service has been initialized
  bool _initialized = false;

  /// Initialize the service and load persisted state
  Future<void> init(SharedPreferences prefs) async {
    _prefs = prefs;
    await _loadState();
    _initialized = true;
  }

  /// Get current state
  SymbolBarState get state => _state;

  /// Check if initialized
  bool get isInitialized => _initialized;

  /// Add listener for state changes
  void addListener(Function(SymbolBarState) listener) {
    _listeners.add(listener);
  }

  /// Remove listener
  void removeListener(Function(SymbolBarState) listener) {
    _listeners.remove(listener);
  }

  /// Notify all listeners of state change
  void _notifyListeners() {
    for (var listener in _listeners) {
      listener(_state);
    }
  }

  /// Load state from SharedPreferences
  Future<void> _loadState() async {
    try {
      final activeSetJson = _prefs.getString(_activeSetKey);
      final customSetsJson = _prefs.getString(_customSetKey);
      final customEnabled = _prefs.getBool(_customEnabledKey) ?? false;

      if (activeSetJson != null) {
        // Deserialize from JSON
        final activeSet = SymbolSet.fromJson(
          jsonDecode(activeSetJson) as Map<String, dynamic>,
        );

        final customSymbolSets = <CustomSymbolSet>[];
        if (customSetsJson != null) {
          final customList = jsonDecode(customSetsJson) as List;
          customSymbolSets.addAll(
            customList.cast<Map<String, dynamic>>().map(
                  (json) => CustomSymbolSet.fromJson(json),
                ),
          );
        }

        _state = SymbolBarState(
          activeSet: activeSet,
          customSymbolsEnabled: customEnabled,
          customSymbolSets: customSymbolSets,
        );
      } else {
        // First launch: use default state (Python set)
        _state = SymbolBarState.defaultState();
        await _saveState();
      }
    } catch (e) {
      // If deserialization fails, reset to default
      debugPrint('Error loading symbol bar state: $e');
      _state = SymbolBarState.defaultState();
      await _saveState();
    }
  }

  /// Save state to SharedPreferences
  Future<void> _saveState() async {
    try {
      await _prefs.setString(
          _activeSetKey, jsonEncode(_state.activeSet.toJson()));
      await _prefs.setString(
        _customSetKey,
        jsonEncode(_state.customSymbolSets.map((s) => s.toJson()).toList()),
      );
      await _prefs.setBool(_customEnabledKey, _state.customSymbolsEnabled);
      _notifyListeners();
    } catch (e) {
      debugPrint('Error loading symbol bar state: $e');
    }
  }

  /// Switch to a predefined symbol set
  Future<void> switchToPredefinedSet(SymbolSetType type) async {
    final newSet = PredefinedSymbolSet(type);
    _state = _state.copyWith(
      activeSet: newSet,
      customSymbolsEnabled: false,
    );
    await _saveState();
  }

  /// Switch to a custom symbol set by name
  Future<void> switchToCustomSet(String setName) async {
    final customSet = _state.customSymbolSets.firstWhere(
      (set) => set.name == setName,
      orElse: () => throw Exception('Custom set not found: $setName'),
    );
    _state = _state.copyWith(
      activeSet: customSet,
      customSymbolsEnabled: true,
    );
    await _saveState();
  }

  /// Create a new custom symbol set
  Future<void> createCustomSet({
    required String name,
    required List<String> symbols,
  }) async {
    // Validate inputs
    if (name.trim().isEmpty) {
      throw ArgumentError('Custom set name cannot be empty');
    }
    if (symbols.isEmpty) {
      throw ArgumentError('Custom set must contain at least one symbol');
    }
    if (symbols.length > 50) {
      throw ArgumentError('Custom set cannot exceed 50 symbols');
    }

    // Check for duplicate names
    if (_state.customSymbolSets.any((set) => set.name == name)) {
      throw ArgumentError('Custom set with name "$name" already exists');
    }

    final newSet = CustomSymbolSet(name: name, symbols: symbols);
    final newCustomSets = [..._state.customSymbolSets, newSet];

    _state = _state.copyWith(customSymbolSets: newCustomSets);
    await _saveState();
  }

  /// Update an existing custom symbol set
  Future<void> updateCustomSet({
    required String currentName,
    String? newName,
    List<String>? newSymbols,
  }) async {
    final index =
        _state.customSymbolSets.indexWhere((set) => set.name == currentName);
    if (index == -1) {
      throw Exception('Custom set not found: $currentName');
    }

    final currentSet = _state.customSymbolSets[index];
    final updatedName = newName ?? currentSet.name;
    final updatedSymbols = newSymbols ?? currentSet.symbols;

    // Validate
    if (updatedName.trim().isEmpty) {
      throw ArgumentError('Custom set name cannot be empty');
    }
    if (updatedSymbols.isEmpty) {
      throw ArgumentError('Custom set must contain at least one symbol');
    }
    if (updatedSymbols.length > 50) {
      throw ArgumentError('Custom set cannot exceed 50 symbols');
    }

    // Check for duplicate names (excluding current set)
    if (updatedName != currentName &&
        _state.customSymbolSets.any((set) => set.name == updatedName)) {
      throw ArgumentError('Custom set with name "$updatedName" already exists');
    }

    final updatedSet = CustomSymbolSet(
      name: updatedName,
      symbols: updatedSymbols,
    );

    final newCustomSets = [..._state.customSymbolSets];
    newCustomSets[index] = updatedSet;

    // If this was the active set, update the active set reference
    SymbolSet activeSet = _state.activeSet;
    if (activeSet is CustomSymbolSet && activeSet.name == currentName) {
      activeSet = updatedSet;
    }

    _state = _state.copyWith(
      activeSet: activeSet,
      customSymbolSets: newCustomSets,
    );
    await _saveState();
  }

  /// Delete a custom symbol set
  Future<void> deleteCustomSet(String setName) async {
    final index =
        _state.customSymbolSets.indexWhere((set) => set.name == setName);
    if (index == -1) {
      throw Exception('Custom set not found: $setName');
    }

    final newCustomSets = [..._state.customSymbolSets];
    newCustomSets.removeAt(index);

    // If this was the active set, switch back to Python
    SymbolSet activeSet = _state.activeSet;
    if (activeSet is CustomSymbolSet && activeSet.name == setName) {
      activeSet = PredefinedSymbolSet(SymbolSetType.python);
    }

    _state = _state.copyWith(
      activeSet: activeSet,
      customSymbolSets: newCustomSets,
    );
    await _saveState();
  }

  /// Get all available symbol sets (predefined + custom)
  List<SymbolSet> getAllSymbolSets() {
    return [
      PredefinedSymbolSet(SymbolSetType.python),
      PredefinedSymbolSet(SymbolSetType.javascript),
      PredefinedSymbolSet(SymbolSetType.htmlCss),
      ..._state.customSymbolSets,
    ];
  }

  /// Reset custom symbol sets and switch to Python
  Future<void> resetToDefaults() async {
    _state = SymbolBarState.defaultState();
    await _saveState();
  }

  /// Clear all data (useful for testing or factory reset)
  Future<void> clearAll() async {
    await _prefs.remove(_activeSetKey);
    await _prefs.remove(_customSetKey);
    await _prefs.remove(_customEnabledKey);
    _state = SymbolBarState.defaultState();
    _notifyListeners();
  }
}
