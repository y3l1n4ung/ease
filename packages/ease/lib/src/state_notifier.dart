import 'package:flutter/foundation.dart';

import 'devtools.dart';
import 'middleware.dart';

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
///
/// In debug mode, state changes are automatically tracked by DevTools.
/// Use [setState] with an action name for better debugging visibility.
///
/// ## Middleware
///
/// You can add middleware to intercept state changes:
/// ```dart
/// StateNotifier.middleware = [LoggingMiddleware()];
/// ```
class StateNotifier<T> extends ChangeNotifier {
  /// Global middleware list.
  ///
  /// Middleware is called in order for each state change.
  /// Set this before creating any StateNotifier instances.
  ///
  /// Example:
  /// ```dart
  /// void main() {
  ///   StateNotifier.middleware = [
  ///     LoggingMiddleware(),
  ///     AnalyticsMiddleware(),
  ///   ];
  ///   runApp(const MyApp());
  /// }
  /// ```
  static List<EaseMiddleware> middleware = [];

  /// Flag to prevent recursive middleware calls.
  static bool _isNotifyingMiddleware = false;

  /// Creates a [StateNotifier] with an initial [state] value.
  StateNotifier(this._state) {
    if (kDebugMode) {
      EaseDevTools().registerState(this);
    }
    _notifyInit();
  }

  T _state;

  /// The current state value.
  ///
  /// Reading this value does not create a subscription.
  /// Use `context.get<T>()` to subscribe to changes.
  T get state => _state;

  /// Whether this notifier has any registered listeners.
  ///
  /// Used by DevTools to show state subscription status.
  bool get hasActiveListeners => hasListeners;

  /// Updates the state and notifies listeners if the value changed.
  ///
  /// Uses `!=` comparison to detect changes. For complex objects,
  /// ensure proper `==` implementation or use immutable state.
  ///
  /// In debug mode, state changes are automatically recorded for DevTools.
  set state(T value) {
    if (_state != value) {
      final oldState = _state;
      _state = value;

      _notifyMiddleware(oldState, value);

      if (kDebugMode) {
        EaseDevTools().recordStateChange(this, oldState, value);
      }

      notifyListeners();
    }
  }

  /// Updates state with an action name for better DevTools visibility.
  ///
  /// The [action] parameter appears in DevTools history, making it easier
  /// to understand what caused each state change.
  ///
  /// Example:
  /// ```dart
  /// void addItem(Item item) {
  ///   setState(
  ///     state.copyWith(items: [...state.items, item]),
  ///     action: 'addItem',
  ///   );
  /// }
  /// ```
  void setState(T value, {String? action}) {
    if (_state != value) {
      final oldState = _state;
      _state = value;

      _notifyMiddleware(oldState, value, action: action);

      if (kDebugMode) {
        EaseDevTools().recordStateChange(this, oldState, value, action: action);
      }

      notifyListeners();
    }
  }

  /// Updates state using a function that receives the current state.
  ///
  /// Useful for updates that depend on the current value:
  /// ```dart
  /// void increment() => update((s) => s + 1);
  /// ```
  ///
  /// Optionally provide an [action] name for DevTools visibility.
  void update(T Function(T current) updater, {String? action}) {
    if (action != null) {
      setState(updater(_state), action: action);
    } else {
      state = updater(_state);
    }
  }

  /// Notifies middleware about state initialization.
  void _notifyInit() {
    if (middleware.isEmpty) return;

    final event = StateInitEvent<T>(
      stateName: runtimeType.toString(),
      notifier: this,
      initialState: _state,
    );

    for (final m in middleware) {
      try {
        m.onStateInit(event);
      } catch (e, st) {
        _notifyError(e, st);
      }
    }
  }

  /// Notifies middleware about state changes.
  void _notifyMiddleware(T oldState, T newState, {String? action}) {
    if (middleware.isEmpty || _isNotifyingMiddleware) return;

    _isNotifyingMiddleware = true;
    try {
      final event = StateChangeEvent<T>(
        stateName: runtimeType.toString(),
        notifier: this,
        oldState: oldState,
        newState: newState,
        action: action,
      );

      // Before change hooks (sync)
      for (final m in middleware) {
        try {
          m.onBeforeStateChange(event);
        } catch (e, st) {
          _notifyError(e, st);
        }
      }

      // After change hooks (sync)
      for (final m in middleware) {
        try {
          m.onStateChange(event);
        } catch (e, st) {
          _notifyError(e, st);
        }
      }

      // Async hooks (fire and forget)
      for (final m in middleware) {
        m.onStateChangeAsync(event).catchError((e, st) {
          _notifyError(e, st);
        });
      }
    } finally {
      _isNotifyingMiddleware = false;
    }
  }

  /// Notifies middleware about errors.
  void _notifyError(Object error, StackTrace stackTrace) {
    final event = StateErrorEvent(
      stateName: runtimeType.toString(),
      error: error,
      stackTrace: stackTrace,
      lastState: _state,
    );

    for (final m in middleware) {
      try {
        m.onError(event);
      } catch (_) {
        // Prevent error loop
      }
    }
  }

  @override
  void dispose() {
    // Notify middleware about disposal
    if (middleware.isNotEmpty) {
      final event = StateDisposeEvent(stateName: runtimeType.toString());
      for (final m in middleware) {
        try {
          m.onStateDispose(event);
        } catch (_) {
          // Don't throw during disposal
        }
      }
    }

    if (kDebugMode) {
      EaseDevTools().unregisterState(this);
    }
    super.dispose();
  }
}
