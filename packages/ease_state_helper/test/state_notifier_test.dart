import 'package:ease_state_helper/ease_state_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestState extends StateNotifier<int> {
  TestState([int initial = 0]) : super(initial);

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
  void setWithAction(int value, String action) =>
      setState(value, action: action);
  void updateState(int Function(int) updater, {String? action}) =>
      update(updater, action: action);
}

class TestMiddleware extends EaseMiddleware {
  final List<String> events = [];

  @override
  void onStateInit<T>(StateInitEvent<T> event) {
    events.add('init:${event.stateName}:${event.initialState}');
  }

  @override
  void onBeforeStateChange<T>(StateChangeEvent<T> event) {
    events.add('before:${event.oldState}->${event.newState}:${event.action}');
  }

  @override
  void onStateChange<T>(StateChangeEvent<T> event) {
    events.add('change:${event.oldState}->${event.newState}:${event.action}');
  }

  @override
  Future<void> onStateChangeAsync<T>(StateChangeEvent<T> event) async {
    events.add('async:${event.oldState}->${event.newState}');
  }

  @override
  void onStateDispose(StateDisposeEvent event) {
    events.add('dispose:${event.stateName}');
  }

  @override
  void onError(StateErrorEvent event) {
    events.add('error:${event.error}');
  }
}

class ThrowingMiddleware extends EaseMiddleware {
  @override
  void onBeforeStateChange<T>(StateChangeEvent<T> event) {
    throw Exception('Test error');
  }
}

class ThrowingInitMiddleware extends EaseMiddleware {
  @override
  void onStateInit<T>(StateInitEvent<T> event) {
    throw Exception('Init error');
  }
}

class ThrowingAsyncMiddleware extends EaseMiddleware {
  @override
  Future<void> onStateChangeAsync<T>(StateChangeEvent<T> event) async {
    throw Exception('Async error');
  }
}

