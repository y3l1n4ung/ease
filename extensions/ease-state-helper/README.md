# Ease State Helper

VS Code extension for [Ease](https://github.com/y3l1n4ung/ease) Flutter state management.

## Features

### Commands

- **Ease: New ViewModel** - Creates a new ViewModel with its `.ease.dart` file
- **Ease: New Local ViewModel** - Creates a scoped ViewModel for forms, dialogs, etc.

Right-click on any folder in the Explorer to access these commands.

### Snippets

| Prefix | Description |
|--------|-------------|
| `easevm` | Create an Ease ViewModel class |
| `easewatch` | Watch a ViewModel (subscribes to changes) |
| `easeread` | Read a ViewModel without subscribing |
| `easeselect` | Select a specific value from ViewModel state |
| `easeprovider` | Add a provider to easeProviders list |

## Usage

### Creating a New ViewModel

1. Right-click on a folder in the Explorer
2. Select **Ease: New ViewModel**
3. Enter the ViewModel name (e.g., "Counter")
4. Enter the state type (e.g., "int" or "CounterState")

This creates two files:
- `counter_view_model.dart` - The ViewModel class
- `counter_view_model.ease.dart` - Provider, InheritedModel, and context extensions

### Registering the Provider

Add your provider to the `Ease` widget in `main.dart`:

```dart
import 'package:ease/ease.dart';
import 'counter_view_model.dart';

void main() {
  runApp(
    Ease(
      providers: [
        (child) => CounterViewModelProvider(child: child),
        // ... other providers
      ],
      child: const MyApp(),
    ),
  );
}
```

### Using the ViewModel

```dart
// Watch (rebuilds on state change)
final counter = context.counterViewModel;

// Read (no subscription, for callbacks)
context.readCounterViewModel().increment();

// Select (partial subscription)
final count = context.selectCounterViewModel((s) => s);
```

## Requirements

- VS Code 1.85.0 or higher
- Flutter/Dart project using Ease State ( Flutter State Management Helper)
