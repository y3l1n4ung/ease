// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:ease_state_helper/ease_state_helper.dart';

import 'view_models/counter_view_model.dart';

// ============================================
// Generated Providers List
// ============================================

/// All generated providers for @ease annotated classes.
///
/// Usage:
/// ```dart
/// import 'ease.g.dart';
///
/// void main() => runApp(
///   EaseScope(providers: $easeProviders, child: MyApp()),
/// );
/// ```
final $easeProviders = <ProviderBuilder>[
  (child) => CounterViewModelProvider(child: child),
];

// ============================================
// Generic Context Extension
// ============================================

/// Extension providing generic access to all @ease states.
///
/// Note: Local providers are not accessible via get<T>() or read<T>().
/// Use the typed context extensions instead (e.g., context.formState).
extension EaseContext on BuildContext {
  /// Gets a state by type and subscribes to changes.
  ///
  /// Example:
  /// ```dart
  /// final counter = context.get<CounterState>();
  /// ```
  T get<T extends StateNotifier>() {
    if (T == CounterViewModel) return counterViewModel as T;
    throw StateError('No provider found for $T. Did you add @ease annotation?');
  }

  /// Gets a state by type without subscribing to changes.
  ///
  /// Example:
  /// ```dart
  /// final counter = context.read<CounterState>();
  /// ```
  T read<T extends StateNotifier>() {
    if (T == CounterViewModel) return readCounterViewModel() as T;
    throw StateError('No provider found for $T. Did you add @ease annotation?');
  }
}
