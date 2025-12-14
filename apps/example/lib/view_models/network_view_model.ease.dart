// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'network_view_model.dart';

// **************************************************************************
// EaseGenerator
// **************************************************************************

// ============================================
// Generated for NetworkViewModel
// ============================================

/// Provider widget that creates and manages NetworkViewModel.
///
/// Uses InheritedNotifier for optimal performance - only widgets
/// that call context.networkViewModel will rebuild on state changes.
class NetworkViewModelProvider extends StatefulWidget {
  final Widget child;

  const NetworkViewModelProvider({super.key, required this.child});

  @override
  State<NetworkViewModelProvider> createState() =>
      _NetworkViewModelProviderState();
}

class _NetworkViewModelProviderState extends State<NetworkViewModelProvider> {
  late final NetworkViewModel _notifier = NetworkViewModel();

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _NetworkViewModelInherited(
      notifier: _notifier,
      child: widget.child,
    );
  }
}

/// InheritedNotifier that efficiently notifies dependents when state changes.
///
/// This automatically listens to the notifier and only rebuilds widgets
/// that have registered a dependency via dependOnInheritedWidgetOfExactType.
class _NetworkViewModelInherited extends InheritedNotifier<NetworkViewModel> {
  const _NetworkViewModelInherited({
    required NetworkViewModel notifier,
    required super.child,
  }) : super(notifier: notifier);
}

extension NetworkViewModelContext on BuildContext {
  /// Gets NetworkViewModel and subscribes to changes.
  /// Widget will rebuild when state changes.
  NetworkViewModel get networkViewModel {
    final inherited =
        dependOnInheritedWidgetOfExactType<_NetworkViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No NetworkViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }

  /// Gets NetworkViewModel without subscribing to changes.
  /// Widget will NOT rebuild when state changes.
  /// Use for callbacks and one-time reads.
  NetworkViewModel readNetworkViewModel() {
    final inherited =
        getInheritedWidgetOfExactType<_NetworkViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No NetworkViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }
}

/// Selector widget for NetworkViewModel that only rebuilds when selected value changes.
///
/// Example:
/// ```dart
/// NetworkViewModelSelector<int>(
///   selector: (state) => state.itemCount,
///   builder: (context, count) => Text('$count'),
/// )
/// ```
class NetworkViewModelSelector<T> extends StatefulWidget {
  /// Function that selects the portion of state to watch.
  final T Function(NetworkStatus state) selector;

  /// Builder function called with the selected value.
  final Widget Function(BuildContext context, T value) builder;

  /// Optional equality function to compare selected values.
  /// If not provided, uses `==` operator.
  final bool Function(T previous, T next)? equals;

  const NetworkViewModelSelector({
    super.key,
    required this.selector,
    required this.builder,
    this.equals,
  });

  @override
  State<NetworkViewModelSelector<T>> createState() =>
      _NetworkViewModelSelectorState<T>();
}

class _NetworkViewModelSelectorState<T>
    extends State<NetworkViewModelSelector<T>> {
  NetworkViewModel? _notifier;
  late T _selectedValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final notifier = context.readNetworkViewModel();
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
  void didUpdateWidget(covariant NetworkViewModelSelector<T> oldWidget) {
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
