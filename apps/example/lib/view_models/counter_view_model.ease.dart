// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'counter_view_model.dart';

// **************************************************************************
// EaseGenerator
// **************************************************************************

// ============================================
// Generated for CounterViewModel
// ============================================

/// Provider widget that creates and manages CounterViewModel.
///
/// Uses InheritedNotifier for optimal performance - only widgets
/// that call context.counterViewModel will rebuild on state changes.
class CounterViewModelProvider extends StatefulWidget {
  final Widget child;

  const CounterViewModelProvider({super.key, required this.child});

  @override
  State<CounterViewModelProvider> createState() =>
      _CounterViewModelProviderState();
}

class _CounterViewModelProviderState extends State<CounterViewModelProvider> {
  late final CounterViewModel _notifier = CounterViewModel();

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _CounterViewModelInherited(
      notifier: _notifier,
      child: widget.child,
    );
  }
}

/// InheritedNotifier that efficiently notifies dependents when state changes.
///
/// This automatically listens to the notifier and only rebuilds widgets
/// that have registered a dependency via dependOnInheritedWidgetOfExactType.
class _CounterViewModelInherited extends InheritedNotifier<CounterViewModel> {
  const _CounterViewModelInherited({
    required CounterViewModel notifier,
    required super.child,
  }) : super(notifier: notifier);
}

extension CounterViewModelContext on BuildContext {
  /// Gets CounterViewModel and subscribes to changes.
  /// Widget will rebuild when state changes.
  CounterViewModel get counterViewModel {
    final inherited =
        dependOnInheritedWidgetOfExactType<_CounterViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No CounterViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }

  /// Gets CounterViewModel without subscribing to changes.
  /// Widget will NOT rebuild when state changes.
  /// Use for callbacks and one-time reads.
  CounterViewModel readCounterViewModel() {
    final inherited =
        getInheritedWidgetOfExactType<_CounterViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No CounterViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }
}

/// Selector widget for CounterViewModel that only rebuilds when selected value changes.
///
/// Example:
/// ```dart
/// CounterViewModelSelector<int>(
///   selector: (state) => state.itemCount,
///   builder: (context, count) => Text('$count'),
/// )
/// ```
class CounterViewModelSelector<T> extends StatefulWidget {
  /// Function that selects the portion of state to watch.
  final T Function(int state) selector;

  /// Builder function called with the selected value.
  final Widget Function(BuildContext context, T value) builder;

  /// Optional equality function to compare selected values.
  /// If not provided, uses `==` operator.
  final bool Function(T previous, T next)? equals;

  const CounterViewModelSelector({
    super.key,
    required this.selector,
    required this.builder,
    this.equals,
  });

  @override
  State<CounterViewModelSelector<T>> createState() =>
      _CounterViewModelSelectorState<T>();
}

class _CounterViewModelSelectorState<T>
    extends State<CounterViewModelSelector<T>> {
  CounterViewModel? _notifier;
  late T _selectedValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final notifier = context.readCounterViewModel();
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
  void didUpdateWidget(covariant CounterViewModelSelector<T> oldWidget) {
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
