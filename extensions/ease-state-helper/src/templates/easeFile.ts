import { toCamelCase } from '../utils/naming';

/**
 * Template for the .ease.dart file - matches codegen output
 */
export function getEaseFileTemplate(
  className: string,
  fileName: string,
  stateType: string
): string {
  const getterName = toCamelCase(className);

  return `part of '${fileName}.dart';

class _${className}Aspect<T> {
  final T Function(${stateType} state) selector;
  final T value;
  final bool Function(T a, T b)? equals;

  const _${className}Aspect(this.selector, this.value, [this.equals]);

  bool hasChanged(T newValue) {
    if (equals != null) return !equals!(value, newValue);
    return value != newValue;
  }
}

class ${className}Provider extends StatefulWidget {
  final Widget child;
  const ${className}Provider({super.key, required this.child});

  @override
  State<${className}Provider> createState() => _${className}ProviderState();
}

class _${className}ProviderState extends State<${className}Provider> {
  late final ${className} _notifier = ${className}();

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
    return _${className}Inherited(notifier: _notifier, child: widget.child);
  }
}

class _${className}Inherited extends InheritedModel<_${className}Aspect> {
  final ${className} notifier;

  const _${className}Inherited({required this.notifier, required super.child});

  @override
  bool updateShouldNotify(_${className}Inherited oldWidget) => true;

  @override
  bool updateShouldNotifyDependent(
    _${className}Inherited oldWidget,
    Set<_${className}Aspect> dependencies,
  ) {
    if (dependencies.isEmpty) return true;
    for (final aspect in dependencies) {
      if (aspect.hasChanged(aspect.selector(notifier.state))) return true;
    }
    return false;
  }
}

extension ${className}Context on BuildContext {
  ${className} get ${getterName} {
    final inherited = InheritedModel.inheritFrom<_${className}Inherited>(this);
    if (inherited == null) {
      throw StateError(
        'No ${className} found in widget tree.\\n'
        'Make sure you:\\n'
        '1. Wrapped your app with EaseScope widget: EaseScope(providers: [...], child: MyApp())\\n'
        '2. Added ${className}Provider to your providers list',
      );
    }
    return inherited.notifier;
  }

  ${className} read${className}() {
    final inherited = getInheritedWidgetOfExactType<_${className}Inherited>();
    if (inherited == null) {
      throw StateError(
        'No ${className} found in widget tree.\\n'
        'Make sure you:\\n'
        '1. Wrapped your app with EaseScope widget: EaseScope(providers: [...], child: MyApp())\\n'
        '2. Added ${className}Provider to your providers list',
      );
    }
    return inherited.notifier;
  }

  T select${className}<T>(
    T Function(${stateType} state) selector, {
    bool Function(T a, T b)? equals,
  }) {
    final inherited = getInheritedWidgetOfExactType<_${className}Inherited>();
    if (inherited == null) {
      throw StateError(
        'No ${className} found in widget tree.\\n'
        'Make sure you:\\n'
        '1. Wrapped your app with EaseScope widget: EaseScope(providers: [...], child: MyApp())\\n'
        '2. Added ${className}Provider to your providers list',
      );
    }
    final currentValue = selector(inherited.notifier.state);
    InheritedModel.inheritFrom<_${className}Inherited>(
      this,
      aspect: _${className}Aspect<T>(selector, currentValue, equals),
    );
    return currentValue;
  }

  EaseSubscription listenOn${className}(
    void Function(${stateType} previous, ${stateType} current) listener, {
    bool fireImmediately = false,
  }) {
    return read${className}().listenInContext(
      this,
      listener,
      fireImmediately: fireImmediately,
    );
  }
}
`;
}
