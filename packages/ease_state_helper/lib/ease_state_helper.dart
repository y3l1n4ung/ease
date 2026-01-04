/// Simple Flutter state management with InheritedWidget.
///
/// Usage:
/// ```dart
/// // 1. Define ViewModel
/// class CounterViewModel extends StateNotifier<int> {
///   CounterViewModel() : super(0);
///   void increment() => state++;
/// }
///
/// // 2. Create .ease.dart file using VS Code extension or codegen
///
/// // 3. Run app
/// void main() {
///   initializeEase(); // Initialize DevTools (debug only)
///   runApp(Ease(providers: [...], child: MyApp()));
/// }
///
/// // 4. Use
/// final counter = context.counterViewModel;
/// Text('${counter.state}');
/// ```
library ease_state_helper;

import 'package:flutter/foundation.dart';

import 'src/devtools.dart';

export 'src/devtools.dart' show EaseDevTools, StateChangeRecord, StateInfo;
export 'src/ease_widget.dart';
export 'src/middleware.dart';
export 'src/middleware/logging_middleware.dart';
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
///   runApp(Ease(providers: [...], child: MyApp()));
/// }
/// ```
void initializeEase() {
  if (kDebugMode) {
    EaseDevTools().initialize();
  }
}
