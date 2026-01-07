# Ease Generator

[![pub package](https://img.shields.io/pub/v/ease_generator.svg)](https://pub.dev/packages/ease_generator)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Code generator for [Ease State Helper](https://pub.dev/packages/ease_state_helper).

## Installation

```yaml
dependencies:
  ease_state_helper: ^0.2.0
  ease_annotation: ^0.2.0

dev_dependencies:
  ease_generator: ^0.2.0
  build_runner: ^2.4.0
```

## Usage

### 1. Annotate your ViewModel

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

### 2. Run generator

```bash
dart run build_runner build
```

### 3. Use generated code

```dart
import 'counter_view_model.dart';

void main() {
  runApp(
    CounterViewModelProvider(
      child: const MyApp(),
    ),
  );
}

// In widgets:
final counter = context.counterViewModel; // Watch (rebuilds on change)
context.readCounterViewModel().increment(); // Read (no rebuild)
```

## Generated Files

- `*.ease.dart` - Provider widget and context extensions per ViewModel

## What Gets Generated

For each `@ease` annotated class, the generator creates:

- **`{ClassName}Provider`** - StatefulWidget that manages the ViewModel lifecycle
- **`_{ClassName}Inherited`** - InheritedModel for efficient state propagation
- **Context extensions**:
  - `context.className` - Watch state (rebuilds widget on changes)
  - `context.readClassName()` - Read state without subscribing
  - `context.selectClassName((s) => s.field)` - Selective rebuilds

## Nesting Multiple Providers

Use `EaseScope` to nest multiple providers:

```dart
void main() {
  runApp(
    EaseScope(
      providers: [
        (child) => CounterViewModelProvider(child: child),
        (child) => UserViewModelProvider(child: child),
        (child) => CartViewModelProvider(child: child),
      ],
      child: const MyApp(),
    ),
  );
}
```

Or nest them manually:

```dart
void main() {
  runApp(
    CounterViewModelProvider(
      child: UserViewModelProvider(
        child: CartViewModelProvider(
          child: const MyApp(),
        ),
      ),
    ),
  );
}
```

## License

MIT
