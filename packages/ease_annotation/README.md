# Ease Annotation

[![pub package](https://img.shields.io/pub/v/ease_annotation.svg)](https://pub.dev/packages/ease_annotation)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Annotation package for [Ease State Helper](https://pub.dev/packages/ease_state_helper).

---

## Ease Ecosystem

This package is part of the **Ease State Helper** ecosystem. Ease is divided into multiple packages to keep your production dependencies as light as possible:

| Package | Role | Dependency Type |
|---------|------|-----------------|
| [ease_state_helper](../ease_state_helper) | Core runtime logic | `dependencies` |
| **ease_annotation** | Metadata for codegen | `dependencies` |
| [ease_generator](../ease_generator) | Code generator | `dev_dependencies` |
| [ease_devtools_extension](../ease_devtools_extension) | Debugging tools | `dev_dependencies` |

---

## Features

- **@Ease()** - Mark classes for code generation.
- **Local Scoping** - Use `@Ease(local: true)` for scoped providers.
- **Lightweight** - Zero dependencies other than `meta`.

## Why Ease Annotation?

This package provides the metadata needed by `ease_generator` to create type-safe `BuildContext` extensions and `InheritedModel` providers. By separating annotations from the generator and core library, we keep your app's runtime dependencies minimal.

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
