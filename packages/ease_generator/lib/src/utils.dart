/// Shared utilities for ease code generation.
///
/// Case conversion logic adapted from the recase package:
/// https://github.com/techniboogie-dart/recase

final _upperAlphaRegex = RegExp(r'[A-Z]');
const _symbolSet = {' ', '.', '/', '_', '\\', '-'};

/// Groups text into words by detecting word boundaries.
///
/// Handles PascalCase, camelCase, snake_case, and ALLCAPS.
List<String> _groupIntoWords(String text) {
  final sb = StringBuffer();
  final words = <String>[];
  final isAllCaps = text.toUpperCase() == text;

  for (var i = 0; i < text.length; i++) {
    final char = text[i];
    final nextChar = i + 1 == text.length ? null : text[i + 1];

    if (_symbolSet.contains(char)) {
      continue;
    }

    sb.write(char);

    final isEndOfWord = nextChar == null ||
        (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
        _symbolSet.contains(nextChar);

    if (isEndOfWord) {
      words.add(sb.toString());
      sb.clear();
    }
  }

  return words;
}

/// Converts first character to uppercase.
String _upperCaseFirstLetter(String word) {
  if (word.isEmpty) return word;
  return word[0].toUpperCase() + word.substring(1).toLowerCase();
}

/// Converts PascalCase/snake_case/etc to camelCase.
///
/// Examples:
/// - `CounterState` -> `counterState`
/// - `MyAppState` -> `myAppState`
/// - `HTTPClient` -> `httpClient`
/// - `API_SERVICE` -> `apiService`
/// - `X` -> `x`
String toCamelCase(String text) {
  if (text.isEmpty) return text;

  final words = _groupIntoWords(text).map(_upperCaseFirstLetter).toList();
  if (words.isNotEmpty) {
    words[0] = words[0].toLowerCase();
  }
  return words.join();
}

/// Generates provider class name from state class name.
///
/// Example: `CounterViewModel` -> `CounterViewModelProvider`
String generateProviderName(String className) => '${className}Provider';

/// Generates inherited widget class name from state class name.
///
/// Example: `CounterViewModel` -> `_CounterViewModelInherited`
String generateInheritedName(String className) => '_${className}Inherited';
