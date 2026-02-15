# Ease Generator

Code generator for the [Ease State Helper](https://pub.dev/packages/ease_state_helper) library. It generates `InheritedModel` providers and type-safe `BuildContext` extensions for classes annotated with `@ease`.

---

## Ease Ecosystem

This package is the "engine" of the **Ease State Helper** ecosystem. It automates the boilerplate required to make Flutter's native state management feel modern and intuitive.

| Package | Role | Dependency Type |
|---------|------|-----------------|
| [ease_state_helper](../ease_state_helper) | Core runtime logic | `dependencies` |
| [ease_annotation](../ease_annotation) | Metadata for codegen | `dependencies` |
| **ease_generator** | Code generator | `dev_dependencies` |
| [ease_devtools_extension](../ease_devtools_extension) | Debugging tools | `dev_dependencies` |

---

## Features

- **Automatic Provider Generation** - Creates `CounterViewModelProvider` for your `CounterViewModel`.
- **Type-safe Context Extensions** - Generate `.counterViewModel`, `.readCounterViewModel()`, and `.selectCounterViewModel()`.
- **InheritedModel Support** - Leverages Flutter's most efficient state propagation mechanism.
- **Side Effect Listeners** - Generates `.listenOnCounterViewModel()` for snackbars, navigation, etc.

## How it Works

The generator scans your codebase for classes extending `StateNotifier<T>` and annotated with `@ease`. It then generates a companion `.ease.dart` file containing all the "glue" code needed to integrate your ViewModel with the Flutter widget tree.

```yaml
dependencies:
  ease_state_helper: ^0.3.0
  ease_annotation: ^0.2.0

dev_dependencies:
  ease_generator: ^0.3.0
  build_runner: ^2.4.0
```

## Usage

### 1. Annotate your ViewModel

The class must extend `StateNotifier<T>`.

```dart
import 'package:ease_annotation/ease_annotation.dart';
import 'package:ease_state_helper/ease_state_helper.dart';

part 'counter_view_model.ease.dart';

@ease
class CounterViewModel extends StateNotifier<int> {
  CounterViewModel() : super(0);

  void increment() => state++;
}
```

### 2. Generate the code

Run the build command:

```bash
dart run build_runner build
```

### 3. Use the generated extensions

The generator creates type-safe extensions on `BuildContext`:

```dart
// 1. Watch (Subscribes to all changes)
final notifier = context.counterViewModel;

// 2. Read (No subscription, for callbacks)
context.readCounterViewModel().increment();

// 3. Select (Subscribes to specific field)
final value = context.selectCounterViewModel((state) => state);

// 4. Listen (Side effects)
context.listenOnCounterViewModel((prev, next) {
  print('Changed from $prev to $next');
});
```

## Generated Code

For a class `CounterViewModel`, the generator creates:
- `CounterViewModelProvider`: A `StatefulWidget` that manages the lifecycle.
- `_CounterViewModelInherited`: An `InheritedModel` for state propagation.
- `CounterViewModelContext`: An extension on `BuildContext` with `counterViewModel`, `readCounterViewModel()`, `selectCounterViewModel()`, and `listenOnCounterViewModel()`.

## License

MIT
