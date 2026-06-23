/// Symbol Bar ViewModel
///
/// Responsible for managing the symbol bar UI state and interactions.
/// Uses Stacked MVVM pattern for reactive updates.
///
/// Key Responsibilities:
/// - Reactive state management for symbol sets and custom symbols
/// - Handle user interactions (switching sets, creating/editing symbols)
/// - Provide getters for the view layer to observe
/// - Integrate with SymbolBarService for persistence
library;

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/symbol_set_model.dart';
import 'package:freecodecamp/service/symbol_bar_service.dart';
import 'package:stacked/stacked.dart';

class SymbolBarViewModel extends BaseViewModel {
  final SymbolBarService _symbolBarService = locator<SymbolBarService>();

  // State getters
  SymbolBarState get state => _symbolBarService.state;
  List<String> get currentSymbols => _symbolBarService.state.currentSymbols;
  SymbolSet get activeSet => _symbolBarService.state.activeSet;
  List<CustomSymbolSet> get customSymbolSets =>
      _symbolBarService.state.customSymbolSets;
  bool get customSymbolsEnabled => _symbolBarService.state.customSymbolsEnabled;

  // All available symbol sets (predefined + custom)
  List<SymbolSet> get allSymbolSets => _symbolBarService.getAllSymbolSets();

  // Predefined symbol sets
  List<PredefinedSymbolSet> get predefinedSets => [
        PredefinedSymbolSet(SymbolSetType.python),
        PredefinedSymbolSet(SymbolSetType.javascript),
        PredefinedSymbolSet(SymbolSetType.htmlCss),
      ];

  /// Initialize the ViewModel and set up listeners
  void init() {
    _symbolBarService.addListener(_onSymbolBarStateChanged);
  }

  /// Clean up resources
  @override
  void dispose() {
    _symbolBarService.removeListener(_onSymbolBarStateChanged);
    super.dispose();
  }

  /// Called whenever the symbol bar state changes
  /// Triggers UI rebuild via notifyListeners()
  void _onSymbolBarStateChanged(SymbolBarState newState) {
    notifyListeners();
  }

  // ==================== PREDEFINED SETS ====================

  /// Switch to a predefined symbol set
  Future<void> switchToPredefinedSet(SymbolSetType type) async {
    await _symbolBarService.switchToPredefinedSet(type);
  }

  // ==================== CUSTOM SETS ====================

  /// Create a new custom symbol set
  ///
  /// Throws ArgumentError if:
  /// - name is empty
  /// - symbols list is empty or > 50
  /// - name already exists
  Future<void> createCustomSet({
    required String name,
    required List<String> symbols,
  }) async {
    try {
      await _symbolBarService.createCustomSet(
        name: name,
        symbols: symbols,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Update an existing custom symbol set
  ///
  /// Throws Exception if set not found
  Future<void> updateCustomSet({
    required String currentName,
    String? newName,
    List<String>? newSymbols,
  }) async {
    try {
      await _symbolBarService.updateCustomSet(
        currentName: currentName,
        newName: newName,
        newSymbols: newSymbols,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a custom symbol set
  ///
  /// If it's currently active, switches to Python set
  Future<void> deleteCustomSet(String setName) async {
    try {
      await _symbolBarService.deleteCustomSet(setName);
    } catch (e) {
      rethrow;
    }
  }

  /// Switch to a custom symbol set by name
  Future<void> switchToCustomSet(String setName) async {
    try {
      await _symbolBarService.switchToCustomSet(setName);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== UTILITIES ====================

  /// Check if a custom set name already exists
  bool customSetNameExists(String name) {
    return customSymbolSets.any((set) => set.name == name);
  }

  /// Get a custom set by name
  CustomSymbolSet? getCustomSetByName(String name) {
    try {
      return customSymbolSets.firstWhere((set) => set.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Reset all custom symbol sets and switch to Python
  Future<void> resetToDefaults() async {
    await _symbolBarService.resetToDefaults();
  }

  /// Get display name for the active set
  String getActiveSetDisplayName() {
    if (activeSet is PredefinedSymbolSet) {
      return (activeSet as PredefinedSymbolSet).type.displayName;
    } else if (activeSet is CustomSymbolSet) {
      return (activeSet as CustomSymbolSet).name;
    }
    return 'Unknown';
  }

  /// Validate symbol (not empty, reasonable length)
  bool isValidSymbol(String symbol) {
    return symbol.isNotEmpty && symbol.length <= 50;
  }

  /// Validate symbol list
  bool isValidSymbolList(List<String> symbols) {
    return symbols.isNotEmpty &&
        symbols.length <= 50 &&
        symbols.every(isValidSymbol);
  }
}
