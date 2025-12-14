// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'theme_view_model.dart';

// **************************************************************************
// EaseGenerator
// **************************************************************************

// ============================================
// Generated for ThemeViewModel
// ============================================

/// Provider widget that creates and manages ThemeViewModel.
///
/// Uses InheritedNotifier for optimal performance - only widgets
/// that call context.themeViewModel will rebuild on state changes.
class ThemeViewModelProvider extends StatefulWidget {
  final Widget child;

  const ThemeViewModelProvider({super.key, required this.child});

  @override
  State<ThemeViewModelProvider> createState() => _ThemeViewModelProviderState();
}

class _ThemeViewModelProviderState extends State<ThemeViewModelProvider> {
  late final ThemeViewModel _notifier = ThemeViewModel();

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ThemeViewModelInherited(
      notifier: _notifier,
      child: widget.child,
    );
  }
}

/// InheritedNotifier that efficiently notifies dependents when state changes.
///
/// This automatically listens to the notifier and only rebuilds widgets
/// that have registered a dependency via dependOnInheritedWidgetOfExactType.
class _ThemeViewModelInherited extends InheritedNotifier<ThemeViewModel> {
  const _ThemeViewModelInherited({
    required ThemeViewModel notifier,
    required super.child,
  }) : super(notifier: notifier);
}

extension ThemeViewModelContext on BuildContext {
  /// Gets ThemeViewModel and subscribes to changes.
  /// Widget will rebuild when state changes.
  ThemeViewModel get themeViewModel {
    final inherited =
        dependOnInheritedWidgetOfExactType<_ThemeViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No ThemeViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }

  /// Gets ThemeViewModel without subscribing to changes.
  /// Widget will NOT rebuild when state changes.
  /// Use for callbacks and one-time reads.
  ThemeViewModel readThemeViewModel() {
    final inherited = getInheritedWidgetOfExactType<_ThemeViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No ThemeViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }
}

/// Selector widget for ThemeViewModel that only rebuilds when selected value changes.
///
/// Example:
/// ```dart
/// ThemeViewModelSelector<int>(
///   selector: (state) => state.itemCount,
///   builder: (context, count) => Text('$count'),
/// )
/// ```
class ThemeViewModelSelector<T> extends StatefulWidget {
  /// Function that selects the portion of state to watch.
  final T Function(AppTheme state) selector;

  /// Builder function called with the selected value.
  final Widget Function(BuildContext context, T value) builder;

  /// Optional equality function to compare selected values.
  /// If not provided, uses `==` operator.
  final bool Function(T previous, T next)? equals;

  const ThemeViewModelSelector({
    super.key,
    required this.selector,
    required this.builder,
    this.equals,
  });

  @override
  State<ThemeViewModelSelector<T>> createState() =>
      _ThemeViewModelSelectorState<T>();
}

class _ThemeViewModelSelectorState<T> extends State<ThemeViewModelSelector<T>> {
  ThemeViewModel? _notifier;
  late T _selectedValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final notifier = context.readThemeViewModel();
    if (_notifier != notifier) {
      _notifier?.removeListener(_onStateChange);
      _notifier = notifier;
      _selectedValue = widget.selector(notifier.state);
      notifier.addListener(_onStateChange);
    }
  }

  @override
  void dispose() {
    _notifier?.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    final newValue = widget.selector(_notifier!.state);
    final areEqual = widget.equals?.call(_selectedValue, newValue) ??
        _selectedValue == newValue;
    if (!areEqual) {
      setState(() => _selectedValue = newValue);
    }
  }

  @override
  void didUpdateWidget(covariant ThemeViewModelSelector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recompute selected value if selector changed
    if (_notifier != null) {
      _selectedValue = widget.selector(_notifier!.state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _selectedValue);
  }
}
