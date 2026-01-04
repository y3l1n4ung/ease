# Ease State Helper

A simple Flutter state management helper that makes using Flutter's internal state management easier.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.22+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-blue.svg)](https://dart.dev)

## Features

- **Simple API** - Watch, read, and select patterns for state access
- **Type-safe** - Full type inference with context extensions
- **Performant** - Selective rebuilds with `select` method
- **Flexible** - Two approaches: VS Code extension or code generation
- **DevTools** - Optional debugging integration

## Quick Start

### Installation

```yaml
dependencies:
  ease_state_helper: ^1.0.0
```

### Create a ViewModel

```dart
import 'package:ease_state_helper/ease_state_helper.dart';

part 'counter_view_model.ease.dart';

class CounterViewModel extends StateNotifier<int> {
  CounterViewModel() : super(0);

  void increment() => state++;
  void decrement() => state--;
}
```

### Register Provider

```dart
void main() {
  runApp(
    Ease(
      providers: [
        (child) => CounterViewModelProvider(child: child),
      ],
      child: const MyApp(),
    ),
  );
}
```

### Use in Widgets

```dart
// Watch - rebuilds when state changes
final counter = context.counterViewModel;
Text('Count: ${counter.state}');

// Read - no rebuild, use for callbacks
onPressed: () => context.readCounterViewModel().increment(),

// Select - rebuilds only when selected value changes
final count = context.selectCounterViewModel((s) => s);
```

## Two Approaches

| Approach | Annotation | Build Runner |
|----------|------------|--------------|
| **VS Code Extension** | Not needed | Not needed |
| **Code Generation** | `@ease()` required | Required |

### Option 1: VS Code Extension

No annotation, no build_runner needed.

1. Install **Ease State Helper** VS Code extension
2. Right-click folder → **Ease: New ViewModel**
3. Enter name and state type

The extension generates both `.dart` and `.ease.dart` files.

### Option 2: Code Generation

Requires `@ease()` annotation and build_runner.

```yaml
dependencies:
  ease_state_helper: ^1.0.0
  ease_annotation: ^1.0.0

dev_dependencies:
  ease_generator: ^1.0.0
  build_runner: ^2.4.0
```

Add `@ease()` annotation and run:

```bash
dart run build_runner build
```

Use auto-generated `$easeProviders`:

```dart
import 'ease.g.dart';

void main() {
  runApp(
    Ease(
      providers: $easeProviders,
      child: const MyApp(),
    ),
  );
}
```

## API Reference

### StateNotifier\<T\>

Base class for ViewModels:

```dart
class MyViewModel extends StateNotifier<MyState> {
  MyViewModel() : super(MyState());

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void toggleActive() {
    update((current) => current.copyWith(active: !current.active));
  }
}
```

### Context Extensions

| Method | Subscribes | Use Case |
|--------|------------|----------|
| `context.myViewModel` | Yes | Display state in UI |
| `context.readMyViewModel()` | No | Callbacks, event handlers |
| `context.selectMyViewModel((s) => s.field)` | Partial | Rebuild only when field changes |

### Select for Performance

```dart
// Rebuilds only when itemCount changes
final count = context.selectCartViewModel((s) => s.itemCount);

// For lists, use custom equality
final items = context.selectCartViewModel(
  (s) => s.items,
  equals: (a, b) => listEquals(a, b),
);
```

## Packages

| Package | Description |
|---------|-------------|
| [ease_state_helper](packages/ease_state_helper) | Core runtime |
| [ease_annotation](packages/ease_annotation) | `@ease()` annotation |
| [ease_generator](packages/ease_generator) | Code generator |
| [ease_devtools_extension](packages/ease_devtools_extension) | DevTools integration |

## DevTools Support

```yaml
dev_dependencies:
  ease_devtools_extension: ^1.0.0
```

```dart
void main() {
  initializeEase();
  runApp(Ease(providers: [...], child: MyApp()));
}
```

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) before submitting a PR.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
