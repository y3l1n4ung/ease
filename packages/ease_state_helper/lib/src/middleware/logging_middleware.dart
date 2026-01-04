import 'package:flutter/foundation.dart';

import '../middleware.dart';

/// Built-in logging middleware for debugging state changes.
///
/// Example:
/// ```dart
/// void main() {
///   StateNotifier.middleware = [
///     LoggingMiddleware(),
///   ];
///   runApp(const MyApp());
/// }
/// ```
///
/// Output:
/// ```
/// [2024-01-15 10:30:45] INIT CounterViewModel: 0
/// [2024-01-15 10:30:46] CounterViewModel (increment) 0 -> 1
/// [2024-01-15 10:30:47] CounterViewModel 1 -> 2
/// ```
class LoggingMiddleware extends EaseMiddleware {
  /// Whether to include timestamp in log messages.
  final bool includeTimestamp;

  /// Whether to include stack trace in error logs.
  final bool includeStackTrace;

  /// Custom logger function. Defaults to [debugPrint].
  final void Function(String message)? logger;

  /// Filter to only log specific state types.
  /// If null, logs all states.
  final Set<Type>? includedStates;

  /// Filter to exclude specific state types.
  /// If null, no states are excluded.
  final Set<Type>? excludedStates;

  LoggingMiddleware({
    this.includeTimestamp = true,
    this.includeStackTrace = false,
    this.logger,
    this.includedStates,
    this.excludedStates,
  });

  void _log(String message) {
    if (logger != null) {
      logger!(message);
    } else {
      debugPrint(message);
    }
  }

  bool _shouldLog(Type stateType) {
    if (excludedStates != null && excludedStates!.contains(stateType)) {
      return false;
    }
    if (includedStates != null && !includedStates!.contains(stateType)) {
      return false;
    }
    return true;
  }

  String _formatTimestamp(DateTime timestamp) {
    if (!includeTimestamp) return '';
    return '[${timestamp.toIso8601String()}] ';
  }

  @override
  void onStateInit<T>(StateInitEvent<T> event) {
    if (!_shouldLog(event.notifier.runtimeType)) return;

    final ts = _formatTimestamp(event.timestamp);
    _log('${ts}INIT ${event.stateName}: ${event.initialState}');
  }

  @override
  void onStateChange<T>(StateChangeEvent<T> event) {
    if (!_shouldLog(event.notifier.runtimeType)) return;

    final ts = _formatTimestamp(event.timestamp);
    final action = event.action != null ? '(${event.action}) ' : '';
    _log('$ts${event.stateName} $action${event.oldState} -> ${event.newState}');
  }

  @override
  void onStateDispose(StateDisposeEvent event) {
    final ts = _formatTimestamp(event.timestamp);
    _log('${ts}DISPOSE ${event.stateName}');
  }

  @override
  void onError(StateErrorEvent event) {
    final ts = _formatTimestamp(event.timestamp);
    _log('${ts}ERROR ${event.stateName}: ${event.error}');
    if (includeStackTrace) {
      _log(event.stackTrace.toString());
    }
  }
}
