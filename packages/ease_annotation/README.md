# Ease Annotation

Annotation package for [Ease State Helper](https://github.com/y3l1n4ung/ease).

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

@ease()
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
