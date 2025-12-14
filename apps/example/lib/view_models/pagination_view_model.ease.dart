// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'pagination_view_model.dart';

// **************************************************************************
// EaseGenerator
// **************************************************************************

// ============================================
// Generated for PaginationViewModel
// ============================================

/// Provider widget that creates and manages PaginationViewModel.
///
/// Uses InheritedNotifier for optimal performance - only widgets
/// that call context.paginationViewModel will rebuild on state changes.
class PaginationViewModelProvider extends StatefulWidget {
  final Widget child;

  const PaginationViewModelProvider({super.key, required this.child});

  @override
  State<PaginationViewModelProvider> createState() =>
      _PaginationViewModelProviderState();
}

class _PaginationViewModelProviderState
    extends State<PaginationViewModelProvider> {
  late final PaginationViewModel _notifier = PaginationViewModel();

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PaginationViewModelInherited(
      notifier: _notifier,
      child: widget.child,
    );
  }
}

/// InheritedNotifier that efficiently notifies dependents when state changes.
///
/// This automatically listens to the notifier and only rebuilds widgets
/// that have registered a dependency via dependOnInheritedWidgetOfExactType.
class _PaginationViewModelInherited
    extends InheritedNotifier<PaginationViewModel> {
  const _PaginationViewModelInherited({
    required PaginationViewModel notifier,
    required super.child,
  }) : super(notifier: notifier);
}

extension PaginationViewModelContext on BuildContext {
  /// Gets PaginationViewModel and subscribes to changes.
  /// Widget will rebuild when state changes.
  PaginationViewModel get paginationViewModel {
    final inherited =
        dependOnInheritedWidgetOfExactType<_PaginationViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No PaginationViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }

  /// Gets PaginationViewModel without subscribing to changes.
  /// Widget will NOT rebuild when state changes.
  /// Use for callbacks and one-time reads.
  PaginationViewModel readPaginationViewModel() {
    final inherited =
        getInheritedWidgetOfExactType<_PaginationViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No PaginationViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }
}

/// Selector widget for PaginationViewModel that only rebuilds when selected value changes.
///
/// Example:
/// ```dart
/// PaginationViewModelSelector<int>(
///   selector: (state) => state.itemCount,
///   builder: (context, count) => Text('$count'),
/// )
/// ```
class PaginationViewModelSelector<T> extends StatefulWidget {
  /// Function that selects the portion of state to watch.
  final T Function(PaginationStatus state) selector;

  /// Builder function called with the selected value.
  final Widget Function(BuildContext context, T value) builder;

  /// Optional equality function to compare selected values.
  /// If not provided, uses `==` operator.
  final bool Function(T previous, T next)? equals;

  const PaginationViewModelSelector({
    super.key,
    required this.selector,
    required this.builder,
    this.equals,
  });

  @override
  State<PaginationViewModelSelector<T>> createState() =>
      _PaginationViewModelSelectorState<T>();
}

class _PaginationViewModelSelectorState<T>
    extends State<PaginationViewModelSelector<T>> {
  PaginationViewModel? _notifier;
  late T _selectedValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final notifier = context.readPaginationViewModel();
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
  void didUpdateWidget(covariant PaginationViewModelSelector<T> oldWidget) {
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
