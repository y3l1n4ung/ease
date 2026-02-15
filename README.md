# Ease State Helper

A lightweight helper library that makes Flutter’s built-in state management easier to use.

[![pub package](https://img.shields.io/pub/v/ease_state_helper.svg)](https://pub.dev/packages/ease_state_helper)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.22+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-blue.svg)](https://dart.dev)
[![codecov](https://codecov.io/github/y3l1n4ung/ease/graph/badge.svg?token=EZDDCOCOAT)](https://codecov.io/github/y3l1n4ung/ease)
[![Discord](https://img.shields.io/badge/Discord-Join%20Chat-5865F2?logo=discord&logoColor=white)](https://discord.gg/8NcC7cn3)

---

## Motivation

Flutter's `InheritedWidget` and `InheritedModel` are powerful but boilerplate-heavy. **Ease** provides a modern, Riverpod-like Developer Experience (DX) directly on top of these native primitives.

It aims to be the "Standard Library" extension for Flutter state management—zero extra dependencies, native performance, and type safety out of the box.

---

## The Model

If you've used Riverpod or Provider, Ease will feel familiar:

```dart
// context.counterViewModel      => Watch (rebuilds widget)
// context.readCounterViewModel() => Read (no rebuild, for callbacks)
// context.selectCounterViewModel => Select (rebuilds only on specific field change)
```

---

## Table of Contents

- [Motivation](#motivation)
- [Getting Started](#getting-started)
- [Core Concepts](#core-concepts)
- [API Reference](#api-reference)
- [Advanced Usage](#advanced-usage)
- [DevTools Support](#devtools-support)
- [Packages](#packages)
- [Examples](#examples)
- [Community & Support](#community--support)
- [Contributing](#contributing)

---

## Getting Started

### 1. Installation

Add the latest version to your `pubspec.yaml`:

```yaml
dependencies:
  ease_state_helper: ^0.3.0
  ease_annotation: ^0.2.0

dev_dependencies:
  ease_generator: ^0.3.0
  build_runner: ^2.4.0
```

### 2. Create a ViewModel

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

### 3. Generate & Register

```bash
dart run build_runner build
```

```dart
void main() {
  runApp(
    EaseScope(
      providers: [(child) => CounterViewModelProvider(child: child)],
      child: const MyApp(),
    ),
  );
}
```

### 4. Use

```dart
Widget build(BuildContext context) {
  final counter = context.counterViewModel;
  return Text('${counter.state}');
}
```

---

## Core Concepts

### StateNotifier\<T\>

Base class for all ViewModels. Extends `ChangeNotifier` with a typed `state` property.

```dart
class CartViewModel extends StateNotifier<CartState> {
  CartViewModel() : super(const CartState());

  // Direct assignment - auto-notifies
  void clear() => state = const CartState();

  // Named action - better DevTools visibility
  void addItem(Product product) {
    setState(
      state.copyWith(items: [...state.items, product]),
      action: 'addItem',
    );
  }

  // Functional update
  void toggleLoading() {
    update((current) => current.copyWith(isLoading: !current.isLoading));
  }
}
```

### Provider Nesting

Use `EaseScope` to nest multiple providers:

```dart
void main() {
  runApp(
    EaseScope(
      providers: [
        (child) => CounterViewModelProvider(child: child),
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
      child: CartViewModelProvider(
        child: const MyApp(),
      ),
    ),
  );
}
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

### Context-Safe Listeners (Side Effects)

Use `listenOnYourViewModel` for context-aware side effects (snackbars, navigation). It automatically handles unmounting and cleanup.

```dart
@override
void initState() {
  super.initState();
  context.listenOnCartViewModel((prev, next) {
    if (next.error != null && prev.error != next.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(next.error!)),
      );
    }
  });
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
  runApp(
    EaseScope(
      providers: [
        (child) => CounterViewModelProvider(child: child),
      ],
      child: const MyApp(),
    ),
  );
}
```

---

## DevTools Support

Debug your Ease states in Flutter DevTools.

### Setup (Coming Soon to pub.dev)

Currently, you can use the DevTools extension by adding it as a git dependency:

```yaml
dev_dependencies:
  ease_devtools_extension:
    git:
      url: https://github.com/y3l1n4ung/ease.git
      path: packages/ease_devtools_extension
```

```dart
void main() {
  initializeEaseDevTool(); // Enable DevTools integration
  runApp(
    EaseScope(
      providers: [
        (child) => CounterViewModelProvider(child: child),
      ],
      child: const MyApp(),
    ),
  );
}
```

### Features

- **State Inspector** - View all registered states and current values
- **History Timeline** - Track state changes with timestamps
- **Action Tracking** - See what triggered each state change
- **Filter Support** - Filter history by state type

---

## Packages

| Package | Description | Status |
|---------|-------------|---------|
| [ease_state_helper](packages/ease_state_helper) | Core runtime library | [![pub](https://img.shields.io/pub/v/ease_state_helper.svg?label=0.3.0)](https://pub.dev/packages/ease_state_helper) |
| [ease_annotation](packages/ease_annotation) | `@Ease()` annotation | [![pub](https://img.shields.io/pub/v/ease_annotation.svg?label=0.2.0)](https://pub.dev/packages/ease_annotation) |
| [ease_generator](packages/ease_generator) | Code generator | [![pub](https://img.shields.io/pub/v/ease_generator.svg?label=0.3.0)](https://pub.dev/packages/ease_generator) |
| [ease_devtools_extension](packages/ease_devtools_extension) | DevTools integration | ⏳ Coming Soon |

---

## Project Structure

Ease is maintained as a monorepo using [Melos](https://melos.invertase.dev/).

| Path | Package | Description |
|------|---------|-------------|
| `packages/ease_state_helper` | [ease_state_helper](packages/ease_state_helper) | Core runtime library. |
| `packages/ease_annotation` | [ease_annotation](packages/ease_annotation) | Annotations for code generation. |
| `packages/ease_generator` | [ease_generator](packages/ease_generator) | `build_runner` based code generator. |
| `packages/ease_devtools_extension` | [ease_devtools_extension](packages/ease_devtools_extension) | Flutter DevTools extension. |
| `apps/example` | - | General examples and integration tests. |
| `apps/shopping_app` | - | Real-world example application. |

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

## Community & Support

- **Need help?** Check out our [Support Guide](SUPPORT.md).
- **Found a bug?** [Open an issue](https://github.com/y3l1n4ung/ease/issues/new?template=bug_report.md).
- **Want to chat?** Join our [Discord](https://discord.gg/8NcC7cn3).
- **Code of Conduct**: Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

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
