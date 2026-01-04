import 'package:ease_state_helper/ease_state_helper.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test StateNotifier for middleware tests.
class TestCounter extends StateNotifier<int> {
  TestCounter([super.initial = 0]);

  void increment() => state++;
  void decrement() => state--;
  void setWithAction(int value, String action) =>
      setState(value, action: action);
}

/// Test middleware that records all events.
class RecordingMiddleware extends EaseMiddleware {
  final List<StateInitEvent> initEvents = [];
  final List<StateChangeEvent> beforeChangeEvents = [];
  final List<StateChangeEvent> changeEvents = [];
  final List<StateChangeEvent> asyncChangeEvents = [];
  final List<StateDisposeEvent> disposeEvents = [];
  final List<StateErrorEvent> errorEvents = [];

  @override
  void onStateInit<T>(StateInitEvent<T> event) {
    initEvents.add(event);
  }

  @override
  void onBeforeStateChange<T>(StateChangeEvent<T> event) {
    beforeChangeEvents.add(event);
  }

  @override
  void onStateChange<T>(StateChangeEvent<T> event) {
    changeEvents.add(event);
  }

  @override
  Future<void> onStateChangeAsync<T>(StateChangeEvent<T> event) async {
    asyncChangeEvents.add(event);
  }

  @override
  void onStateDispose(StateDisposeEvent event) {
    disposeEvents.add(event);
  }

  @override
  void onError(StateErrorEvent event) {
    errorEvents.add(event);
  }

  void clear() {
    initEvents.clear();
    beforeChangeEvents.clear();
    changeEvents.clear();
    asyncChangeEvents.clear();
    disposeEvents.clear();
    errorEvents.clear();
  }
}

/// Test middleware that throws on state change.
class ThrowingMiddleware extends EaseMiddleware {
  @override
  void onStateChange<T>(StateChangeEvent<T> event) {
    throw Exception('Test exception');
  }
}

/// Test middleware that records call order.
class OrderMiddleware extends EaseMiddleware {
  final int id;
  final List<int> order;

  OrderMiddleware(this.id, this.order);

  @override
  void onStateChange<T>(StateChangeEvent<T> event) {
    order.add(id);
  }
}

