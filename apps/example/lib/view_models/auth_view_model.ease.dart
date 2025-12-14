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
