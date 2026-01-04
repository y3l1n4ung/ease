# Ease State Helper

A simple Flutter state management helper that makes using Flutter's internal state management easier.

## Installation

```yaml
dependencies:
  ease_state_helper: ^0.1.0
```

For code generation approach, also add:

```yaml
dependencies:
  ease_annotation: ^0.1.0

dev_dependencies:
  ease_generator: ^0.1.0
  build_runner: ^2.4.0
```

## Usage

### 1. Create a ViewModel

**With VS Code Extension:**

Right-click folder → "Ease: New ViewModel" → Enter name and state type.

**With Code Generation:**

```dart
import 'package:ease_annotation/ease_annotation.dart';
import 'package:ease_state_helper/ease_state_helper.dart';

part 'counter_view_model.ease.dart';

@ease()
class CounterViewModel extends StateNotifier<int> {
  CounterViewModel() : super(0);

  void increment() => state++;
  void decrement() => state--;
}
```

Run: `dart run build_runner build`

### 2. Register Providers

```dart
import 'package:ease_state_helper/ease_state_helper.dart';
import 'counter_view_model.dart';

void main() => runApp(
  Ease(
    providers: [
      (child) => CounterViewModelProvider(child: child),
    ],
    child: MyApp(),
  ),
);
```

### 3. Use in widgets

```dart
// Watch - rebuilds when state changes
final counter = context.counterViewModel;
Text('Count: ${counter.state}');

// Read - doesn't rebuild (use for callbacks)
onPressed: () => context.readCounterViewModel().increment(),

// Select - granular rebuilds
final count = context.selectCounterViewModel((s) => s);
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

### Context Extensions

For each ViewModel, the .ease.dart file provides:

- `context.yourViewModel` - Watch (subscribes to all state changes)
- `context.readYourViewModel()` - Read (no subscription, for callbacks)
- `context.selectYourViewModel((s) => s.field)` - Select (granular rebuilds)

## License

MIT
