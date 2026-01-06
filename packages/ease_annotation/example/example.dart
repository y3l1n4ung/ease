import 'package:ease_annotation/ease_annotation.dart';

// Use @Ease() annotation to mark StateNotifier classes for code generation.
// After running `dart run build_runner build`, providers and context
// extensions will be generated automatically.

// Example 1: Global provider (included in EaseScope)
@Ease()
class CounterViewModel {
  // This would extend StateNotifier<int> in a real app
  int state = 0;

  void increment() => state++;
  void decrement() => state--;
}

// Example 2: Local provider (manually placed in widget tree)
@Ease(local: true)
class FormViewModel {
  // This would extend StateNotifier<FormState> in a real app
  // Local providers are NOT included in EaseScope
  // You must manually add FormViewModelProvider to your widget tree
}

void main() {
  // The @Ease() annotation is processed at build time.
  // Run: dart run build_runner build
  //
  // This generates:
  // - CounterViewModelProvider widget
  // - context.counterViewModel (watch, rebuilds on change)
  // - context.readCounterViewModel() (read, no rebuild)
  // - context.selectCounterViewModel((s) => s.field) (granular rebuild)
}
