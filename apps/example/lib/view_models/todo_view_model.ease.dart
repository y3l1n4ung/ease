// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'todo_view_model.dart';

// **************************************************************************
// EaseGenerator
// **************************************************************************

// ============================================
// Generated for TodoViewModel
// ============================================

/// Provider widget that creates and manages TodoViewModel.
///
/// Uses InheritedNotifier for optimal performance - only widgets
/// that call context.todoViewModel will rebuild on state changes.
class TodoViewModelProvider extends StatefulWidget {
  final Widget child;

  const TodoViewModelProvider({super.key, required this.child});

  @override
  State<TodoViewModelProvider> createState() => _TodoViewModelProviderState();
}

class _TodoViewModelProviderState extends State<TodoViewModelProvider> {
  late final TodoViewModel _notifier = TodoViewModel();

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _TodoViewModelInherited(
      notifier: _notifier,
      child: widget.child,
    );
  }
}

/// InheritedNotifier that efficiently notifies dependents when state changes.
///
/// This automatically listens to the notifier and only rebuilds widgets
/// that have registered a dependency via dependOnInheritedWidgetOfExactType.
class _TodoViewModelInherited extends InheritedNotifier<TodoViewModel> {
  const _TodoViewModelInherited({
    required TodoViewModel notifier,
    required super.child,
  }) : super(notifier: notifier);
}

extension TodoViewModelContext on BuildContext {
  /// Gets TodoViewModel and subscribes to changes.
  /// Widget will rebuild when state changes.
  TodoViewModel get todoViewModel {
    final inherited =
        dependOnInheritedWidgetOfExactType<_TodoViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No TodoViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }

  /// Gets TodoViewModel without subscribing to changes.
  /// Widget will NOT rebuild when state changes.
  /// Use for callbacks and one-time reads.
  TodoViewModel readTodoViewModel() {
    final inherited = getInheritedWidgetOfExactType<_TodoViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No TodoViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }
}
