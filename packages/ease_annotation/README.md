# Ease Annotation

Annotation package for the Ease state management library.

## Overview

This package provides the `@ease()` annotation used to mark classes for code generation. It is a pure Dart package with no Flutter dependency.

## Installation

This package is typically installed alongside `ease` and `ease_generator`:

```yaml
dependencies:
  ease_annotation:
    path: ../ease_annotation
```

## Usage

```dart
import 'package:ease_annotation/ease_annotation.dart';

@ease()
class CounterViewModel extends StateNotifier<int> {
  CounterViewModel() : super(0);
}
```

The annotation triggers code generation via `ease_generator` to create:

- Provider widget for lifecycle management
- InheritedNotifier for efficient state propagation
- BuildContext extensions for easy access

## API

### `@ease()`

A const annotation that marks a class for code generation.

```dart
const ease();
```

The annotated class must extend `StateNotifier<T>` from the `ease` package.

## License

MIT
