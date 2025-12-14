// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'form_view_model.dart';

// **************************************************************************
// EaseGenerator
// **************************************************************************

// ============================================
// Generated for RegistrationFormViewModel
// ============================================

/// Provider widget that creates and manages RegistrationFormViewModel.
///
/// Uses InheritedNotifier for optimal performance - only widgets
/// that call context.registrationFormViewModel will rebuild on state changes.
class RegistrationFormViewModelProvider extends StatefulWidget {
  final Widget child;

  const RegistrationFormViewModelProvider({super.key, required this.child});

  @override
  State<RegistrationFormViewModelProvider> createState() =>
      _RegistrationFormViewModelProviderState();
}

class _RegistrationFormViewModelProviderState
    extends State<RegistrationFormViewModelProvider> {
  late final RegistrationFormViewModel _notifier = RegistrationFormViewModel();

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _RegistrationFormViewModelInherited(
      notifier: _notifier,
      child: widget.child,
    );
  }
}

/// InheritedNotifier that efficiently notifies dependents when state changes.
///
/// This automatically listens to the notifier and only rebuilds widgets
/// that have registered a dependency via dependOnInheritedWidgetOfExactType.
class _RegistrationFormViewModelInherited
    extends InheritedNotifier<RegistrationFormViewModel> {
  const _RegistrationFormViewModelInherited({
    required RegistrationFormViewModel notifier,
    required super.child,
  }) : super(notifier: notifier);
}

extension RegistrationFormViewModelContext on BuildContext {
  /// Gets RegistrationFormViewModel and subscribes to changes.
  /// Widget will rebuild when state changes.
  RegistrationFormViewModel get registrationFormViewModel {
    final inherited = dependOnInheritedWidgetOfExactType<
        _RegistrationFormViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No RegistrationFormViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }

  /// Gets RegistrationFormViewModel without subscribing to changes.
  /// Widget will NOT rebuild when state changes.
  /// Use for callbacks and one-time reads.
  RegistrationFormViewModel readRegistrationFormViewModel() {
    final inherited =
        getInheritedWidgetOfExactType<_RegistrationFormViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No RegistrationFormViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }
}
