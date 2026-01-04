# Ease Generator

Code generator for the Ease state management library.

## Overview

This package provides build_runner generators that create boilerplate code for classes annotated with `@ease()`. It generates:

1. **Provider widgets** - StatefulWidget that manages the notifier lifecycle
2. **InheritedModel** - For efficient state propagation with selective rebuilds
3. **Context extensions** - Type-safe access via `context.yourViewModel`
4. **Ease root widget** - Aggregates all providers for easy app setup

## Installation

Add to your `pubspec.yaml` dev dependencies:

```yaml
dev_dependencies:
  ease_generator: ^1.0.0
  build_runner: ^2.4.0
```

## Usage

### 1. Annotate your classes

```dart
import 'package:ease_state_helper/ease_state_helper.dart';

part 'counter_view_model.ease.dart';

@ease()
class CounterViewModel extends StateNotifier<int> {
  CounterViewModel() : super(0);
  void increment() => state++;
}
```

### 2. Run the generator

```bash
# One-time build
dart run build_runner build

# Watch mode (rebuilds on changes)
dart run build_runner watch
```

### 3. Generated files

For each annotated class, a `.ease.dart` part file is created:

```dart
// counter_view_model.ease.dart
class CounterViewModelProvider extends StatefulWidget { ... }
class _CounterViewModelInherited extends InheritedModel<_CounterViewModelAspect> { ... }
extension CounterViewModelContext on BuildContext { ... }
```

An aggregated `ease.g.dart` file is also created:

```dart
// ease.g.dart
class Ease extends StatelessWidget { ... }  // Wraps all providers
extension EaseContext on BuildContext { ... }  // Generic get<T>() and read<T>()
```

## Architecture

### Two-Phase Generation

1. **Per-file generation** (`EaseGenerator`)
   - Runs on each file with `@ease()` annotations
   - Generates Provider, InheritedModel, and typed extensions

2. **Aggregation** (`AggregatorBuilder`)
   - Runs after all per-file generators complete
   - Scans for generated providers
   - Creates the `Ease` root widget and generic extensions

### Generated Code Patterns

**Watch pattern** (subscribes to changes):
```dart
// Uses dependOnInheritedWidgetOfExactType - causes rebuilds
$className get $getterName { ... }
```

**Read pattern** (no subscription):
```dart
// Uses getInheritedWidgetOfExactType - no rebuilds
$className read$className() { ... }
```

## License

MIT
