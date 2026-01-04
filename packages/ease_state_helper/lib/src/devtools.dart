import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import 'state_notifier.dart';

/// DevTools integration for Ease state management.
///
/// Provides debugging capabilities in development mode:
/// - View all registered states and their current values
/// - Track state change history with timestamps
/// - Service extensions for DevTools communication
///
/// All DevTools functionality is disabled in release mode for zero overhead.
///
/// Usage:
/// ```dart
/// void main() {
///   initializeEase(); // Initialize DevTools (debug only)
///   runApp(const Ease(child: MyApp()));
/// }
/// ```
class EaseDevTools {
  static final EaseDevTools _instance = EaseDevTools._();

  /// Returns the singleton instance of [EaseDevTools].
  factory EaseDevTools() => _instance;

  EaseDevTools._();

  /// Registry of all active states using weak references.
  /// Weak references prevent the DevTools from keeping states alive.
  final Map<String, WeakReference<StateNotifier>> _registry = {};

  /// History of state changes (limited to [_maxHistorySize]).
  final List<StateChangeRecord> _history = [];

  /// Maximum number of state changes to keep in history.
  static const int _maxHistorySize = 100;

  /// Whether DevTools integration is enabled.
  bool _enabled = false;

  /// Whether service extensions have been registered (can only register once).
  bool _extensionsRegistered = false;

  /// Timer for periodic registry cleanup.
  Timer? _cleanupTimer;

  /// Throttling for high-frequency updates.
  DateTime? _lastEventTime;
  static const Duration _throttleDuration = Duration(milliseconds: 16);

  /// Returns whether DevTools is currently enabled.
  bool get isEnabled => _enabled;

  /// Initialize DevTools integration.
  ///
  /// Should be called once at app startup, before [runApp].
  /// This is a no-op in release mode.
  void initialize() {
    if (!kDebugMode || _enabled) return;
    _enabled = true;

    // Service extensions can only be registered once per process
    if (!_extensionsRegistered) {
      _registerServiceExtensions();
      _extensionsRegistered = true;
    }

    // Clean up dead references periodically
    _cleanupTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _cleanupRegistry(),
    );

