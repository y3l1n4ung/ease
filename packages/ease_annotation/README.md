# Ease Annotation

Annotation package for the Ease state management library.

## Overview

This package provides the `@ease()` annotation used to mark classes for code generation. It is a pure Dart package with no Flutter dependency.

## Installation

This package is automatically included when you add `ease` to your dependencies. You typically don't need to add it directly:

```yaml
dependencies:
  ease: ^1.0.0  # includes ease_annotation
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
- InheritedModel for efficient state propagation with selective rebuilds
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
