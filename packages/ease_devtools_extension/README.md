# Ease DevTools Extension

[![pub package](https://img.shields.io/pub/v/ease_devtools_extension.svg)](https://pub.dev/packages/ease_devtools_extension)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Flutter DevTools extension for debugging [Ease State Helper](https://pub.dev/packages/ease_state_helper) state management.

## Features

- **State Inspector** - View all registered states and their current values
- **History Timeline** - Track state changes with timestamps
- **Action Tracking** - See named actions that triggered state changes
- **Filter Support** - Filter history by state type

## Installation

> **Note**: This package is not yet released on pub.dev. You can use it via git:

```yaml
dev_dependencies:
  ease_devtools_extension:
    git:
      url: https://github.com/y3l1n4ung/ease.git
      path: packages/ease_devtools_extension
```

## Setup

1. Call `initializeEaseDevTool()` before `runApp()`:

```dart
import 'package:ease_state_helper/ease_state_helper.dart';

void main() {
  initializeEaseDevTool();
  runApp(const EaseScope(child: MyApp()));
}
```

2. Run your app in debug mode
3. Open Flutter DevTools
4. Look for the "Ease" tab

## Usage

### Viewing States

The extension displays all `@Ease()` annotated states currently in the widget tree. Each state shows:

- Class name
- Current state value (JSON formatted)
- Number of state changes

### Tracking History

Every state change is recorded with:

- Timestamp
- Action name (if provided via `setState(value, action: 'name')`)
- Previous and new values

### Filtering

Use the filter dropdown to show history for specific state types only.

## License

MIT
