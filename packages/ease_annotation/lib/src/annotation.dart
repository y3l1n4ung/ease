/// Marks a StateNotifier subclass for code generation.
///
/// When applied to a class extending StateNotifier, the generator will create:
/// - A provider widget with lifecycle management
/// - An InheritedWidget for dependency injection
/// - Context extensions for accessing the state
///
/// ## Parameters
///
/// [local] - If true, the provider will NOT be registered in the global
/// `EaseScope` widget. Use for scoped state that should be manually placed
/// in the widget tree. Defaults to false.
///
/// ## Example - Global Provider (default)
///
/// ```dart
/// @ease()
/// class CounterState extends StateNotifier<int> {
///   CounterState() : super(0);
///   void increment() => state++;
/// }
/// ```
///
/// After running `dart run build_runner build`, you can use:
/// ```dart
/// // In main.dart - automatically included in EaseScope widget
/// void main() => runApp(EaseScope(child: MyApp()));
///
/// // In any widget
/// final counter = context.counterState;  // typed getter
/// final counter = context.get<CounterState>();  // generic getter
/// ```
///
/// ## Example - Local Provider
///
/// ```dart
/// @ease(local: true)
/// class FormState extends StateNotifier<FormData> {
///   FormState() : super(FormData());
/// }
/// ```
///
/// Local providers must be manually placed in the widget tree:
/// ```dart
/// // In your widget
/// FormStateProvider(
///   child: MyForm(),
/// )
///
/// // Access within the subtree
/// final form = context.formState;
/// ```
class Ease {
  /// If true, the provider will NOT be registered in the global EaseScope widget.
  /// Use for scoped state that should be manually placed in the widget tree.
  final bool local;

  const Ease({this.local = false});
}

/// Annotation for marking StateNotifier classes for code generation.
///
/// Use `@ease` for global providers (default behavior).
/// Use `@Ease(local: true)` for local/scoped providers.
const ease = Ease();
