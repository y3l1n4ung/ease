# Ease

A simple, performant Flutter state management library using InheritedWidget + code generation.

[![Pub Version](https://img.shields.io/pub/v/ease)](https://pub.dev/packages/ease)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Features

- Simple API with `context.myState` getter
- Optimal performance using `InheritedNotifier`
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
import 'package:ease/ease.dart';

part 'counter_view_model.ease.dart';

@ease
class CounterViewModel extends StateNotifier<int> {
  CounterViewModel() : super(0);

  void increment() => state = state + 1;
  void decrement() => state = state - 1;
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
@ease
class MyState extends StateNotifier<MyStateData> {
  MyState() : super(MyStateData.initial());

  // Update state - automatically notifies listeners
  void doSomething() {
    state = state.copyWith(/* ... */);
  }

  // Use update() for complex transformations
  void transform() {
    update((current) => current.copyWith(/* ... */));
  }

  // Named actions for DevTools
  void increment() {
    setState(state + 1, action: 'increment');
  }
}
```

### Context Extensions

Generated for each `@ease` class:

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

## Development Setup

This project uses [Melos](https://melos.invertase.dev/) for monorepo management.

```bash
# Install melos
dart pub global activate melos

# Bootstrap the project
melos bootstrap

# Run code generation
melos run generate

# Run tests
melos run test:all

# Analyze code
melos run analyze

# Format code
melos run format
```

## Project Structure

```
packages/
├── ease/                  # Core library
│   └── lib/src/
│       ├── state_notifier.dart   # Base StateNotifier class
│       └── devtools.dart         # DevTools integration
│
├── ease_annotation/       # @ease annotation
│
├── ease_generator/        # Code generator
│   └── lib/src/
│       ├── ease_generator.dart      # Per-file generator
│       └── aggregator_builder.dart  # Aggregates into ease.g.dart
│
└── ease_devtools_extension/  # DevTools UI

apps/
└── example/               # Example app with demos
```

## Examples

The `apps/example/` directory contains comprehensive examples:

| Example | Description |
|---------|-------------|
| Counter | Basic increment/decrement |
| Todo List | CRUD operations with lists |
| Auth | Login/logout with persistence |
| Theme | Light/dark mode switching |
| Form | Form validation with real-time feedback |
| Cart | Shopping cart with computed totals |
| Search | Debounced search with async |
| Pagination | Infinite scroll with load more |
| Network | Real API calls with caching |

Run the example:

```bash
cd apps/example
flutter run
```

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) first.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Author

**Ye Lin Aung** - [@b14ckc0d3](https://github.com/b14ckc0d3)
