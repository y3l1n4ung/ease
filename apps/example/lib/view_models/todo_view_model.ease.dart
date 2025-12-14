// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'todo_view_model.dart';

// **************************************************************************
// EaseGenerator
// **************************************************************************

// ============================================
// Generated for TodoViewModel
// ============================================

/// Provider widget that creates and manages TodoViewModel.
///
/// Uses InheritedNotifier for optimal performance - only widgets
/// that call context.todoViewModel will rebuild on state changes.
class TodoViewModelProvider extends StatefulWidget {
  final Widget child;

  const TodoViewModelProvider({super.key, required this.child});

  @override
  State<TodoViewModelProvider> createState() => _TodoViewModelProviderState();
}

class _TodoViewModelProviderState extends State<TodoViewModelProvider> {
  late final TodoViewModel _notifier = TodoViewModel();

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _TodoViewModelInherited(
      notifier: _notifier,
      child: widget.child,
    );
  }
}

/// InheritedNotifier that efficiently notifies dependents when state changes.
///
/// This automatically listens to the notifier and only rebuilds widgets
/// that have registered a dependency via dependOnInheritedWidgetOfExactType.
class _TodoViewModelInherited extends InheritedNotifier<TodoViewModel> {
  const _TodoViewModelInherited({
    required TodoViewModel notifier,
    required super.child,
  }) : super(notifier: notifier);
}

extension TodoViewModelContext on BuildContext {
  /// Gets TodoViewModel and subscribes to changes.
  /// Widget will rebuild when state changes.
  TodoViewModel get todoViewModel {
    final inherited =
        dependOnInheritedWidgetOfExactType<_TodoViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No TodoViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }

  /// Gets TodoViewModel without subscribing to changes.
  /// Widget will NOT rebuild when state changes.
  /// Use for callbacks and one-time reads.
  TodoViewModel readTodoViewModel() {
    final inherited = getInheritedWidgetOfExactType<_TodoViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No TodoViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }
}

/// Selector widget for TodoViewModel that only rebuilds when selected value changes.
///
/// Example:
/// ```dart
/// TodoViewModelSelector<int>(
///   selector: (state) => state.itemCount,
///   builder: (context, count) => Text('$count'),
/// )
/// ```
class TodoViewModelSelector<T> extends StatefulWidget {
  /// Function that selects the portion of state to watch.
  final T Function(List<Todo> state) selector;

  /// Builder function called with the selected value.
  final Widget Function(BuildContext context, T value) builder;

  /// Optional equality function to compare selected values.
  /// If not provided, uses `==` operator.
  final bool Function(T previous, T next)? equals;

  const TodoViewModelSelector({
    super.key,
    required this.selector,
    required this.builder,
    this.equals,
  });

  @override
  State<TodoViewModelSelector<T>> createState() =>
      _TodoViewModelSelectorState<T>();
}

class _TodoViewModelSelectorState<T> extends State<TodoViewModelSelector<T>> {
  TodoViewModel? _notifier;
  late T _selectedValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final notifier = context.readTodoViewModel();
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
  void didUpdateWidget(covariant TodoViewModelSelector<T> oldWidget) {
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
