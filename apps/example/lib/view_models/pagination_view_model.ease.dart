// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'pagination_view_model.dart';

// **************************************************************************
// EaseGenerator
// **************************************************************************

// ============================================
// Generated for PaginationViewModel
// ============================================

/// Provider widget that creates and manages PaginationViewModel.
///
/// Uses InheritedNotifier for optimal performance - only widgets
/// that call context.paginationViewModel will rebuild on state changes.
class PaginationViewModelProvider extends StatefulWidget {
  final Widget child;

  const PaginationViewModelProvider({super.key, required this.child});

  @override
  State<PaginationViewModelProvider> createState() =>
      _PaginationViewModelProviderState();
}

class _PaginationViewModelProviderState
    extends State<PaginationViewModelProvider> {
  late final PaginationViewModel _notifier = PaginationViewModel();

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PaginationViewModelInherited(
      notifier: _notifier,
      child: widget.child,
    );
  }
}

/// InheritedNotifier that efficiently notifies dependents when state changes.
///
/// This automatically listens to the notifier and only rebuilds widgets
/// that have registered a dependency via dependOnInheritedWidgetOfExactType.
class _PaginationViewModelInherited
    extends InheritedNotifier<PaginationViewModel> {
  const _PaginationViewModelInherited({
    required PaginationViewModel notifier,
    required super.child,
  }) : super(notifier: notifier);
}

extension PaginationViewModelContext on BuildContext {
  /// Gets PaginationViewModel and subscribes to changes.
  /// Widget will rebuild when state changes.
  PaginationViewModel get paginationViewModel {
    final inherited =
        dependOnInheritedWidgetOfExactType<_PaginationViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No PaginationViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }

  /// Gets PaginationViewModel without subscribing to changes.
  /// Widget will NOT rebuild when state changes.
  /// Use for callbacks and one-time reads.
  PaginationViewModel readPaginationViewModel() {
    final inherited =
        getInheritedWidgetOfExactType<_PaginationViewModelInherited>();
    if (inherited == null || inherited.notifier == null) {
      throw StateError(
        'No PaginationViewModel found in widget tree.\n'
        'Make sure you:\n'
        '1. Wrapped your app with Ease widget: Ease(child: MyApp())\n'
        '2. Ran build_runner: dart run build_runner build\n'
        '3. Imported ease.g.dart in your main file',
      );
    }
    return inherited.notifier!;
  }
}
