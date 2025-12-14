// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'search_view_model.dart';

// **************************************************************************
// EaseGenerator
// **************************************************************************

// ============================================
// Generated for SearchViewModel
// ============================================

/// Provider widget that creates and manages SearchViewModel.
///
/// Uses InheritedNotifier for optimal performance - only widgets
/// that call context.searchViewModel will rebuild on state changes.
class SearchViewModelProvider extends StatefulWidget {
  final Widget child;

  const SearchViewModelProvider({super.key, required this.child});

  @override
  State<SearchViewModelProvider> createState() =>
      _SearchViewModelProviderState();
}

class _SearchViewModelProviderState extends State<SearchViewModelProvider> {
  late final SearchViewModel _notifier = SearchViewModel();

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SearchViewModelInherited(
      notifier: _notifier,
      child: widget.child,
    );
  }
}

/// InheritedNotifier that efficiently notifies dependents when state changes.
///
/// This automatically listens to the notifier and only rebuilds widgets
/// that have registered a dependency via dependOnInheritedWidgetOfExactType.
class _SearchViewModelInherited extends InheritedNotifier<SearchViewModel> {
  const _SearchViewModelInherited({
    required SearchViewModel notifier,
    required super.child,
  }) : super(notifier: notifier);
}

extension SearchViewModelContext on BuildContext {
  /// Gets SearchViewModel and subscribes to changes.
  /// Widget will rebuild when state changes.
  SearchViewModel get searchViewModel {
    final inherited =
        dependOnInheritedWidgetOfExactType<_SearchViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No SearchViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }

  /// Gets SearchViewModel without subscribing to changes.
  /// Widget will NOT rebuild when state changes.
  /// Use for callbacks and one-time reads.
  SearchViewModel readSearchViewModel() {
    final inherited =
        getInheritedWidgetOfExactType<_SearchViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No SearchViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }
}

/// Selector widget for SearchViewModel that only rebuilds when selected value changes.
///
/// Example:
/// ```dart
/// SearchViewModelSelector<int>(
///   selector: (state) => state.itemCount,
///   builder: (context, count) => Text('$count'),
/// )
/// ```
class SearchViewModelSelector<T> extends StatefulWidget {
  /// Function that selects the portion of state to watch.
  final T Function(SearchStatus state) selector;

  /// Builder function called with the selected value.
  final Widget Function(BuildContext context, T value) builder;

  /// Optional equality function to compare selected values.
  /// If not provided, uses `==` operator.
  final bool Function(T previous, T next)? equals;

  const SearchViewModelSelector({
    super.key,
    required this.selector,
    required this.builder,
    this.equals,
  });

  @override
  State<SearchViewModelSelector<T>> createState() =>
      _SearchViewModelSelectorState<T>();
}

class _SearchViewModelSelectorState<T>
    extends State<SearchViewModelSelector<T>> {
  SearchViewModel? _notifier;
  late T _selectedValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final notifier = context.readSearchViewModel();
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
  void didUpdateWidget(covariant SearchViewModelSelector<T> oldWidget) {
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
