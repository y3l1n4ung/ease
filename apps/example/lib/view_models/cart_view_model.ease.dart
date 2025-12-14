// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'cart_view_model.dart';

// **************************************************************************
// EaseGenerator
// **************************************************************************

// ============================================
// Generated for CartViewModel
// ============================================

/// Provider widget that creates and manages CartViewModel.
///
/// Uses InheritedNotifier for optimal performance - only widgets
/// that call context.cartViewModel will rebuild on state changes.
class CartViewModelProvider extends StatefulWidget {
  final Widget child;

  const CartViewModelProvider({super.key, required this.child});

  @override
  State<CartViewModelProvider> createState() => _CartViewModelProviderState();
}

class _CartViewModelProviderState extends State<CartViewModelProvider> {
  late final CartViewModel _notifier = CartViewModel();

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _CartViewModelInherited(
      notifier: _notifier,
      child: widget.child,
    );
  }
}

/// InheritedNotifier that efficiently notifies dependents when state changes.
///
/// This automatically listens to the notifier and only rebuilds widgets
/// that have registered a dependency via dependOnInheritedWidgetOfExactType.
class _CartViewModelInherited extends InheritedNotifier<CartViewModel> {
  const _CartViewModelInherited({
    required CartViewModel notifier,
    required super.child,
  }) : super(notifier: notifier);
}

extension CartViewModelContext on BuildContext {
  /// Gets CartViewModel and subscribes to changes.
  /// Widget will rebuild when state changes.
  CartViewModel get cartViewModel {
    final inherited =
        dependOnInheritedWidgetOfExactType<_CartViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No CartViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }

  /// Gets CartViewModel without subscribing to changes.
  /// Widget will NOT rebuild when state changes.
  /// Use for callbacks and one-time reads.
  CartViewModel readCartViewModel() {
    final inherited = getInheritedWidgetOfExactType<_CartViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No CartViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }
}

/// Selector widget for CartViewModel that only rebuilds when selected value changes.
///
/// Example:
/// ```dart
/// CartViewModelSelector<int>(
///   selector: (state) => state.itemCount,
///   builder: (context, count) => Text('$count'),
/// )
/// ```
class CartViewModelSelector<T> extends StatefulWidget {
  /// Function that selects the portion of state to watch.
  final T Function(CartStatus state) selector;

  /// Builder function called with the selected value.
  final Widget Function(BuildContext context, T value) builder;

  /// Optional equality function to compare selected values.
  /// If not provided, uses `==` operator.
  final bool Function(T previous, T next)? equals;

  const CartViewModelSelector({
    super.key,
    required this.selector,
    required this.builder,
    this.equals,
  });

  @override
  State<CartViewModelSelector<T>> createState() =>
      _CartViewModelSelectorState<T>();
}

class _CartViewModelSelectorState<T> extends State<CartViewModelSelector<T>> {
  CartViewModel? _notifier;
  late T _selectedValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final notifier = context.readCartViewModel();
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
  void didUpdateWidget(covariant CartViewModelSelector<T> oldWidget) {
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
