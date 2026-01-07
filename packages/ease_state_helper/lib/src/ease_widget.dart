import 'package:flutter/widgets.dart';

/// Function type for provider builders.
///
/// Used to wrap child widgets with provider widgets.
typedef ProviderBuilder = Widget Function(Widget child);

/// Root widget that provides all registered states to descendants.
///
/// This widget nests multiple providers together for cleaner code.
///
/// ## Usage
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
/// This is equivalent to manually nesting providers:
///
/// ```dart
/// void main() => runApp(
///   CartViewModelProvider(
///     child: AuthViewModelProvider(
///       child: MyApp(),
///     ),
///   ),
/// );
/// ```
///
/// The VS Code extension can scaffold the Provider files for you.
///
/// Note: Local providers (`@Ease(local: true)`) should be manually
/// placed in the widget tree where they are needed.
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