    developer.log('Ease DevTools initialized', name: 'ease');
  }

  /// Shut down DevTools integration.
  ///
  /// Clears all registrations and stops cleanup timer.
  void dispose() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
    _registry.clear();
    _history.clear();
    _enabled = false;
  }

  /// Register a state instance for DevTools tracking.
  void registerState(StateNotifier state) {
    if (!_enabled) return;

    final id = _stateId(state);
    _registry[id] = WeakReference(state);

    _postEventThrottled('ease:state_registered', {
      'id': id,
      'type': state.runtimeType.toString(),
    });
  }

  /// Unregister a state instance from DevTools tracking.
  void unregisterState(StateNotifier state) {
    if (!_enabled) return;

    final id = _stateId(state);
    _registry.remove(id);

    _postEventThrottled('ease:state_unregistered', {
      'id': id,
      'type': state.runtimeType.toString(),
    });
  }

  /// Record a state change for history tracking.
  ///
  /// [action] is an optional name for the action that caused this change,
  /// useful for debugging (e.g., 'increment', 'addItem', 'login').
  void recordStateChange<T>(
    StateNotifier<T> state,
    T oldState,
    T newState, {
    String? action,
  }) {
    if (!_enabled) return;

    final record = StateChangeRecord(
      stateId: _stateId(state),
      stateName: state.runtimeType.toString(),
      oldState: _truncate(oldState.toString()),
      newState: _truncate(newState.toString()),
      action: action,
      timestamp: DateTime.now(),
    );

    _history.add(record);
    if (_history.length > _maxHistorySize) {
      _history.removeAt(0);
    }

    _postEventThrottled('ease:state_change', {
      'state': record.stateName,
      'action': action,
      'timestamp': record.timestamp.toIso8601String(),
    });

    // Timeline event for performance tracking in DevTools Performance tab
    developer.Timeline.instantSync(
      'Ease: ${record.stateName}',
      arguments: {'action': action ?? 'update'},
    );
  }

  /// Check if a state is currently registered.
  bool stateExists(StateNotifier state) {
    final id = _stateId(state);
    final ref = _registry[id];
    return ref != null && ref.target != null;
  }

  /// Get the change history for a specific state.
  List<StateChangeRecord> getHistory(StateNotifier state) {
    final id = _stateId(state);
    return _history.where((r) => r.stateId == id).toList();
  }

  /// Get all registered states.
  List<StateInfo> getStates() {
    _cleanupRegistry();
    return _registry.entries.where((e) => e.value.target != null).map((e) {
      final state = e.value.target!;
      return StateInfo(
        id: e.key,
        type: state.runtimeType.toString(),
        value: _truncate(state.state.toString()),
        hasListeners: state.hasActiveListeners,
      );
    }).toList();
  }

  /// Clear the state change history.
  void clearHistory() {
    _history.clear();
  }

  void _registerServiceExtensions() {
    // Get all registered states
    developer.registerExtension('ext.ease.getStates', (method, params) async {
      final states = getStates()
          .map((s) => {
                'id': s.id,
                'type': s.type,
                'value': s.value,
                'hasListeners': s.hasListeners,
              })
          .toList();

      return developer.ServiceExtensionResponse.result(
        json.encode({'states': states}),
      );
    });

    // Get state change history
    developer.registerExtension('ext.ease.getHistory', (method, params) async {
      final stateId = params['stateId'];
      final history = stateId != null
          ? _history.where((r) => r.stateId == stateId).toList()
          : _history;

      return developer.ServiceExtensionResponse.result(
        json.encode({
          'history': history.map((r) => r.toJson()).toList(),
        }),
      );
    });

    // Get specific state details
    developer.registerExtension('ext.ease.getState', (method, params) async {
      final stateId = params['stateId'];
      if (stateId == null) {
        return developer.ServiceExtensionResponse.error(
          developer.ServiceExtensionResponse.invalidParams,
          'stateId is required',
        );
      }

      final ref = _registry[stateId];
      final state = ref?.target;
      if (state == null) {
        return developer.ServiceExtensionResponse.error(
          developer.ServiceExtensionResponse.extensionError,
          'State not found or disposed',
        );
      }

      return developer.ServiceExtensionResponse.result(
        json.encode({
          'id': stateId,
          'type': state.runtimeType.toString(),
          'value': state.state.toString(), // Full value for details view
          'hasListeners': state.hasActiveListeners,
        }),
      );
    });

    // Clear history
    developer.registerExtension(
      'ext.ease.clearHistory',
      (method, params) async {
        clearHistory();
        return developer.ServiceExtensionResponse.result(
          json.encode({'success': true}),
        );
      },
    );
  }

  void _cleanupRegistry() {
    _registry.removeWhere((_, ref) => ref.target == null);
  }

  String _stateId(StateNotifier state) =>
      '${state.runtimeType}_${identityHashCode(state)}';

  String _truncate(String value, {int maxLength = 200}) {
    if (value.length <= maxLength) return value;
    return '${value.substring(0, maxLength)}...';
  }

  void _postEventThrottled(String event, Map<String, dynamic> data) {
    final now = DateTime.now();
    if (_lastEventTime != null &&
        now.difference(_lastEventTime!) < _throttleDuration) {
      return; // Throttle high-frequency events
    }
    _lastEventTime = now;
    developer.postEvent(event, data);
  }
}

/// Record of a single state change.
class StateChangeRecord {
  /// Unique identifier for the state instance.
  final String stateId;

  /// Type name of the state (e.g., 'CounterViewModel').
  final String stateName;

  /// String representation of the old state value.
  final String oldState;

  /// String representation of the new state value.
  final String newState;

  /// Optional action name that caused this change.
  final String? action;

  /// Timestamp when this change occurred.
  final DateTime timestamp;

  StateChangeRecord({
    required this.stateId,
    required this.stateName,
    required this.oldState,
    required this.newState,
    this.action,
    required this.timestamp,
  });

  /// Convert to JSON for DevTools transmission.
  Map<String, dynamic> toJson() => {
        'stateId': stateId,
        'stateName': stateName,
        'oldState': oldState,
        'newState': newState,
        'action': action,
        'timestamp': timestamp.toIso8601String(),
      };

  @override
  String toString() =>
      'StateChange($stateName: $oldState -> $newState${action != null ? ' [$action]' : ''})';
}

/// Information about a registered state.
class StateInfo {
  /// Unique identifier for the state instance.
  final String id;

  /// Type name of the state.
  final String type;

  /// Current value (possibly truncated).
  final String value;

  /// Whether the state has active listeners.
  final bool hasListeners;

  StateInfo({
    required this.id,
    required this.type,
    required this.value,
    required this.hasListeners,
  });
}
