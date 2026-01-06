# Ease State Helper

A lightweight Flutter state management library built on `InheritedWidget` with code generation support.

[![pub package](https://img.shields.io/pub/v/ease_state_helper.svg)](https://pub.dev/packages/ease_state_helper)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.22+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-blue.svg)](https://dart.dev)
[![codecov](https://codecov.io/github/y3l1n4ung/ease/graph/badge.svg?token=EZDDCOCOAT)](https://codecov.io/github/y3l1n4ung/ease)

---

## Table of Contents

- [Why Ease?](#why-ease)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Core Concepts](#core-concepts)
- [API Reference](#api-reference)
- [Advanced Usage](#advanced-usage)
- [DevTools Support](#devtools-support)
- [Packages](#packages)
- [Examples](#examples)
- [Contributing](#contributing)

---

## Why Ease?

| Feature | Ease | Provider | Riverpod | Bloc |
|---------|------|----------|----------|------|
| Built on Flutter primitives | ✅ InheritedModel | ✅ | ❌ | ❌ |
| Code generation optional | ✅ | ✅ | ⚠️ Recommended | ❌ |
| Selective rebuilds | ✅ `select()` | ✅ | ✅ | ✅ |
| DevTools integration | ✅ | ✅ | ✅ | ✅ |
| Learning curve | Low | Low | Medium | High |
| Boilerplate | Minimal | Minimal | Medium | High |

**Ease is ideal when you want:**
- Simple state management without heavy dependencies
- Flutter's native patterns (InheritedWidget) with less boilerplate

---

## Installation

### Minimal Setup (VS Code Extension)

```yaml
dependencies:
  ease_state_helper: ^0.1.0
```

### Full Setup (Code Generation)

```yaml
dependencies:
  ease_state_helper: ^0.1.0
  ease_annotation: ^0.1.0

dev_dependencies:
  ease_generator: ^0.1.0
  build_runner: ^2.4.0
```

---

## Quick Start

### 1. Create a ViewModel

```dart
import 'package:ease_annotation/ease_annotation.dart';
import 'package:ease_state_helper/ease_state_helper.dart';

part 'counter_view_model.ease.dart';

@ease
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

This generates:
- `counter_view_model.ease.dart` - Provider and context extensions
- `ease.g.dart` - Aggregated `$easeProviders` list

### 3. Register Providers

```dart
import 'package:flutter/material.dart';
import 'package:ease_state_helper/ease_state_helper.dart';
import 'ease.g.dart';

void main() {
  runApp(
    EaseScope(
      providers: $easeProviders,
      child: const MyApp(),
    ),
  );
}
```

### 4. Use in Widgets

```dart
class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch - rebuilds when state changes
    final counter = context.counterViewModel;

    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Text(
          '${counter.state}',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Read - no rebuild, use in callbacks
        onPressed: () => context.readCounterViewModel().increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

## Core Concepts

### StateNotifier\<T\>

Base class for all ViewModels. Extends `ChangeNotifier` with a typed `state` property.

```dart
class CartViewModel extends StateNotifier<CartState> {
  CartViewModel() : super(const CartState());

  // Direct assignment
  void clear() => state = const CartState();

  // Update based on current state
  void addItem(Product product) {
    state = state.copyWith(
      items: [...state.items, CartItem(product: product)],
    );
  }

  // Using update helper
  void toggleLoading() {
    update((current) => current.copyWith(isLoading: !current.isLoading));
  }
}
```

### EaseScope

Root widget that provides all registered ViewModels to the widget tree.

```dart
EaseScope(
  providers: $easeProviders, // Auto-generated list
  child: const MyApp(),
)
```

Or register providers manually:

```dart
EaseScope(
  providers: [
    (child) => CounterViewModelProvider(child: child),
    (child) => CartViewModelProvider(child: child),
  ],
  child: const MyApp(),
)
```

### @ease Annotation

Marks a `StateNotifier` class for code generation.

```dart
// Global provider - included in $easeProviders
@ease
class AppViewModel extends StateNotifier<AppState> { ... }

// Local provider - manually placed in widget tree
@Ease(local: true)
class FormViewModel extends StateNotifier<FormState> { ... }
```

---

## API Reference

### Context Extensions

For each ViewModel, these extensions are generated:

| Method | Subscribes | Rebuilds | Use Case |
|--------|------------|----------|----------|
| `context.myViewModel` | ✅ Yes | On any change | Display state in UI |
| `context.readMyViewModel()` | ❌ No | Never | Callbacks, event handlers |
| `context.selectMyViewModel((s) => s.field)` | ✅ Partial | When selected value changes | Optimized rebuilds |
| `context.listenOnMyViewModel((prev, next) => ...)` | ❌ No | Never | Side effects |

### Watch (Subscribe)

```dart
// Rebuilds entire widget when ANY state property changes
final cart = context.cartViewModel;
Text('Items: ${cart.state.items.length}');
Text('Total: \$${cart.state.total}');
```

### Read (No Subscribe)

```dart
// Never rebuilds - use for callbacks and event handlers
ElevatedButton(
  onPressed: () {
    final cart = context.readCartViewModel();
    cart.addItem(product);
  },
  child: const Text('Add to Cart'),
)
```

### Select (Partial Subscribe)

```dart
// Only rebuilds when itemCount changes
final itemCount = context.selectCartViewModel((s) => s.itemCount);

// With custom equality for complex types
final items = context.selectCartViewModel(
  (s) => s.items,
  equals: (a, b) => listEquals(a, b),
);
```

### Listen (Side Effects)

```dart
@override
void initState() {
  super.initState();

  // Listen for errors and show snackbar
  context.listenOnCartViewModel((prev, next) {
    if (next.error != null && prev.error != next.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(next.error!)),
      );
    }
  });

  // No dispose needed - auto-cleanup when widget unmounts
}
```

---

## Advanced Usage

### Complex State with copyWith

```dart
class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? error;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  // Computed properties
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get tax => subtotal * 0.1;
  double get total => subtotal + tax;

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
```

### Local/Scoped Providers

For state that should be scoped to a specific part of the widget tree:

```dart
@Ease(local: true)
class FormViewModel extends StateNotifier<FormState> {
  FormViewModel() : super(const FormState());
  // ...
}

// Manually wrap the subtree that needs this state
class MyFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormViewModelProvider(
      child: const FormContent(),
    );
  }
}
```

### Middleware

Add logging or other middleware to all state changes:

```dart
void main() {
  StateNotifier.middleware = [
    LoggingMiddleware(),
    // Add custom middleware
  ];
  runApp(EaseScope(providers: $easeProviders, child: const MyApp()));
}
```

---

## DevTools Support

Debug your Ease states in Flutter DevTools.

### Setup

```yaml
dev_dependencies:
  ease_devtools_extension: ^0.1.0
```

```dart
void main() {
  initializeEaseDevTool(); // Enable DevTools integration
  runApp(EaseScope(providers: $easeProviders, child: const MyApp()));
}
```

### Features

- **State Inspector** - View all registered states and current values
- **History Timeline** - Track state changes with timestamps
- **Action Tracking** - See what triggered each state change
- **Filter Support** - Filter history by state type

---

## Packages

| Package | Description | pub.dev |
|---------|-------------|---------|
| [ease_state_helper](packages/ease_state_helper) | Core runtime library | [![pub](https://img.shields.io/pub/v/ease_state_helper.svg)](https://pub.dev/packages/ease_state_helper) |
| [ease_annotation](packages/ease_annotation) | `@Ease()` annotation | [![pub](https://img.shields.io/pub/v/ease_annotation.svg)](https://pub.dev/packages/ease_annotation) |
| [ease_generator](packages/ease_generator) | Code generator | [![pub](https://img.shields.io/pub/v/ease_generator.svg)](https://pub.dev/packages/ease_generator) |
| [ease_devtools_extension](packages/ease_devtools_extension) | DevTools integration | [![pub](https://img.shields.io/pub/v/ease_devtools_extension.svg)](https://pub.dev/packages/ease_devtools_extension) |

---

## Examples

Check out the example apps in the repository:

| Example | Description |
|---------|-------------|
| [example](apps/example) | Comprehensive examples: Counter, Todo, Cart, Auth, Theme |
| [shopping_app](apps/shopping_app) | Real-world e-commerce app with FakeStore API |

### Running Examples

```bash
cd apps/example
flutter pub get
dart run build_runner build
flutter run
```

---

## VS Code Extension

For a no-code-generation workflow:

1. Install **Ease State Helper** extension from VS Code marketplace
2. Right-click folder → **Ease: New ViewModel**
3. Enter name and state type

The extension generates both `.dart` and `.ease.dart` files without needing build_runner.

---

## Contributing

Contributions are welcome!

Here's how you can help:

- 🐛 **Bug reports** - Found an edge case or unexpected behavior? Open an issue
- 📖 **Documentation** - Improve guides, fix typos, or add code examples
- ✨ **Features** - Have an idea? Discuss it in an issue first, then submit a PR
- 🧪 **Tests** - Help improve test coverage

### Development Setup

```bash
git clone https://github.com/y3l1n4ung/ease.git
cd ease
melos bootstrap
melos run test:all
```

See the [Contributing Guide](CONTRIBUTING.md) for detailed guidelines.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
