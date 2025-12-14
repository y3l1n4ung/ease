# Ease

A simple, performant Flutter state management library using InheritedWidget + code generation.

**Author:** Ye Lin Aung

## Features

- Simple API with `context.myState` getter
- Optimal performance using `InheritedNotifier`
- Zero boilerplate with code generation
- Type-safe state access
- Automatic provider nesting
- Watch (`context.myState`) and read (`context.readMyState()`) patterns

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  ease:
    path: ../ease  # or from pub.dev when published

dev_dependencies:
  ease_generator:
    path: ../ease_generator  # or from pub.dev when published
  build_runner: ^2.4.0
```

## Quick Start

### 1. Create a State Class

```dart
import 'package:ease/ease.dart';

part 'counter_state.g.dart';

@ease()
class CounterState extends StateNotifier<int> {
  CounterState() : super(0);

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

void main() => runApp(const Ease(child: MyApp()));
```

### 4. Use the State

```dart
// Watch - rebuilds when state changes
final count = context.counterState.state;

// Read - doesn't rebuild, use in callbacks
onPressed: () => context.readCounterState().increment(),
```

## API

### StateNotifier

Base class for all state objects:

```dart
@ease()
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
```

## Examples

The `example/` directory contains comprehensive examples:

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

## Architecture

```
ease/                    # Core library
  lib/
    src/
      state_notifier.dart  # Base StateNotifier class
    ease.dart              # Public API

ease_annotation/         # @ease annotation
  lib/
    ease_annotation.dart

ease_generator/          # Code generator
  lib/
    src/
      ease_generator.dart     # Per-file generator
      aggregator_builder.dart # Aggregates all states
    builder.dart

example/                 # Example app
  lib/
    states/              # State classes
    pages/               # UI pages
    ease.g.dart          # Generated root widget
```

## How It Works

1. **Annotation**: `@ease()` marks a class for code generation
2. **Per-file generation**: Creates `Provider`, `InheritedNotifier`, and context extensions
3. **Aggregation**: Combines all providers into single `Ease` widget
4. **Runtime**: Uses Flutter's `InheritedNotifier` for efficient rebuilds

### Generated Code

For a `CounterState` class, generates:

- `CounterStateProvider` - StatefulWidget that creates the notifier
- `_CounterStateInherited` - InheritedNotifier for efficient updates
- `CounterStateContext` extension - `context.counterState` and `context.readCounterState()`

## Performance

- Uses `InheritedNotifier` which only rebuilds widgets that actually depend on the state
- State comparison uses `!=` - implement proper `==` for complex objects
- Consider using immutable state classes with `copyWith()`

## Best Practices

### Do

```dart
// Use immutable state with copyWith
state = state.copyWith(count: state.count + 1);

// Use read() in callbacks
onPressed: () => context.readCounterState().increment(),

// Check hasListeners before async state updates
Future<void> fetchData() async {
  final data = await api.fetch();
  if (!hasListeners) return;  // Check if disposed
  state = state.copyWith(data: data);
}
```

### Don't

```dart
// Don't mutate state directly
state.items.add(item);  // Won't trigger rebuild!

// Don't use watch in callbacks
onPressed: () => context.counterState.increment(),  // Causes rebuild
```

## Roadmap

### Planned Features

- [ ] **Selector pattern** - Subscribe to only part of state for better performance
  ```dart
  // Only rebuilds when items.length changes
  final count = context.select((CartState s) => s.state.items.length);
  ```

- [ ] **AsyncValue** - Built-in async state handling
  ```dart
  state.when(
    loading: () => CircularProgressIndicator(),
    error: (e) => Text('Error: $e'),
    data: (users) => UserList(users),
  );
  ```

- [ ] **DevTools integration** - State inspection in Flutter DevTools

- [ ] **Middleware support** - Logging, analytics hooks
  ```dart
  Ease(
    middleware: [LoggingMiddleware(), AnalyticsMiddleware()],
    child: MyApp(),
  )
  ```

- [ ] **State scoping** - Override state for subtree (like Provider's overrides)
  ```dart
  EaseScope(
    overrides: [counterState.overrideWith(MockCounterState())],
    child: TestWidget(),
  )
  ```

- [ ] **Lazy initialization** - Create state only when first accessed

## License

MIT License - see LICENSE file for details.
