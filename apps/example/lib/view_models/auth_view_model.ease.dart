// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'auth_view_model.dart';

// **************************************************************************
// EaseGenerator
// **************************************************************************

// ============================================
// Generated for AuthViewModel
// ============================================

/// Provider widget that creates and manages AuthViewModel.
///
/// Uses InheritedNotifier for optimal performance - only widgets
/// that call context.authViewModel will rebuild on state changes.
class AuthViewModelProvider extends StatefulWidget {
  final Widget child;

  const AuthViewModelProvider({super.key, required this.child});

  @override
  State<AuthViewModelProvider> createState() => _AuthViewModelProviderState();
}

class _AuthViewModelProviderState extends State<AuthViewModelProvider> {
  late final AuthViewModel _notifier = AuthViewModel();

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AuthViewModelInherited(
      notifier: _notifier,
      child: widget.child,
    );
  }
}

/// InheritedNotifier that efficiently notifies dependents when state changes.
///
/// This automatically listens to the notifier and only rebuilds widgets
/// that have registered a dependency via dependOnInheritedWidgetOfExactType.
class _AuthViewModelInherited extends InheritedNotifier<AuthViewModel> {
  const _AuthViewModelInherited({
    required AuthViewModel notifier,
    required super.child,
  }) : super(notifier: notifier);
}

extension AuthViewModelContext on BuildContext {
  /// Gets AuthViewModel and subscribes to changes.
  /// Widget will rebuild when state changes.
  AuthViewModel get authViewModel {
    final inherited =
        dependOnInheritedWidgetOfExactType<_AuthViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No AuthViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }

  /// Gets AuthViewModel without subscribing to changes.
  /// Widget will NOT rebuild when state changes.
  /// Use for callbacks and one-time reads.
  AuthViewModel readAuthViewModel() {
    final inherited = getInheritedWidgetOfExactType<_AuthViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No AuthViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }
}

/// Selector widget for AuthViewModel that only rebuilds when selected value changes.
///
/// Example:
/// ```dart
/// AuthViewModelSelector<int>(
///   selector: (state) => state.itemCount,
///   builder: (context, count) => Text('$count'),
/// )
/// ```
class AuthViewModelSelector<T> extends StatefulWidget {
  /// Function that selects the portion of state to watch.
  final T Function(AuthStatus state) selector;

  /// Builder function called with the selected value.
  final Widget Function(BuildContext context, T value) builder;

  /// Optional equality function to compare selected values.
  /// If not provided, uses `==` operator.
  final bool Function(T previous, T next)? equals;

  const AuthViewModelSelector({
    super.key,
    required this.selector,
    required this.builder,
    this.equals,
  });

  @override
  State<AuthViewModelSelector<T>> createState() =>
      _AuthViewModelSelectorState<T>();
}

class _AuthViewModelSelectorState<T> extends State<AuthViewModelSelector<T>> {
  AuthViewModel? _notifier;
  late T _selectedValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final notifier = context.readAuthViewModel();
    if (_notifier != notifier) {
      _notifier?.removeListener(_onStateChange);
      _notifier = notifier;
      _selectedValue = widget.selector(notifier.state);
      notifier.addListener(_onStateChange);
    }
  }

  @override
  void dispose() {
    _notifier?.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    final newValue = widget.selector(_notifier!.state);
    final areEqual = widget.equals?.call(_selectedValue, newValue) ??
        _selectedValue == newValue;
    if (!areEqual) {
      setState(() => _selectedValue = newValue);
    }
  }

  @override
  void didUpdateWidget(covariant AuthViewModelSelector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recompute selected value if selector changed
    if (_notifier != null) {
      _selectedValue = widget.selector(_notifier!.state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _selectedValue);
  }
}
