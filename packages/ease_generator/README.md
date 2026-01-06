# Ease Generator

[![pub package](https://img.shields.io/pub/v/ease_generator.svg)](https://pub.dev/packages/ease_generator)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Code generator for [Ease State Helper](https://pub.dev/packages/ease_state_helper).

## Installation

```yaml
dependencies:
  ease_state_helper: ^0.1.0
  ease_annotation: ^0.1.0

dev_dependencies:
  ease_generator: ^0.1.0
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

## Generated Files

- `*.ease.dart` - Provider and context extensions per ViewModel
- `ease.g.dart` - Aggregated `$easeProviders` list

## License

MIT
