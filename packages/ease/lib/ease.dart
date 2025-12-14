/// Simple Flutter state management with InheritedWidget + code generation.
///
/// Usage:
/// ```dart
/// // 1. Define state
/// @ease
/// class CounterState extends StateNotifier<int> {
///   CounterState() : super(0);
///   void increment() => state++;
/// }
///
/// // 2. Run app
/// void main() => runApp(Ease(child: MyApp()));
///
/// // 3. Use
/// final counter = context.get<CounterState>();
/// Text('${counter.state}');
/// ```
library ease;

export 'package:ease_annotation/ease_annotation.dart';
export 'src/state_notifier.dart';
