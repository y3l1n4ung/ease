# Ease Annotation

[![pub package](https://img.shields.io/pub/v/ease_annotation.svg)](https://pub.dev/packages/ease_annotation)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Annotation package for [Ease State Helper](https://pub.dev/packages/ease_state_helper).

## Installation

```yaml
dependencies:
  ease_annotation: ^0.1.0
```

## Usage

```dart
import 'package:ease_annotation/ease_annotation.dart';
import 'package:ease_state_helper/ease_state_helper.dart';

part 'counter_view_model.ease.dart';

@Ease()
class CounterViewModel extends StateNotifier<int> {
  CounterViewModel() : super(0);

  void increment() => state++;
}
```

Run code generation:

```bash
dart run build_runner build
```

## License

MIT
