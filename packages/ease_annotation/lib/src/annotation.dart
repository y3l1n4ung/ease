/// Marks a StateNotifier subclass for code generation.
///
/// When applied to a class extending StateNotifier, the generator will create:
/// - A provider widget with lifecycle management
/// - An InheritedWidget for dependency injection
/// - Context extensions for accessing the state
///
/// Example:
/// ```dart
/// @ease
/// class CounterState extends StateNotifier<int> {
///   CounterState() : super(0);
///   void increment() => state++;
/// }
/// ```
///
/// After running `dart run build_runner build`, you can use:
/// ```dart
/// // In main.dart
/// void main() => runApp(Ease(child: MyApp()));
///
/// // In any widget
/// final counter = context.counterState;  // typed getter
/// final counter = context.get<CounterState>();  // generic getter
/// ```
class ease {
  const ease();
}
