import 'package:flutter/foundation.dart';

/// Base class for state management.
///
/// Wraps a value of type [T] and notifies listeners when it changes.
/// Extends [ChangeNotifier] for compatibility with Flutter's listener pattern.
///
/// Example:
/// ```dart
/// @ease
/// class CounterState extends StateNotifier<int> {
///   CounterState() : super(0);
///
///   void increment() => state++;
///   void decrement() => state--;
///   void reset() => state = 0;
/// }
/// ```
///
/// The [state] setter automatically calls [notifyListeners] when the value
/// changes, triggering rebuilds in widgets that depend on this state.
class StateNotifier<T> extends ChangeNotifier {
  /// Creates a [StateNotifier] with an initial [state] value.
  StateNotifier(this._state);

  T _state;

  /// The current state value.
  ///
  /// Reading this value does not create a subscription.
  /// Use `context.get<T>()` to subscribe to changes.
  T get state => _state;

  /// Updates the state and notifies listeners if the value changed.
  ///
  /// Uses `!=` comparison to detect changes. For complex objects,
  /// ensure proper `==` implementation or use immutable state.
  set state(T value) {
    if (_state != value) {
      _state = value;
      notifyListeners();
    }
  }

  /// Updates state using a function that receives the current state.
  ///
  /// Useful for updates that depend on the current value:
  /// ```dart
  /// void increment() => update((s) => s + 1);
  /// ```
  void update(T Function(T current) updater) {
    state = updater(_state);
  }
}
