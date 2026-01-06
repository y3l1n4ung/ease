// This package is a code generator for ease_state_helper.
// It processes @Ease() annotations and generates provider code.
//
// ## Setup
//
// Add to your pubspec.yaml:
// ```yaml
// dependencies:
//   ease_state_helper: ^0.1.0
//   ease_annotation: ^0.1.0
//
// dev_dependencies:
//   ease_generator: ^0.1.0
//   build_runner: ^2.4.0
// ```
//
// ## Usage
//
// 1. Create a ViewModel with @Ease() annotation:
//
// ```dart
// import 'package:ease_annotation/ease_annotation.dart';
// import 'package:ease_state_helper/ease_state_helper.dart';
//
// part 'counter_view_model.ease.dart';
//
// @Ease()
// class CounterViewModel extends StateNotifier<int> {
//   CounterViewModel() : super(0);
//   void increment() => state++;
// }
// ```
//
// 2. Run the generator:
//
// ```bash
// dart run build_runner build
// ```
//
// 3. Use the generated code:
//
// ```dart
// import 'ease.g.dart';
//
// void main() {
//   runApp(
//     EaseScope(
//       providers: $easeProviders, // Auto-generated list
//       child: const MyApp(),
//     ),
//   );
// }
// ```
//
// The generator creates:
// - `*.ease.dart` - Per-file provider and context extensions
// - `ease.g.dart` - Aggregated $easeProviders list

void main() {
  // This is a build-time code generator.
  // See the documentation above for usage.
}
