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
/// `Ease` widget. Use for scoped state that should be manually placed
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
/// // In main.dart - automatically included in Ease widget
/// void main() => runApp(Ease(child: MyApp()));
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
class ease {
  /// If true, the provider will NOT be registered in the global Ease widget.
  /// Use for scoped state that should be manually placed in the widget tree.
  final bool local;

  const ease({this.local = false});
}
