import 'package:flutter/widgets.dart';

import 'state_notifier.dart';

/// A widget that selects a portion of state and only rebuilds when that portion changes.
///
/// This is useful for optimizing performance when you have a complex state object
/// but only need to react to changes in a specific part of it.
///
/// Example:
/// ```dart
/// CartViewModelSelector<int>(
///   selector: (state) => state.itemCount,
///   builder: (context, count) => Text('$count items'),
/// )
/// ```
///
/// For simple primitive types, the default equality check (`==`) works well.
/// For complex objects like lists, you may want to provide a custom [equals] function:
/// ```dart
/// CartViewModelSelector<List<Item>>(
///   selector: (state) => state.items,
///   equals: (prev, next) => listEquals(prev, next),
///   builder: (context, items) => ItemList(items),
/// )
/// ```
class Selector<N extends StateNotifier<S>, S, T> extends StatefulWidget {
  /// The notifier to listen to.
  final N notifier;

  /// Function that selects the portion of state to watch.
  final T Function(S state) selector;

  /// Builder function called with the selected value.
  final Widget Function(BuildContext context, T value) builder;

  /// Optional equality function to compare selected values.
  /// If not provided, uses `==` operator.
  final bool Function(T previous, T next)? equals;

  const Selector({
    super.key,
    required this.notifier,
    required this.selector,
    required this.builder,
    this.equals,
  });

  @override
  State<Selector<N, S, T>> createState() => _SelectorState<N, S, T>();
}

class _SelectorState<N extends StateNotifier<S>, S, T>
    extends State<Selector<N, S, T>> {
  late T _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selector(widget.notifier.state);
    widget.notifier.addListener(_onStateChange);
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    final newValue = widget.selector(widget.notifier.state);
    final areEqual =
        widget.equals?.call(_selectedValue, newValue) ??
        _selectedValue == newValue;

    if (!areEqual) {
      setState(() {
        _selectedValue = newValue;
      });
    }
  }

  @override
  void didUpdateWidget(covariant Selector<N, S, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notifier != widget.notifier) {
      oldWidget.notifier.removeListener(_onStateChange);
      widget.notifier.addListener(_onStateChange);
      _selectedValue = widget.selector(widget.notifier.state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _selectedValue);
  }
}
