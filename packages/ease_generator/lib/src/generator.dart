import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:ease_annotation/ease_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'utils.dart';

/// Generates InheritedModel and Provider for classes annotated with @ease.
class EaseGenerator extends GeneratorForAnnotation<Ease> {
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
class $aspectName<T> {
  final T Function($stateType state) selector;
  final T value;
  final bool Function(T a, T b)? equals;

  const $aspectName(this.selector, this.value, [this.equals]);

  bool hasChanged(T newValue) {
    if (equals != null) return !equals!(value, newValue);
    return value != newValue;
  }
}

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

  void _onStateChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return $inheritedName(notifier: _notifier, child: widget.child);
  }
}

class $inheritedName extends InheritedModel<$aspectName> {
  final $className notifier;

  const $inheritedName({required this.notifier, required super.child});

  @override
  bool updateShouldNotify($inheritedName oldWidget) => true;

  @override
  bool updateShouldNotifyDependent(
    $inheritedName oldWidget,
    Set<$aspectName> dependencies,
  ) {
    if (dependencies.isEmpty) return true;
    for (final aspect in dependencies) {
      if (aspect.hasChanged(aspect.selector(notifier.state))) return true;
    }
    return false;
  }
}

extension ${className}Context on BuildContext {
  $className get $getterName {
    final inherited = InheritedModel.inheritFrom<$inheritedName>(this);
    if (inherited == null) {
      throw StateError(
        'No $className found in widget tree.\\n'
        'Make sure you:\\n'
        '1. Wrapped your app with EaseScope widget: EaseScope(providers: [...], child: MyApp())\\n'
        '2. Added ${className}Provider to your providers list',
      );
    }
    return inherited.notifier;
  }

  $className read$className() {
    final inherited = getInheritedWidgetOfExactType<$inheritedName>();
    if (inherited == null) {
      throw StateError(
        'No $className found in widget tree.\\n'
        'Make sure you:\\n'
        '1. Wrapped your app with EaseScope widget: EaseScope(providers: [...], child: MyApp())\\n'
        '2. Added ${className}Provider to your providers list',
      );
    }
    return inherited.notifier;
  }

  T select$className<T>(
    T Function($stateType state) selector, {
    bool Function(T a, T b)? equals,
  }) {
    final inherited = getInheritedWidgetOfExactType<$inheritedName>();
    if (inherited == null) {
      throw StateError(
        'No $className found in widget tree.\\n'
        'Make sure you:\\n'
        '1. Wrapped your app with EaseScope widget: EaseScope(providers: [...], child: MyApp())\\n'
        '2. Added ${className}Provider to your providers list',
      );
    }
    final currentValue = selector(inherited.notifier.state);
    InheritedModel.inheritFrom<$inheritedName>(
      this,
      aspect: $aspectName<T>(selector, currentValue, equals),
    );
    return currentValue;
  }

  EaseSubscription listenOn$className(
    void Function($stateType previous, $stateType current) listener, {
    bool fireImmediately = false,
  }) {
    return read$className().listenInContext(this, listener, fireImmediately: fireImmediately);
  }
}
''';
  }
}
