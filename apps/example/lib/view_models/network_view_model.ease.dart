// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'network_view_model.dart';

// **************************************************************************
// EaseGenerator
// **************************************************************************

// ============================================
// Generated for NetworkViewModel
// ============================================

/// Provider widget that creates and manages NetworkViewModel.
///
/// Uses InheritedNotifier for optimal performance - only widgets
/// that call context.networkViewModel will rebuild on state changes.
class NetworkViewModelProvider extends StatefulWidget {
  final Widget child;

  const NetworkViewModelProvider({super.key, required this.child});

  @override
  State<NetworkViewModelProvider> createState() =>
      _NetworkViewModelProviderState();
}

class _NetworkViewModelProviderState extends State<NetworkViewModelProvider> {
  late final NetworkViewModel _notifier = NetworkViewModel();

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _NetworkViewModelInherited(
      notifier: _notifier,
      child: widget.child,
    );
  }
}

/// InheritedNotifier that efficiently notifies dependents when state changes.
///
/// This automatically listens to the notifier and only rebuilds widgets
/// that have registered a dependency via dependOnInheritedWidgetOfExactType.
class _NetworkViewModelInherited extends InheritedNotifier<NetworkViewModel> {
  const _NetworkViewModelInherited({
    required NetworkViewModel notifier,
    required super.child,
  }) : super(notifier: notifier);
}

extension NetworkViewModelContext on BuildContext {
  /// Gets NetworkViewModel and subscribes to changes.
  /// Widget will rebuild when state changes.
  NetworkViewModel get networkViewModel {
    final inherited =
        dependOnInheritedWidgetOfExactType<_NetworkViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No NetworkViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }

  /// Gets NetworkViewModel without subscribing to changes.
  /// Widget will NOT rebuild when state changes.
  /// Use for callbacks and one-time reads.
  NetworkViewModel readNetworkViewModel() {
    final inherited =
        getInheritedWidgetOfExactType<_NetworkViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No NetworkViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }
}
