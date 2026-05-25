/// Symbol Set Models for the customizable quick-access symbol bar
///
/// Architecture:
/// - [SymbolSetType]: Enum for predefined sets (Python, JavaScript, HTML/CSS)
/// - [SymbolSet]: Base model for any symbol set (predefined or custom)
/// - [PredefinedSymbolSet]: Sealed implementation of predefined sets
/// - [CustomSymbolSet]: User-defined symbol set
/// - [SymbolBarState]: Complete state including active set and enabled custom symbols

enum SymbolSetType {
  python('Python'),
  javascript('JavaScript'),
  htmlCss('HTML/CSS');

  final String displayName;
  const SymbolSetType(this.displayName);

  /// Convert string to enum value (case-insensitive)
  static SymbolSetType fromValue(String value) {
    return SymbolSetType.values.firstWhere(
      (type) => type.name.toLowerCase() == value.toLowerCase(),
      orElse: () => SymbolSetType.python, // Default fallback
    );
  }
}

/// Abstract base class for symbol sets
/// Enables type safety and future extensibility
abstract class SymbolSet {
  String get name;
  List<String> get symbols;
  bool get isCustom;

  /// Create a copy with modified values
  SymbolSet copyWith({List<String>? symbols});

  /// Convert to JSON for storage
  Map<String, dynamic> toJson();

  /// Create from JSON
  factory SymbolSet.fromJson(Map<String, dynamic> json) {
    if (json['isCustom'] == true) {
      return CustomSymbolSet.fromJson(json);
    }
    return PredefinedSymbolSet.fromJson(json);
  }
}

/// Predefined symbol sets (Python, JavaScript, HTML/CSS)
/// Immutable and generated from constants
class PredefinedSymbolSet implements SymbolSet {
  final SymbolSetType type;

  PredefinedSymbolSet(this.type);

  @override
  String get name => type.displayName;

  @override
  List<String> get symbols {
    switch (type) {
      case SymbolSetType.python:
        return _pythonSymbols;
      case SymbolSetType.javascript:
        return _javascriptSymbols;
      case SymbolSetType.htmlCss:
        return _htmlCssSymbols;
    }
  }

  @override
  bool get isCustom => false;

  @override
  SymbolSet copyWith({List<String>? symbols}) {
    // Predefined sets are immutable, return self
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'isCustom': false,
      'symbols': symbols,
    };
  }

  factory PredefinedSymbolSet.fromJson(Map<String, dynamic> json) {
    final type = SymbolSetType.fromValue(json['type'] as String? ?? 'python');
    return PredefinedSymbolSet(type);
  }

  // Python symbol set - ideal for Python, Ruby, and other interpreted languages
  static const List<String> _pythonSymbols = [
    'Tab',
    '(',
    ')',
    '[',
    ']',
    '{',
    '}',
    ':',
    '#',
    'def',
    'class',
    '=',
  ];

  // JavaScript symbol set - ideal for JavaScript, TypeScript, and modern web development
  static const List<String> _javascriptSymbols = [
    '(',
    ')',
    '{',
    '}',
    '[',
    ']',
    ';',
    '=>',
    'const',
    'let',
    'var',
    '=',
  ];

  // HTML/CSS symbol set - ideal for web markup and styling
  static const List<String> _htmlCssSymbols = [
    '<',
    '>',
    '/',
    'class=',
    'id=',
    'div',
    'p',
    'span',
    ';',
    '{',
    '}',
    ':',
  ];
}

/// User-defined custom symbol set
/// Mutable and persisted to SharedPreferences
class CustomSymbolSet implements SymbolSet {
  @override
  final String name;

  @override
  final List<String> symbols;

  CustomSymbolSet({
    required this.name,
    required this.symbols,
  });

  @override
  bool get isCustom => true;

  @override
  SymbolSet copyWith({List<String>? symbols}) {
    return CustomSymbolSet(
      name: name,
      symbols: symbols ?? this.symbols,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbols': symbols,
      'isCustom': true,
    };
  }

  factory CustomSymbolSet.fromJson(Map<String, dynamic> json) {
    return CustomSymbolSet(
      name: json['name'] as String? ?? 'Custom',
      symbols: List<String>.from(json['symbols'] as List? ?? []),
    );
  }
}

/// Complete symbol bar state
/// Used for persistence and reactive state management
class SymbolBarState {
  /// Currently active symbol set (predefined or custom)
  final SymbolSet activeSet;

  /// Whether custom symbols are enabled
  final bool customSymbolsEnabled;

  /// All user-defined custom symbol sets
  final List<CustomSymbolSet> customSymbolSets;

  SymbolBarState({
    required this.activeSet,
    this.customSymbolsEnabled = false,
    this.customSymbolSets = const [],
  });

  /// Get the currently displayed symbols
  List<String> get currentSymbols => activeSet.symbols;

  /// Create a copy with modified values
  SymbolBarState copyWith({
    SymbolSet? activeSet,
    bool? customSymbolsEnabled,
    List<CustomSymbolSet>? customSymbolSets,
  }) {
    return SymbolBarState(
      activeSet: activeSet ?? this.activeSet,
      customSymbolsEnabled: customSymbolsEnabled ?? this.customSymbolsEnabled,
      customSymbolSets: customSymbolSets ?? this.customSymbolSets,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'activeSet': activeSet.toJson(),
      'customSymbolsEnabled': customSymbolsEnabled,
      'customSymbolSets': customSymbolSets.map((s) => s.toJson()).toList(),
    };
  }

  /// Create from JSON
  factory SymbolBarState.fromJson(Map<String, dynamic> json) {
    final activeSetJson = json['activeSet'] as Map<String, dynamic>?;
    final activeSet = activeSetJson != null
        ? SymbolSet.fromJson(activeSetJson)
        : PredefinedSymbolSet(SymbolSetType.python);

    final customSymbolSetsJson = json['customSymbolSets'] as List?;
    final customSymbolSets = (customSymbolSetsJson ?? [])
        .cast<Map<String, dynamic>>()
        .map((s) => CustomSymbolSet.fromJson(s))
        .toList();

    return SymbolBarState(
      activeSet: activeSet,
      customSymbolsEnabled: json['customSymbolsEnabled'] as bool? ?? false,
      customSymbolSets: customSymbolSets,
    );
  }

  /// Create default state (Python set active)
  factory SymbolBarState.defaultState() {
    return SymbolBarState(
      activeSet: PredefinedSymbolSet(SymbolSetType.python),
      customSymbolsEnabled: false,
      customSymbolSets: [],
    );
  }
}