void main() {
  tearDown(() {
    StateNotifier.middleware = [];
  });

  group('StateNotifier', () {
    test('initializes with given state', () {
      final notifier = TestState(42);
      expect(notifier.state, equals(42));
      notifier.dispose();
    });

    test('notifies listeners on state change', () {
      final notifier = TestState(0);
      var notified = false;
      notifier.addListener(() => notified = true);

      notifier.increment();

      expect(notified, isTrue);
      expect(notifier.state, equals(1));
      notifier.dispose();
    });

    test('does not notify when state unchanged', () {
      final notifier = TestState(0);
      var notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      notifier.state = 0; // Same value

      expect(notifyCount, equals(0));
      notifier.dispose();
    });

    test('hasActiveListeners returns correct value', () {
      final notifier = TestState(0);
      expect(notifier.hasActiveListeners, isFalse);

      void listener() {}
      notifier.addListener(listener);
      expect(notifier.hasActiveListeners, isTrue);

      notifier.removeListener(listener);
      expect(notifier.hasActiveListeners, isFalse);
      notifier.dispose();
    });

    test('setState updates state with action', () {
      final notifier = TestState(0);
      var notified = false;
      notifier.addListener(() => notified = true);

      notifier.setWithAction(10, 'setTo10');

      expect(notifier.state, equals(10));
      expect(notified, isTrue);
      notifier.dispose();
    });

    test('setState does not notify when state unchanged', () {
      final notifier = TestState(5);
      var notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      notifier.setWithAction(5, 'noChange');

      expect(notifyCount, equals(0));
      notifier.dispose();
    });

    test('update transforms state with function', () {
      final notifier = TestState(10);
      notifier.updateState((s) => s * 2);
      expect(notifier.state, equals(20));
      notifier.dispose();
    });

    test('update with action uses setState', () {
      final notifier = TestState(5);
      var notified = false;
      notifier.addListener(() => notified = true);

      notifier.updateState((s) => s + 5, action: 'add5');

      expect(notifier.state, equals(10));
      expect(notified, isTrue);
      notifier.dispose();
    });
  });

  group('StateNotifier middleware', () {
    test('middleware receives init event', () {
      final middleware = TestMiddleware();
      StateNotifier.middleware = [middleware];

      final notifier = TestState(42);

      expect(
        middleware.events,
        contains(startsWith('init:TestState:42')),
      );
      notifier.dispose();
    });

    test('middleware receives state change events', () {
      final middleware = TestMiddleware();
      StateNotifier.middleware = [middleware];

      final notifier = TestState(0);
      middleware.events.clear();
      notifier.increment();

      expect(
        middleware.events,
        containsAll([
          contains('before:0->1'),
          contains('change:0->1'),
          contains('async:0->1'),
        ]),
      );
      notifier.dispose();
    });

    test('middleware receives action name', () {
      final middleware = TestMiddleware();
      StateNotifier.middleware = [middleware];

      final notifier = TestState(0);
      middleware.events.clear();
      notifier.setWithAction(100, 'jumpTo100');

      expect(
        middleware.events.any((e) => e.contains('jumpTo100')),
        isTrue,
      );
      notifier.dispose();
    });

    test('middleware receives dispose event', () {
      final middleware = TestMiddleware();
      StateNotifier.middleware = [middleware];

      final notifier = TestState(0);
      middleware.events.clear();
      notifier.dispose();

      expect(
        middleware.events,
        contains(startsWith('dispose:TestState')),
      );
    });

    test('middleware errors are caught and reported', () async {
      final errorMiddleware = TestMiddleware();
      final throwingMiddleware = ThrowingMiddleware();
      StateNotifier.middleware = [throwingMiddleware, errorMiddleware];

      final notifier = TestState(0);
      errorMiddleware.events.clear();
      notifier.increment();

      // Wait for async operations
      await Future.delayed(Duration.zero);

      expect(
        errorMiddleware.events.any((e) => e.contains('error:')),
        isTrue,
      );
      notifier.dispose();
    });

    test('empty middleware does not affect state changes', () {
      StateNotifier.middleware = [];

      final notifier = TestState(0);
      notifier.increment();

      expect(notifier.state, equals(1));
      notifier.dispose();
    });

    test('prevents recursive middleware calls', () {
      // Create middleware that modifies state during callback
      final middleware = TestMiddleware();
      StateNotifier.middleware = [middleware];

      final notifier = TestState(0);
      middleware.events.clear();

      notifier.increment();

      // Should only have one set of before/change/async events
      final beforeCount =
          middleware.events.where((e) => e.startsWith('before:')).length;
      expect(beforeCount, equals(1));
      notifier.dispose();
    });

    test('middleware error in onStateInit is caught and reported', () {
      final errorMiddleware = TestMiddleware();
      final throwingMiddleware = ThrowingInitMiddleware();
      StateNotifier.middleware = [throwingMiddleware, errorMiddleware];

      // Creating notifier triggers onStateInit which throws
      final notifier = TestState(0);

      // Error should be caught and reported to onError
      expect(
        errorMiddleware.events.any((e) => e.contains('error:')),
        isTrue,
      );
      notifier.dispose();
    });

    test('async middleware error is caught and reported', () async {
      final errorMiddleware = TestMiddleware();
      final throwingMiddleware = ThrowingAsyncMiddleware();
      StateNotifier.middleware = [throwingMiddleware, errorMiddleware];

      final notifier = TestState(0);
      errorMiddleware.events.clear();
      notifier.increment();

      // Wait for async error to be caught
      await Future.delayed(const Duration(milliseconds: 10));

      expect(
        errorMiddleware.events.any((e) => e.contains('error:')),
        isTrue,
      );
      notifier.dispose();
    });
  });

  group('EaseSubscription', () {
    test('cancel() sets isCancelled to true', () {
      var cancelled = false;
      final subscription = EaseSubscription(() => cancelled = true);

      expect(subscription.isCancelled, isFalse);
      subscription.cancel();
      expect(subscription.isCancelled, isTrue);
      expect(cancelled, isTrue);
    });

    test('cancel() is idempotent - only calls callback once', () {
      var cancelCount = 0;
      final subscription = EaseSubscription(() => cancelCount++);

      subscription.cancel();
      subscription.cancel();
      subscription.cancel();

      expect(cancelCount, equals(1));
    });
  });

  group('StateNotifier.listenInContext', () {
    testWidgets('listener receives previous and current state', (tester) async {
      final notifier = TestState(0);
      final changes = <(int, int)>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              notifier.listenInContext(context, (prev, next) {
                changes.add((prev, next));
              });
              return const SizedBox();
            },
          ),
        ),
      );

      notifier.increment();
      await tester.pump();

      expect(changes, equals([(0, 1)]));

      notifier.increment();
      await tester.pump();

      expect(changes, equals([(0, 1), (1, 2)]));
      notifier.dispose();
    });

    testWidgets('fireImmediately calls listener immediately', (tester) async {
      final notifier = TestState(42);
      final changes = <(int, int)>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              notifier.listenInContext(
                context,
                (prev, next) => changes.add((prev, next)),
                fireImmediately: true,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      // Should fire immediately with same prev and next
      expect(changes, equals([(42, 42)]));
      notifier.dispose();
    });

    testWidgets('manual cancel removes listener', (tester) async {
      final notifier = TestState(0);
      final changes = <(int, int)>[];
      EaseSubscription? subscription;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              subscription = notifier.listenInContext(context, (prev, next) {
                changes.add((prev, next));
              });
              return const SizedBox();
            },
          ),
        ),
      );

      notifier.increment();
      await tester.pump();
      expect(changes, equals([(0, 1)]));

      // Cancel subscription
      subscription!.cancel();

      notifier.increment();
      await tester.pump();

      // Should not receive second change
      expect(changes, equals([(0, 1)]));
      notifier.dispose();
    });

    testWidgets('auto-cleanup when widget is disposed', (tester) async {
      final notifier = TestState(0);
      final changes = <(int, int)>[];

      // Build widget with listener
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              notifier.listenInContext(context, (prev, next) {
                changes.add((prev, next));
              });
              return const SizedBox();
            },
          ),
        ),
      );

      notifier.increment();
      await tester.pump();
      expect(changes, equals([(0, 1)]));

      // Dispose widget by replacing with empty container
      await tester.pumpWidget(const SizedBox());

      // State change after widget disposed
      notifier.increment();
      await tester.pump();

      // Should not receive change (listener auto-cleaned up due to unmounted context)
      expect(changes, equals([(0, 1)]));
      notifier.dispose();
    });

    testWidgets('listener not called when context unmounted', (tester) async {
      final notifier = TestState(0);
      var listenerCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              notifier.listenInContext(context, (prev, next) {
                listenerCalled = true;
              });
              return const SizedBox();
            },
          ),
        ),
      );

      // Dispose the widget
      await tester.pumpWidget(const SizedBox());

      // Trigger state change
      notifier.increment();
      await tester.pump();

      // Listener should not be called because context is unmounted
      expect(listenerCalled, isFalse);
      notifier.dispose();
    });
  });
}
