# Ease DevTools Extension

Flutter DevTools extension for debugging Ease state management.

## Features

- **State Inspector** - View all registered states and their current values
- **History Timeline** - Track state changes with timestamps
- **Action Tracking** - See named actions that triggered state changes
- **Filter Support** - Filter history by state type

## Installation

Add to your `pubspec.yaml` dev dependencies:

```yaml
dev_dependencies:
  ease_devtools_extension: ^1.0.0
```

## Setup

1. Call `initializeEase()` before `runApp()`:

```dart
import 'package:ease/ease.dart';

void main() {
  initializeEase();
  runApp(const Ease(child: MyApp()));
}
```

2. Run your app in debug mode
3. Open Flutter DevTools
4. Look for the "Ease" tab

## Usage

### Viewing States

The extension displays all `@ease()` annotated states currently in the widget tree. Each state shows:

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
