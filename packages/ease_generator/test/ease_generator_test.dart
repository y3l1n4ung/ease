import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:ease_generator/builder.dart';
import 'package:ease_generator/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('toCamelCase', () {
    test('converts PascalCase to camelCase', () {
      expect(toCamelCase('CounterState'), 'counterState');
      expect(toCamelCase('MyAppState'), 'myAppState');
      expect(toCamelCase('UserViewModel'), 'userViewModel');
    });

    test('handles single character', () {
      expect(toCamelCase('X'), 'x');
      expect(toCamelCase('A'), 'a');
    });

    test('handles already lowercase first char', () {
      expect(toCamelCase('counter'), 'counter');
    });

    test('handles empty string', () {
      expect(toCamelCase(''), '');
    });

    test('handles acronyms (preserves recase behavior)', () {
      // Mixed case acronyms split on each uppercase letter
      // This matches recase library behavior
      expect(toCamelCase('HTTPClient'), 'hTTPClient');
      expect(toCamelCase('APIService'), 'aPIService');
      // All-caps are treated as single word
      expect(toCamelCase('HTTP'), 'http');
      expect(toCamelCase('API'), 'api');
    });

    test('handles snake_case input', () {
      expect(toCamelCase('my_app_state'), 'myAppState');
      expect(toCamelCase('counter_view_model'), 'counterViewModel');
    });
  });

  group('generateProviderName', () {
    test('adds Provider suffix', () {
      expect(generateProviderName('CounterState'), 'CounterStateProvider');
      expect(generateProviderName('CartViewModel'), 'CartViewModelProvider');
      expect(generateProviderName('Auth'), 'AuthProvider');
    });
  });

  group('generateInheritedName', () {
    test('adds underscore prefix and Inherited suffix', () {
      expect(generateInheritedName('CounterState'), '_CounterStateInherited');
      expect(generateInheritedName('Cart'), '_CartInherited');
      expect(generateInheritedName('X'), '_XInherited');
    });
  });

  group('EaseGenerator pipeline', () {
    test('generates Provider widget for annotated class', () async {
      final builder = easeBuilder(BuilderOptions.empty);

      await testBuilder(
        builder,
        {
          'ease_annotation|lib/ease_annotation.dart': '''
library ease_annotation;
class ease {
  const ease();
}
''',
          'ease|lib/src/state_notifier.dart': '''
class StateNotifier<T> {
  StateNotifier(this._state);
  T _state;
  T get state => _state;
  set state(T value) {
    _state = value;
  }
}
''',
          'a|lib/counter.dart': '''
import 'package:ease_annotation/ease_annotation.dart';
import 'package:ease/src/state_notifier.dart';

part 'counter.ease.dart';

@ease()
class CounterViewModel extends StateNotifier<int> {
  CounterViewModel() : super(0);
  void increment() => state++;
}
''',
        },
        generateFor: {'a|lib/counter.dart'},
        outputs: {
          'a|lib/counter.ease.dart': decodedMatches(
            allOf([
              contains('class CounterViewModelProvider extends StatefulWidget'),
              contains('class _CounterViewModelProviderState'),
              contains('_CounterViewModelInherited'),
              contains('extends InheritedModel<_CounterViewModelAspect>'),
              contains('extension CounterViewModelContext on BuildContext'),
              contains('CounterViewModel get counterViewModel'),
              contains('CounterViewModel readCounterViewModel()'),
              contains('T selectCounterViewModel<T>'),
              contains('_CounterViewModelAspect'),
            ]),
          ),
        },
      );
    });

    test('generates correct getter name from PascalCase', () async {
      final builder = easeBuilder(BuilderOptions.empty);

      await testBuilder(
        builder,
        {
          'ease_annotation|lib/ease_annotation.dart': '''
library ease_annotation;
class ease {
  const ease();
}
''',
          'ease|lib/src/state_notifier.dart': '''
class StateNotifier<T> {
  StateNotifier(this._state);
  T _state;
  T get state => _state;
  set state(T value) {
    _state = value;
  }
}
''',
          'a|lib/my_app_state.dart': '''
import 'package:ease_annotation/ease_annotation.dart';
import 'package:ease/src/state_notifier.dart';

part 'my_app_state.ease.dart';

@ease()
class MyAppState extends StateNotifier<String> {
  MyAppState() : super('');
}
''',
        },
        generateFor: {'a|lib/my_app_state.dart'},
        outputs: {
          'a|lib/my_app_state.ease.dart': decodedMatches(
            allOf([
              contains('MyAppState get myAppState'),
              contains('MyAppState readMyAppState()'),
              contains('class MyAppStateProvider'),
            ]),
          ),
        },
      );
    });

    test('generates InheritedModel with correct type parameter', () async {
      final builder = easeBuilder(BuilderOptions.empty);

      await testBuilder(
        builder,
        {
          'ease_annotation|lib/ease_annotation.dart': '''
library ease_annotation;
class ease {
  const ease();
}
''',
          'ease|lib/src/state_notifier.dart': '''
class StateNotifier<T> {
  StateNotifier(this._state);
  T _state;
  T get state => _state;
  set state(T value) {
    _state = value;
  }
}
''',
          'a|lib/cart.dart': '''
import 'package:ease_annotation/ease_annotation.dart';
import 'package:ease/src/state_notifier.dart';

part 'cart.ease.dart';

@ease()
class CartViewModel extends StateNotifier<List<String>> {
  CartViewModel() : super([]);
}
''',
        },
        generateFor: {'a|lib/cart.dart'},
        outputs: {
          'a|lib/cart.ease.dart': decodedMatches(
            allOf([
              contains('InheritedModel<_CartViewModelAspect>'),
              contains('final CartViewModel notifier'),
              contains('updateShouldNotifyDependent'),
            ]),
          ),
        },
      );
    });

    test('generates StateError messages with class name', () async {
      final builder = easeBuilder(BuilderOptions.empty);

      await testBuilder(
        builder,
        {
          'ease_annotation|lib/ease_annotation.dart': '''
library ease_annotation;
class ease {
  const ease();
}
''',
          'ease|lib/src/state_notifier.dart': '''
class StateNotifier<T> {
  StateNotifier(this._state);
  T _state;
  T get state => _state;
  set state(T value) {
    _state = value;
  }
}
''',
          'a|lib/auth.dart': '''
import 'package:ease_annotation/ease_annotation.dart';
import 'package:ease/src/state_notifier.dart';

part 'auth.ease.dart';

@ease()
class AuthViewModel extends StateNotifier<bool> {
  AuthViewModel() : super(false);
}
''',
        },
        generateFor: {'a|lib/auth.dart'},
        outputs: {
          'a|lib/auth.ease.dart': decodedMatches(
            allOf([
              contains("'No AuthViewModel found in widget tree"),
              contains('Wrapped your app with Ease widget'),
            ]),
          ),
        },
      );
    });

    test('generates dispose method in provider state', () async {
      final builder = easeBuilder(BuilderOptions.empty);

      await testBuilder(
        builder,
        {
          'ease_annotation|lib/ease_annotation.dart': '''
library ease_annotation;
class ease {
  const ease();
}
''',
          'ease|lib/src/state_notifier.dart': '''
class StateNotifier<T> {
  StateNotifier(this._state);
  T _state;
  T get state => _state;
  set state(T value) {
    _state = value;
  }
  void dispose() {}
}
''',
          'a|lib/user.dart': '''
import 'package:ease_annotation/ease_annotation.dart';
import 'package:ease/src/state_notifier.dart';

part 'user.ease.dart';

@ease()
class UserViewModel extends StateNotifier<Map<String, dynamic>> {
  UserViewModel() : super({});
}
''',
        },
        generateFor: {'a|lib/user.dart'},
        outputs: {
          'a|lib/user.ease.dart': decodedMatches(
            allOf([
              contains('@override'),
              contains('void dispose()'),
              contains('_notifier.dispose()'),
              contains('super.dispose()'),
            ]),
          ),
        },
      );
    });

    test('generates dependOnInheritedWidgetOfExactType for watch', () async {
      final builder = easeBuilder(BuilderOptions.empty);

      await testBuilder(
        builder,
        {
          'ease_annotation|lib/ease_annotation.dart': '''
library ease_annotation;
class ease {
  const ease();
}
''',
          'ease|lib/src/state_notifier.dart': '''
class StateNotifier<T> {
  StateNotifier(this._state);
  T _state;
  T get state => _state;
  set state(T value) {
    _state = value;
  }
}
''',
          'a|lib/theme.dart': '''
import 'package:ease_annotation/ease_annotation.dart';
import 'package:ease/src/state_notifier.dart';

part 'theme.ease.dart';

@ease()
class ThemeViewModel extends StateNotifier<bool> {
  ThemeViewModel() : super(false);
}
''',
        },
        generateFor: {'a|lib/theme.dart'},
        outputs: {
          'a|lib/theme.ease.dart': decodedMatches(
            allOf([
              // Full subscription uses InheritedModel.inheritFrom
              contains('InheritedModel.inheritFrom<_ThemeViewModelInherited>'),
              // Read uses getInheritedWidgetOfExactType (no subscription)
              contains(
                  'getInheritedWidgetOfExactType<_ThemeViewModelInherited>'),
              // Select uses aspect for selective rebuilds
              contains('_ThemeViewModelAspect'),
            ]),
          ),
        },
      );
    });
  });

  group('EaseGenerator error handling', () {
    test('logs error when @ease applied to non-StateNotifier class', () async {
      final builder = easeBuilder(BuilderOptions.empty);

      // The builder logs the error instead of throwing, so we capture logs
      final logs = <String>[];
      await testBuilder(
        builder,
        {
          'ease_annotation|lib/ease_annotation.dart': '''
library ease_annotation;
class ease {
  const ease();
}
''',
          'a|lib/invalid.dart': '''
import 'package:ease_annotation/ease_annotation.dart';

part 'invalid.ease.dart';

@ease()
class InvalidClass {
  final int value;
  InvalidClass(this.value);
}
''',
        },
        generateFor: {'a|lib/invalid.dart'},
        onLog: (log) => logs.add(log.message),
      );

      // Verify the error message was logged
      expect(
        logs.any((log) => log.contains('classes that extend StateNotifier')),
        isTrue,
        reason: 'Expected error about StateNotifier requirement',
      );
    });
  });
}
