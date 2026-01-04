import 'state_notifier.dart';

/// Event fired when state changes.
class StateChangeEvent<T> {
  /// The name of the state class.
  final String stateName;

  /// The StateNotifier that changed.
  final StateNotifier<T> notifier;

  /// The previous state value.
  final T oldState;

  /// The new state value.
  final T newState;

  /// Optional action name for better debugging visibility.
  final String? action;

  /// When the change occurred.
  final DateTime timestamp;

  StateChangeEvent({
    required this.stateName,
    required this.notifier,
    required this.oldState,
    required this.newState,
    this.action,
  }) : timestamp = DateTime.now();
}

/// Event fired when state initializes.
class StateInitEvent<T> {
  /// The name of the state class.
  final String stateName;

  /// The StateNotifier that initialized.
  final StateNotifier<T> notifier;

  /// The initial state value.
  final T initialState;

  /// When initialization occurred.
  final DateTime timestamp;

  StateInitEvent({
    required this.stateName,
    required this.notifier,
    required this.initialState,
  }) : timestamp = DateTime.now();
}

/// Event fired when state is disposed.
class StateDisposeEvent {
  /// The name of the state class.
  final String stateName;

  /// When disposal occurred.
  final DateTime timestamp;

  StateDisposeEvent({
    required this.stateName,
  }) : timestamp = DateTime.now();
}

/// Event fired on error.
class StateErrorEvent {
  /// The name of the state class.
  final String stateName;

  /// The error that occurred.
  final Object error;

  /// The stack trace.
  final StackTrace stackTrace;

  /// The last known state before error (if available).
  final dynamic lastState;

  /// When the error occurred.
  final DateTime timestamp;

  StateErrorEvent({
    required this.stateName,
    required this.error,
    required this.stackTrace,
    this.lastState,
  }) : timestamp = DateTime.now();
}

/// Base class for Ease middleware.
///
/// Middleware can intercept state changes for logging, analytics,
/// debugging, persistence, and other cross-cutting concerns.
///
/// Example:
/// ```dart
/// class LoggingMiddleware extends EaseMiddleware {
///   @override
///   void onStateChange<T>(StateChangeEvent<T> event) {
///     debugPrint('[${event.stateName}] ${event.oldState} -> ${event.newState}');
///   }
/// }
///
/// void main() {
///   StateNotifier.middleware = [LoggingMiddleware()];
///   runApp(const MyApp());
/// }
/// ```
abstract class EaseMiddleware {
  /// Called before state change (blocking).
  ///
  /// Use this to perform validation or logging before the change is applied.
  void onBeforeStateChange<T>(StateChangeEvent<T> event) {}

  /// Called after state change (blocking).
  ///
  /// Use this for logging, analytics, or synchronous side effects.
  void onStateChange<T>(StateChangeEvent<T> event) {}

  /// Called after state change (non-blocking).
  ///
  /// Use this for async operations like persistence or network calls.
  /// Exceptions are caught and reported to [onError].
  Future<void> onStateChangeAsync<T>(StateChangeEvent<T> event) async {}

  /// Called when state initializes.
  ///
  /// Use this to restore persisted state or set up initial values.
  void onStateInit<T>(StateInitEvent<T> event) {}

  /// Called when state is disposed.
  ///
  /// Use this for cleanup operations.
  void onStateDispose(StateDisposeEvent event) {}

  /// Called on error in middleware.
  ///
  /// Use this for error tracking and reporting.
  void onError(StateErrorEvent event) {}
}
