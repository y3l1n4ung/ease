import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:ease_annotation/ease_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'utils.dart';

/// Generates InheritedNotifier and Provider for classes annotated with @ease.
///
/// Uses InheritedNotifier for optimal performance - only widgets that actually
/// depend on the state will rebuild when it changes.
class EaseGenerator extends GeneratorForAnnotation<ease> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@ease can only be applied to classes.',
        element: element,
        todo: 'Remove @ease annotation or apply it to a class.',
      );
    }

    // Validate that the class extends StateNotifier
    if (!_extendsStateNotifier(element)) {
      throw InvalidGenerationSourceError(
        '@ease can only be applied to classes that extend StateNotifier<T>.',
        element: element,
        todo: 'Make ${element.name} extend StateNotifier<YourStateType>.',
      );
    }

    return _generateForClass(element);
  }

  /// Checks if the class extends StateNotifier by walking up the inheritance chain.
  bool _extendsStateNotifier(ClassElement element) {
    var current = element.supertype;
    while (current != null) {
      final name = current.element.name;
      if (name == 'StateNotifier') {
        return true;
      }
      current = current.element.supertype;
    }
    return false;
  }

  /// Extracts the state type T from StateNotifier<T>.
  String? _getStateType(ClassElement element) {
    var current = element.supertype;
    while (current != null) {
      if (current.element.name == 'StateNotifier') {
        final typeArgs = current.typeArguments;
        if (typeArgs.isNotEmpty) {
          return typeArgs.first.getDisplayString();
        }
        return null;
      }
      current = current.element.supertype;
    }
    return null;
  }

  String _generateForClass(ClassElement element) {
    final className = element.name;
    if (className == null) {
      throw InvalidGenerationSourceError(
        'Class must have a name.',
        element: element,
      );
    }
    // Use public names so they can be accessed from ease.g.dart
    final providerName = '${className}Provider';
    final providerStateName = '_${className}ProviderState';
    final inheritedName = '_${className}Inherited';
    final aspectName = '_${className}Aspect';
    final getterName = toCamelCase(className);
    final stateType = _getStateType(element) ?? 'dynamic';

    return '''
// ============================================
// Generated for $className
// ============================================

/// Aspect for tracking selector dependencies in InheritedModel.
/// Stores the selector function, its last computed value, and optional equality function.
class $aspectName<T> {
  final T Function($stateType state) selector;
  final T value;
  final bool Function(T a, T b)? equals;

  const $aspectName(this.selector, this.value, [this.equals]);

  /// Compare values using custom equals or default ==
  bool hasChanged(T newValue) {
    if (equals != null) {
      return !equals!(value, newValue);
    }
    return value != newValue;
  }
}

/// Provider widget that creates and manages $className.
///
/// Uses InheritedModel for optimal performance:
/// - context.$getterName subscribes to all changes
/// - context.select$className subscribes only to selected value changes
class $providerName extends StatefulWidget {
  final Widget child;

  const $providerName({super.key, required this.child});

  @override
  State<$providerName> createState() => $providerStateName();
}

class $providerStateName extends State<$providerName> {
  late final $className _notifier = $className();

  @override
  void initState() {
    super.initState();
    _notifier.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _notifier.removeListener(_onStateChange);
    _notifier.dispose();
    super.dispose();
  }

  void _onStateChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return $inheritedName(
      notifier: _notifier,
      child: widget.child,
    );
  }
}

/// InheritedModel that supports both full and selective subscriptions.
///
/// - Full subscription (no aspect): rebuilds on any state change
/// - Selective subscription (with aspect): rebuilds only when selected value changes
class $inheritedName extends InheritedModel<$aspectName> {
  final $className notifier;

  const $inheritedName({
    required this.notifier,
    required super.child,
  });

  @override
  bool updateShouldNotify($inheritedName oldWidget) {
    // Always return true - let updateShouldNotifyDependent handle granular checks
    return true;
  }

  @override
  bool updateShouldNotifyDependent(
    $inheritedName oldWidget,
    Set<$aspectName> dependencies,
  ) {
    // If no aspects registered (full subscription via context.$getterName),
    // always rebuild on state change
    if (dependencies.isEmpty) {
      return true;
    }

    // Check each selector aspect to see if its selected value changed
    for (final aspect in dependencies) {
      final newValue = aspect.selector(notifier.state);
      if (aspect.hasChanged(newValue)) {
        return true;
      }
    }
    return false;
  }
}

extension ${className}Context on BuildContext {
  /// Gets $className and subscribes to all changes.
  /// Widget will rebuild when any part of state changes.
  ///
  /// For selective rebuilds, use [select$className] instead.
  $className get $getterName {
    final inherited = InheritedModel.inheritFrom<$inheritedName>(this);
    if (inherited == null) {
      throw StateError(
        'No $className found in widget tree.\\n'
        'Make sure you:\\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\\n'
        '2. Ran build_runner: dart run build_runner build\\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier;
  }

  /// Gets $className without subscribing to changes.
  /// Widget will NOT rebuild when state changes.
  /// Use for callbacks and one-time reads.
  $className read$className() {
    final inherited = getInheritedWidgetOfExactType<$inheritedName>();
    if (inherited == null) {
      throw StateError(
        'No $className found in widget tree.\\n'
        'Make sure you:\\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\\n'
        '2. Ran build_runner: dart run build_runner build\\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier;
  }

  /// Selects a portion of $className state and subscribes to changes.
  /// Widget will rebuild only when the selected value changes.
  ///
  /// Example:
  /// ```dart
  /// final isLoading = context.select$className((s) => s.isLoading);
  /// ```
  ///
  /// For collections, provide a custom [equals] function:
  /// ```dart
  /// final items = context.select$className(
  ///   (s) => s.items,
  ///   equals: (a, b) => listEquals(a, b),
  /// );
  /// ```
  ///
  /// This is more efficient than [context.$getterName] when you only need
  /// a small part of the state.
  T select$className<T>(
    T Function($stateType state) selector, {
    bool Function(T a, T b)? equals,
  }) {
    final inherited = getInheritedWidgetOfExactType<$inheritedName>();
    if (inherited == null) {
      throw StateError(
        'No $className found in widget tree.\\n'
        'Make sure you:\\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\\n'
        '2. Ran build_runner: dart run build_runner build\\n'
        '3. Imported ease.g.dart in your main file',
      );
    }

    final currentValue = selector(inherited.notifier.state);

    // Register dependency with aspect for selective rebuilds
    InheritedModel.inheritFrom<$inheritedName>(
      this,
      aspect: $aspectName<T>(selector, currentValue, equals),
    );

    return currentValue;
  }
}
''';
  }
}
