import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/models/symbol_set_model.dart';
import 'package:freecodecamp/service/symbol_bar_service.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('SymbolSetModel Tests', () {
    test('SymbolSetType.fromValue should parse string correctly', () {
      expect(SymbolSetType.fromValue('python'), SymbolSetType.python);
      expect(SymbolSetType.fromValue('PYTHON'), SymbolSetType.python);
      expect(SymbolSetType.fromValue('javascript'), SymbolSetType.javascript);
      expect(SymbolSetType.fromValue('htmlCss'), SymbolSetType.htmlCss);
      expect(SymbolSetType.fromValue('invalid'), SymbolSetType.python); // Default fallback
    });

    test('PredefinedSymbolSet should return correct symbols', () {
      final pythonSet = PredefinedSymbolSet(SymbolSetType.python);
      expect(pythonSet.symbols.length, 12);
      expect(pythonSet.symbols.contains('def'), true);
      expect(pythonSet.symbols.contains('class'), true);

      final jsSet = PredefinedSymbolSet(SymbolSetType.javascript);
      expect(jsSet.symbols.length, 12);
      expect(jsSet.symbols.contains('=>'), true);
      expect(jsSet.symbols.contains('const'), true);

      final htmlCssSet = PredefinedSymbolSet(SymbolSetType.htmlCss);
      expect(htmlCssSet.symbols.length, 12);
      expect(htmlCssSet.symbols.contains('div'), true);
      expect(htmlCssSet.symbols.contains('class='), true);
    });

    test('PredefinedSymbolSet should not be custom', () {
      final set = PredefinedSymbolSet(SymbolSetType.python);
      expect(set.isCustom, false);
    });

    test('PredefinedSymbolSet.copyWith should return self', () {
      final set = PredefinedSymbolSet(SymbolSetType.python);
      final copied = set.copyWith(symbols: ['new']);
      expect(identical(set, copied), true);
    });

    test('PredefinedSymbolSet.toJson should serialize correctly', () {
      final set = PredefinedSymbolSet(SymbolSetType.python);
      final json = set.toJson();
      expect(json['type'], 'python');
      expect(json['isCustom'], false);
      expect(json['symbols'], isA<List>());
    });

    test('CustomSymbolSet should be custom', () {
      final set = CustomSymbolSet(name: 'My Set', symbols: ['a', 'b']);
      expect(set.isCustom, true);
    });

    test('CustomSymbolSet.copyWith should create new instance', () {
      final set = CustomSymbolSet(name: 'My Set', symbols: ['a', 'b']);
      final copied = set.copyWith(symbols: ['c', 'd']);
      expect(identical(set, copied), false);
      expect(copied.name, 'My Set');
      expect(copied.symbols, ['c', 'd']);
    });

    test('CustomSymbolSet.toJson should serialize correctly', () {
      final set = CustomSymbolSet(name: 'My Set', symbols: ['a', 'b']);
      final json = set.toJson();
      expect(json['name'], 'My Set');
      expect(json['isCustom'], true);
      expect(json['symbols'], ['a', 'b']);
    });

    test('CustomSymbolSet.fromJson should deserialize correctly', () {
      final json = {
        'name': 'My Set',
        'symbols': ['a', 'b', 'c'],
        'isCustom': true,
      };
      final set = CustomSymbolSet.fromJson(json);
      expect(set.name, 'My Set');
      expect(set.symbols, ['a', 'b', 'c']);
    });

    test('SymbolSet.fromJson should create correct instance', () {
      final predefinedJson = {
        'type': 'python',
        'isCustom': false,
      };
      final predefined = SymbolSet.fromJson(predefinedJson);
      expect(predefined is PredefinedSymbolSet, true);

      final customJson = {
        'name': 'Custom',
        'symbols': ['x', 'y'],
        'isCustom': true,
      };
      final custom = SymbolSet.fromJson(customJson);
      expect(custom is CustomSymbolSet, true);
    });

    test('SymbolBarState should have correct currentSymbols', () {
      final set = PredefinedSymbolSet(SymbolSetType.python);
      final state = SymbolBarState(activeSet: set);
      expect(state.currentSymbols, set.symbols);
    });

    test('SymbolBarState.copyWith should create new instance', () {
      final set1 = PredefinedSymbolSet(SymbolSetType.python);
      final set2 = PredefinedSymbolSet(SymbolSetType.javascript);
      final state1 = SymbolBarState(activeSet: set1);
      final state2 = state1.copyWith(activeSet: set2);

      expect(identical(state1, state2), false);
      expect(state1.activeSet, set1);
      expect(state2.activeSet, set2);
    });

    test('SymbolBarState.defaultState should return Python set', () {
      final state = SymbolBarState.defaultState();
      expect(state.activeSet is PredefinedSymbolSet, true);
      expect(
        (state.activeSet as PredefinedSymbolSet).type,
        SymbolSetType.python,
      );
      expect(state.customSymbolsEnabled, false);
      expect(state.customSymbolSets.isEmpty, true);
    });

    test('SymbolBarState.toJson and fromJson should round-trip', () {
      final customSet =
          CustomSymbolSet(name: 'Test Set', symbols: ['a', 'b']);
      final originalState = SymbolBarState(
        activeSet: customSet,
        customSymbolsEnabled: true,
        customSymbolSets: [customSet],
      );

      final json = originalState.toJson();
      final restoredState = SymbolBarState.fromJson(json);

      expect(restoredState.activeSet is CustomSymbolSet, true);
      expect((restoredState.activeSet as CustomSymbolSet).name, 'Test Set');
      expect(restoredState.customSymbolsEnabled, true);
      expect(restoredState.customSymbolSets.length, 1);
    });
  });

  group('SymbolBarService Tests', () {
    late MockSharedPreferences mockPrefs;
    late SymbolBarService service;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      service = SymbolBarService();
    });

    test('init should load default state when no saved state exists', () async {
      // Setup mock to return null (no saved state)
      when(mockPrefs.getString(any)).thenReturn(null);
      when(mockPrefs.getBool(any)).thenReturn(null);

      await service.init(mockPrefs);

      expect(service.state.activeSet is PredefinedSymbolSet, true);
      expect(
        (service.state.activeSet as PredefinedSymbolSet).type,
        SymbolSetType.python,
      );
    });

    test('switchToPredefinedSet should change active set', () async {
      when(mockPrefs.getString(any)).thenReturn(null);
      when(mockPrefs.getBool(any)).thenReturn(null);
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);

      await service.init(mockPrefs);

      await service.switchToPredefinedSet(SymbolSetType.javascript);

      expect(service.state.activeSet is PredefinedSymbolSet, true);
      expect(
        (service.state.activeSet as PredefinedSymbolSet).type,
        SymbolSetType.javascript,
      );
    });

    test('createCustomSet should add new custom set', () async {
      when(mockPrefs.getString(any)).thenReturn(null);
      when(mockPrefs.getBool(any)).thenReturn(null);
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);

      await service.init(mockPrefs);

      await service.createCustomSet(
        name: 'Test Set',
        symbols: ['a', 'b', 'c'],
      );

      expect(service.state.customSymbolSets.length, 1);
      expect(service.state.customSymbolSets[0].name, 'Test Set');
      expect(service.state.customSymbolSets[0].symbols, ['a', 'b', 'c']);
    });

    test('createCustomSet should reject empty name', () async {
      when(mockPrefs.getString(any)).thenReturn(null);
      when(mockPrefs.getBool(any)).thenReturn(null);

      await service.init(mockPrefs);

      expect(
        () => service.createCustomSet(
          name: '',
          symbols: ['a'],
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('createCustomSet should reject empty symbols', () async {
      when(mockPrefs.getString(any)).thenReturn(null);
      when(mockPrefs.getBool(any)).thenReturn(null);

      await service.init(mockPrefs);

      expect(
        () => service.createCustomSet(
          name: 'Test',
          symbols: [],
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('createCustomSet should reject duplicate names', () async {
      when(mockPrefs.getString(any)).thenReturn(null);
      when(mockPrefs.getBool(any)).thenReturn(null);
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);

      await service.init(mockPrefs);

      await service.createCustomSet(
        name: 'Test Set',
        symbols: ['a', 'b'],
      );

      expect(
        () => service.createCustomSet(
          name: 'Test Set',
          symbols: ['c', 'd'],
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('updateCustomSet should modify existing set', () async {
      when(mockPrefs.getString(any)).thenReturn(null);
      when(mockPrefs.getBool(any)).thenReturn(null);
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);

      await service.init(mockPrefs);

      await service.createCustomSet(
        name: 'Original',
        symbols: ['a', 'b'],
      );

      await service.updateCustomSet(
        currentName: 'Original',
        newName: 'Updated',
        newSymbols: ['c', 'd', 'e'],
      );

      expect(service.state.customSymbolSets[0].name, 'Updated');
      expect(service.state.customSymbolSets[0].symbols, ['c', 'd', 'e']);
    });

    test('deleteCustomSet should remove set', () async {
      when(mockPrefs.getString(any)).thenReturn(null);
      when(mockPrefs.getBool(any)).thenReturn(null);
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);

      await service.init(mockPrefs);

      await service.createCustomSet(
        name: 'Test Set',
        symbols: ['a', 'b'],
      );

      await service.deleteCustomSet('Test Set');

      expect(service.state.customSymbolSets.isEmpty, true);
    });

    test('deleteCustomSet should switch to Python if active', () async {
      when(mockPrefs.getString(any)).thenReturn(null);
      when(mockPrefs.getBool(any)).thenReturn(null);
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);

      await service.init(mockPrefs);

      final customSet = CustomSymbolSet(
        name: 'Active Set',
        symbols: ['a', 'b'],
      );
      final newState = service.state.copyWith(activeSet: customSet);
      service.state == newState;

      await service.deleteCustomSet('Active Set');

      expect(service.state.activeSet is PredefinedSymbolSet, true);
      expect(
        (service.state.activeSet as PredefinedSymbolSet).type,
        SymbolSetType.python,
      );
    });

    test('getAllSymbolSets should return all sets', () async {
      when(mockPrefs.getString(any)).thenReturn(null);
      when(mockPrefs.getBool(any)).thenReturn(null);
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);

      await service.init(mockPrefs);

      await service.createCustomSet(
        name: 'Custom 1',
        symbols: ['a'],
      );

      final allSets = service.getAllSymbolSets();

      // 3 predefined + 1 custom
      expect(allSets.length, 4);
      expect(
        allSets.where((s) => s is PredefinedSymbolSet).length,
        3,
      );
      expect(
        allSets.where((s) => s is CustomSymbolSet).length,
        1,
      );
    });

    test('resetToDefaults should clear all custom sets', () async {
      when(mockPrefs.getString(any)).thenReturn(null);
      when(mockPrefs.getBool(any)).thenReturn(null);
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);

      await service.init(mockPrefs);

      await service.createCustomSet(
        name: 'Custom Set',
        symbols: ['a'],
      );

      await service.resetToDefaults();

      expect(service.state.customSymbolSets.isEmpty, true);
      expect(service.state.activeSet is PredefinedSymbolSet, true);
      expect(
        (service.state.activeSet as PredefinedSymbolSet).type,
        SymbolSetType.python,
      );
    });

    test('listeners should be notified on state change', () async {
      when(mockPrefs.getString(any)).thenReturn(null);
      when(mockPrefs.getBool(any)).thenReturn(null);
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
      when(mockPrefs.setBool(any, any)).thenAnswer((_) async => true);

      await service.init(mockPrefs);

      var callCount = 0;
      service.addListener((_) => callCount++);

      await service.switchToPredefinedSet(SymbolSetType.javascript);

      expect(callCount, greaterThan(0));
    });
  });
}
