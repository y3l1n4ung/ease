/// Simple Flutter state management with InheritedWidget + code generation.
///
/// Usage:
/// ```dart
/// // 1. Define state
/// @ease
/// class CounterState extends StateNotifier<int> {
///   CounterState() : super(0);
///   void increment() => state++;
/// }
///
/// // 2. Run app with DevTools (optional)
/// void main() {
///   initializeEase(); // Initialize DevTools (debug only)
///   runApp(Ease(child: MyApp()));
/// }
///
/// // 3. Use
/// final counter = context.get<CounterState>();
/// Text('${counter.state}');
/// ```
library ease;

import 'package:flutter/foundation.dart';

import 'src/devtools.dart';

export 'package:ease_annotation/ease_annotation.dart';
export 'src/devtools.dart' show EaseDevTools, StateChangeRecord, StateInfo;
export 'src/state_notifier.dart';

/// Initialize Ease state management.
///
/// Call this in your `main()` function before `runApp()` to enable
/// DevTools integration in debug mode.
///
/// This is a no-op in release mode, so it's safe to always call it.
///
/// ```dart
/// void main() {
///   initializeEase();
///   runApp(const Ease(child: MyApp()));
/// }
/// ```
void initializeEase() {
  if (kDebugMode) {
    EaseDevTools().initialize();
  }
}
