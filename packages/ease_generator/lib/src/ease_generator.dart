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
    final getterName = toCamelCase(className);

    return '''
// ============================================
// Generated for $className
// ============================================

/// Provider widget that creates and manages $className.
///
/// Uses InheritedNotifier for optimal performance - only widgets
/// that call context.$getterName will rebuild on state changes.
class $providerName extends StatefulWidget {
  final Widget child;

  const $providerName({super.key, required this.child});

  @override
  State<$providerName> createState() => $providerStateName();
}

class $providerStateName extends State<$providerName> {
  late final $className _notifier = $className();

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return $inheritedName(
      notifier: _notifier,
      child: widget.child,
    );
  }
}

/// InheritedNotifier that efficiently notifies dependents when state changes.
///
/// This automatically listens to the notifier and only rebuilds widgets
/// that have registered a dependency via dependOnInheritedWidgetOfExactType.
class $inheritedName extends InheritedNotifier<$className> {
  const $inheritedName({
    required $className notifier,
    required super.child,
  }) : super(notifier: notifier);
}

extension ${className}Context on BuildContext {
  /// Gets $className and subscribes to changes.
  /// Widget will rebuild when state changes.
  $className get $getterName {
    final inherited = dependOnInheritedWidgetOfExactType<$inheritedName>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No $className found in widget tree.\\n'
        'Make sure you:\\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\\n'
        '2. Ran build_runner: dart run build_runner build\\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }

  /// Gets $className without subscribing to changes.
  /// Widget will NOT rebuild when state changes.
  /// Use for callbacks and one-time reads.
  $className read$className() {
    final inherited = getInheritedWidgetOfExactType<$inheritedName>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No $className found in widget tree.\\n'
        'Make sure you:\\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\\n'
        '2. Ran build_runner: dart run build_runner build\\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }
}
''';
  }
}
