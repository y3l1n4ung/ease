import 'package:flutter/widgets.dart';

/// Function type for provider builders.
///
/// Used to wrap child widgets with provider widgets.
typedef ProviderBuilder = Widget Function(Widget child);

/// Root widget that provides all registered states to descendants.
///
/// This widget supports both code-generated and manual provider registration.
///
/// ## With Code Generation
///
/// When using `@ease` annotation and code generation, the `ease.g.dart` file
/// generates a subclass with pre-registered providers:
///
/// ```dart
/// // Generated ease.g.dart provides providers automatically
/// void main() => runApp(EaseScope(child: MyApp()));
/// ```
///
/// ## Without Code Generation (manual registration)
///
/// For manual provider registration without code generation:
///
/// ```dart
/// void main() => runApp(
///   EaseScope(
///     providers: [
///       (child) => CartViewModelProvider(child: child),
///       (child) => AuthViewModelProvider(child: child),
///     ],
///     child: MyApp(),
///   ),
/// );
/// ```
///
/// The VS Code extension can scaffold the Provider files for you.
///
/// Note: Local providers (`@ease(local: true)`) are not included here.
/// They must be manually placed in your widget tree.
class EaseScope extends StatelessWidget {
  /// The child widget to wrap with all providers.
  final Widget child;

  /// List of provider builder functions.
  ///
  /// When using code generation, this is populated automatically.
  /// For manual registration, pass your providers here.
  final List<ProviderBuilder> providers;

  /// Creates an EaseScope root widget.
  ///
  /// [providers] - List of provider builder functions. Empty by default
  /// for code-generated usage where providers are added to `_providers`.
  /// [child] - The widget tree to wrap with providers.
  const EaseScope({
    super.key,
    required this.child,
    this.providers = const [],
  });

  @override
  Widget build(BuildContext context) {
    return providers.fold(child, (child, provider) => provider(child));
  }
}
