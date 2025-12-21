# Ease

Simple Flutter state management with InheritedWidget + code generation.

## Features

- **Zero boilerplate** - Just extend `StateNotifier<T>` and add `@ease()`
- **Optimal performance** - Uses `InheritedModel` for selective rebuilds
- **Type-safe** - Full type inference with generated context extensions
- **Simple API** - Watch with getters, read with methods

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  ease: ^1.0.0

dev_dependencies:
  ease_generator: ^1.0.0
  build_runner: ^2.4.0
```

## Usage

### 1. Create a StateNotifier

```dart
import 'package:ease/ease.dart';

part 'counter_view_model.ease.dart';

@ease()
class CounterViewModel extends StateNotifier<int> {
  CounterViewModel() : super(0);

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}
```

### 2. Run code generation

```bash
dart run build_runner build
```

### 3. Wrap your app

```dart
import 'ease.g.dart';

void main() => runApp(Ease(child: MyApp()));
```

### 4. Use in widgets

```dart
// Watch - rebuilds when state changes
final counter = context.counterViewModel;
Text('Count: ${counter.state}');

// Read - doesn't rebuild (use for callbacks)
ElevatedButton(
  onPressed: () => context.readCounterViewModel().increment(),
  child: Text('Increment'),
);
```

## API

### StateNotifier<T>

Base class for state management:

```dart
class StateNotifier<T> extends ChangeNotifier {
  T get state;           // Current state
  set state(T value);    // Update state (auto-notifies if changed)
  void update(T Function(T) updater);  // Update based on current state
}
```

### Generated Extensions

For each `@ease()` class, the generator creates:

- `context.yourViewModel` - Watch (subscribes to all state changes)
- `context.readYourViewModel()` - Read (no subscription, use for callbacks)
- `context.selectYourViewModel((s) => s.field)` - Select specific state (granular rebuilds)

## Selector Pattern

Use `context.select*` when you only need part of the state. This prevents unnecessary rebuilds when other parts of the state change:

```dart
// Problem: This rebuilds whenever ANY part of CartStatus changes
final cart = context.cartViewModel;
Text('${cart.state.itemCount} items');  // Rebuilds even if only isLoading changed

// Solution: Use select to only rebuild when itemCount changes
final count = context.selectCartViewModel((s) => s.itemCount);
Text('$count items');
```

### Custom Equality

For complex types like lists, provide a custom equality function:

```dart
final items = context.selectCartViewModel(
  (s) => s.items,
  equals: (prev, next) => listEquals(prev, next),
);
ItemList(items: items);
```

## Complex State

For complex state, use immutable classes with `copyWith`:

```dart
class CartStatus {
  final List<Item> items;
  final bool isLoading;

  const CartStatus({this.items = const [], this.isLoading = false});

  CartStatus copyWith({List<Item>? items, bool? isLoading}) {
    return CartStatus(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@ease()
class CartViewModel extends StateNotifier<CartStatus> {
  CartViewModel() : super(const CartStatus());

  void addItem(Item item) {
    state = state.copyWith(items: [...state.items, item]);
  }
}
```

## License

MIT