void main() {
  late RecordingMiddleware middleware;

  setUp(() {
    middleware = RecordingMiddleware();
    StateNotifier.middleware = [middleware];
  });

  tearDown(() {
    StateNotifier.middleware = [];
  });

  group('Middleware', () {
    test('receives state init event', () {
      final counter = TestCounter(5);
      addTearDown(counter.dispose);

      expect(middleware.initEvents.length, 1);
      expect(middleware.initEvents[0].stateName, 'TestCounter');
      expect(middleware.initEvents[0].initialState, 5);
      expect(middleware.initEvents[0].notifier, counter);
    });

    test('receives state change events', () {
      final counter = TestCounter();
      addTearDown(counter.dispose);

      middleware.clear();

      counter.increment();

      expect(middleware.beforeChangeEvents.length, 1);
      expect(middleware.changeEvents.length, 1);
      expect(middleware.asyncChangeEvents.length, 1);

      final event = middleware.changeEvents[0];
      expect(event.stateName, 'TestCounter');
      expect(event.oldState, 0);
      expect(event.newState, 1);
      expect(event.action, isNull);
    });

    test('receives action name in event', () {
      final counter = TestCounter();
      addTearDown(counter.dispose);

      middleware.clear();

      counter.setWithAction(10, 'setTo10');

      expect(middleware.changeEvents.length, 1);
      expect(middleware.changeEvents[0].action, 'setTo10');
    });

    test('receives state dispose event', () {
      final counter = TestCounter();
      counter.dispose();

      expect(middleware.disposeEvents.length, 1);
      expect(middleware.disposeEvents[0].stateName, 'TestCounter');
    });

    test('does not notify when state is same', () {
      final counter = TestCounter(5);
      addTearDown(counter.dispose);

      middleware.clear();

      counter.setState(5); // Same value

      expect(middleware.changeEvents.length, 0);
    });

    test('exception in middleware does not break state update', () {
      StateNotifier.middleware = [ThrowingMiddleware(), middleware];

      final counter = TestCounter();
      addTearDown(counter.dispose);

      middleware.clear();

      // Should not throw
      counter.increment();

      // State should still be updated
      expect(counter.state, 1);

      // Recording middleware should still receive event
      expect(middleware.changeEvents.length, 1);

      // Error middleware should receive the error
      expect(middleware.errorEvents.length, 1);
      expect(middleware.errorEvents[0].error.toString(),
          contains('Test exception'));
    });

    test('middleware called in order', () {
      final order = <int>[];

      StateNotifier.middleware = [
        OrderMiddleware(1, order),
        OrderMiddleware(2, order),
        OrderMiddleware(3, order),
      ];

      final counter = TestCounter();
      addTearDown(counter.dispose);

      counter.increment();

      expect(order, [1, 2, 3]);
    });

    test('prevents recursive middleware calls', () {
      var callCount = 0;

      StateNotifier.middleware = [
        _RecursiveMiddleware((event) {
          callCount++;
          // Try to trigger another state change - should be ignored
          (event.notifier as TestCounter).increment();
        }),
      ];

      final counter = TestCounter();
      addTearDown(counter.dispose);

      counter.increment();

      // Should only be called once, not recursively
      expect(callCount, 1);
    });

    test('multiple state notifiers work independently', () {
      final counter1 = TestCounter(0);
      final counter2 = TestCounter(100);
      addTearDown(counter1.dispose);
      addTearDown(counter2.dispose);

      middleware.clear();

      counter1.increment();
      counter2.decrement();

      expect(middleware.changeEvents.length, 2);

      expect(middleware.changeEvents[0].oldState, 0);
      expect(middleware.changeEvents[0].newState, 1);

      expect(middleware.changeEvents[1].oldState, 100);
      expect(middleware.changeEvents[1].newState, 99);
    });

    test('empty middleware list does not break state', () {
      StateNotifier.middleware = [];

      final counter = TestCounter();
      addTearDown(counter.dispose);

      counter.increment();
      counter.increment();

      expect(counter.state, 2);
    });
  });

  group('LoggingMiddleware', () {
    test('logs state changes', () {
      final logs = <String>[];
      final loggingMiddleware = LoggingMiddleware(
        includeTimestamp: false,
        logger: logs.add,
      );

      StateNotifier.middleware = [loggingMiddleware];

      final counter = TestCounter();
      addTearDown(counter.dispose);

      counter.increment();

      expect(logs.length, 2); // INIT + change
      expect(logs[0], 'INIT TestCounter: 0');
      expect(logs[1], 'TestCounter 0 -> 1');
    });

    test('logs action name', () {
      final logs = <String>[];
      final loggingMiddleware = LoggingMiddleware(
        includeTimestamp: false,
        logger: logs.add,
      );

      StateNotifier.middleware = [loggingMiddleware];

      final counter = TestCounter();
      addTearDown(counter.dispose);

      counter.setWithAction(5, 'reset');

      expect(logs[1], 'TestCounter (reset) 0 -> 5');
    });

    test('logs dispose', () {
      final logs = <String>[];
      final loggingMiddleware = LoggingMiddleware(
        includeTimestamp: false,
        logger: logs.add,
      );

      StateNotifier.middleware = [loggingMiddleware];

      final counter = TestCounter();
      counter.dispose();

      expect(logs.last, 'DISPOSE TestCounter');
    });

    test('respects includedStates filter', () {
      final logs = <String>[];
      final loggingMiddleware = LoggingMiddleware(
        includeTimestamp: false,
        logger: logs.add,
        includedStates: {String}, // Only log String states (not TestCounter)
      );

      StateNotifier.middleware = [loggingMiddleware];

      final counter = TestCounter();
      addTearDown(counter.dispose);

      counter.increment();

      // Should not log TestCounter
      expect(logs.where((l) => l.contains('TestCounter')), isEmpty);
    });

    test('respects excludedStates filter', () {
      final logs = <String>[];
      final loggingMiddleware = LoggingMiddleware(
        includeTimestamp: false,
        logger: logs.add,
        excludedStates: {TestCounter},
      );

      StateNotifier.middleware = [loggingMiddleware];

      final counter = TestCounter();
      addTearDown(counter.dispose);

      counter.increment();

      // Should not log TestCounter (change events, but dispose still logs)
      expect(logs.where((l) => l.contains('INIT')), isEmpty);
      expect(logs.where((l) => l.contains('0 -> 1')), isEmpty);
    });

    test('includes timestamp when enabled', () {
      final logs = <String>[];
      final loggingMiddleware = LoggingMiddleware(
        includeTimestamp: true,
        logger: logs.add,
      );

      StateNotifier.middleware = [loggingMiddleware];

      final counter = TestCounter();
      addTearDown(counter.dispose);

      expect(logs[0], startsWith('['));
      expect(logs[0], contains('INIT TestCounter'));
    });
  });
}

/// Helper middleware for testing recursive calls.
class _RecursiveMiddleware extends EaseMiddleware {
  final void Function(StateChangeEvent event) callback;

  _RecursiveMiddleware(this.callback);

  @override
  void onStateChange<T>(StateChangeEvent<T> event) {
    callback(event);
  }
}
