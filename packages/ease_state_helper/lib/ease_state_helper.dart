/// Simple Flutter state management helper.
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
///   initializeEaseDevTool(); // Initialize DevTools (debug only)
///   runApp(EaseScope(providers: [...], child: MyApp()));
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

/// Initialize Ease DevTools integration.
///
/// Call this in your `main()` function before `runApp()` to enable
/// DevTools integration in debug mode.
///
/// ```dart
/// void main() {
///   initializeEaseDevTool();
///   runApp(EaseScope(providers: [...], child: MyApp()));
/// }
/// ```
void initializeEaseDevTool() {
  if (kDebugMode) {
    EaseDevTools().initialize();
  }
}
