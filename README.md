# Ease

A simple, Flutter state management helper

[![Pub Version](https://img.shields.io/pub/v/ease)](https://pub.dev/packages/ease)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Features

- Simple API with `context.myState` getter
- Optimal performance using `InheritedModel`
- Zero boilerplate with code generation
- Type-safe state access
- Automatic provider nesting
- Watch (`context.myState`) and read (`context.readMyState()`) patterns
- Selector pattern (`context.selectMyState((s) => s.field)`) for granular rebuilds
- DevTools integration for debugging

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  ease: ^1.0.0

dev_dependencies:
  ease_generator: ^1.0.0
  build_runner: ^2.4.0
```

For DevTools support (optional):

```yaml
dev_dependencies:
  ease_devtools_extension: ^1.0.0
```

## Quick Start

### 1. Create a State Class

```dart
import 'package:ease_state_helper/ease_state_helper.dart';

part 'counter_view_model.ease.dart';

@ease()
class CounterViewModel extends StateNotifier<int> {
  CounterViewModel() : super(0);

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}
```

### 2. Run Code Generation

```bash
dart run build_runner build
```

### 3. Wrap Your App

```dart
import 'ease.g.dart';

void main() {
  initializeEase(); // Optional: enables DevTools
  runApp(const Ease(child: MyApp()));
}
```

### 4. Use the State

```dart
// Watch - rebuilds when state changes
final count = context.counterViewModel.state;

// Read - doesn't rebuild, use in callbacks
onPressed: () => context.readCounterViewModel().increment(),

// Select - rebuilds only when selected value changes
final itemCount = context.selectCartViewModel((s) => s.items.length);
```

## API

### StateNotifier

Base class for all state objects:

```dart
@ease()
class CartViewModel extends StateNotifier<CartStatus> {
  CartViewModel() : super(const CartStatus());

  // Update state with copyWith pattern
  void addToCart(Product product) {
    state = state.copyWith(
      items: [...state.items, CartItem(product: product)],
    );
  }

  // Use update() for transformations based on current state
  void clearCart() {
    update((current) => const CartStatus());
  }
}
```

### Context Extensions

Generated for each `@ease()` class:

```dart
// Watch - widget rebuilds on changes
context.myState         // getter, subscribes to changes
context.get<MyState>()  // generic version

// Read - no rebuild, for callbacks
context.readMyState()   // method, doesn't subscribe
context.read<MyState>() // generic version

// Select - granular rebuilds
context.selectMyState((s) => s.field)  // only rebuilds when field changes
```

## DevTools

Ease includes a DevTools extension for debugging state changes.

1. Add `ease_devtools_extension` to your dev_dependencies
2. Call `initializeEase()` before `runApp()`
3. Open Flutter DevTools and look for the "Ease" tab

Features:
- View all registered states
- Inspect current state values
- Track state change history with timestamps
- Filter history by state type

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for development setup, project structure, and contribution guidelines.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Author

**Ye Lin Aung** - [@b14ckc0d3](https://github.com/b14ckc0d3)
