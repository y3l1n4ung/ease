import 'package:ease/ease.dart';
import 'package:flutter_test/flutter_test.dart';

// Test StateNotifier implementation
class TestCounter extends StateNotifier<int> {
  TestCounter([int initial = 0]) : super(initial);

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;

  void incrementWithAction() {
    setState(state + 1, action: 'increment');
  }

  void updateWithAction(int value) {
    update((current) => current + value, action: 'updateBy$value');
  }
}

void main() {
  // Initialize DevTools once for all tests (service extensions can only register once)
  setUpAll(() {
    EaseDevTools().initialize();
  });

  group('EaseDevTools', () {
    late EaseDevTools devTools;

    setUp(() {
      devTools = EaseDevTools();
      // Clear history before each test
      devTools.clearHistory();
    });

    test('initializes in debug mode', () {
      expect(devTools.isEnabled, isTrue);
    });

    test('registers state on creation', () {
      final counter = TestCounter();
      addTearDown(counter.dispose);

      expect(devTools.stateExists(counter), isTrue);
    });

    test('unregisters state on dispose', () {
      final counter = TestCounter();
      expect(devTools.stateExists(counter), isTrue);

      counter.dispose();

      expect(devTools.stateExists(counter), isFalse);
    });

    test('records state changes', () {
      final counter = TestCounter(0);
      addTearDown(counter.dispose);

      counter.increment();
      counter.increment();
      counter.decrement();

      final history = devTools.getHistory(counter);
      expect(history.length, equals(3));

      // Verify change order
      expect(history[0].oldState, equals('0'));
      expect(history[0].newState, equals('1'));

      expect(history[1].oldState, equals('1'));
      expect(history[1].newState, equals('2'));

      expect(history[2].oldState, equals('2'));
      expect(history[2].newState, equals('1'));
    });

    test('records action names with setState', () {
      final counter = TestCounter(0);
      addTearDown(counter.dispose);

      counter.incrementWithAction();

      final history = devTools.getHistory(counter);
      expect(history.length, equals(1));
      expect(history[0].action, equals('increment'));
    });

    test('records action names with update', () {
      final counter = TestCounter(0);
      addTearDown(counter.dispose);

      counter.updateWithAction(5);

      final history = devTools.getHistory(counter);
      expect(history.length, equals(1));
      expect(history[0].action, equals('updateBy5'));
      expect(history[0].newState, equals('5'));
    });

    test('getStates returns all registered states', () {
      final counter1 = TestCounter(10);
      final counter2 = TestCounter(20);
      addTearDown(counter1.dispose);
      addTearDown(counter2.dispose);

      final states = devTools.getStates();
      // Filter to only TestCounter types to avoid interference from other tests
      final testCounterStates =
          states.where((s) => s.type == 'TestCounter').toList();
      expect(testCounterStates.length, greaterThanOrEqualTo(2));

      final values = testCounterStates.map((s) => s.value).toSet();
      expect(values, contains('10'));
      expect(values, contains('20'));
    });

    test('clears history', () {
      final counter = TestCounter(0);
      addTearDown(counter.dispose);

      counter.increment();
      counter.increment();
      expect(devTools.getHistory(counter).length, equals(2));

      devTools.clearHistory();

      expect(devTools.getHistory(counter).length, equals(0));
    });

    test('limits history size', () {
      final counter = TestCounter(0);
      addTearDown(counter.dispose);

      // Generate more than max history size (100) changes
      for (int i = 0; i < 150; i++) {
        counter.increment();
      }

      final history = devTools.getHistory(counter);
      // Should be capped at 100
      expect(history.length, lessThanOrEqualTo(100));
    });

    test('handles multiple states independently', () {
      final counter1 = TestCounter(0);
      final counter2 = TestCounter(100);
      addTearDown(counter1.dispose);
      addTearDown(counter2.dispose);

      counter1.increment();
      counter2.decrement();
      counter1.increment();

      final history1 = devTools.getHistory(counter1);
      final history2 = devTools.getHistory(counter2);

      expect(history1.length, equals(2));
      expect(history2.length, equals(1));

      expect(history1[0].newState, equals('1'));
      expect(history1[1].newState, equals('2'));
      expect(history2[0].newState, equals('99'));
    });

    test('does not record unchanged state', () {
      final counter = TestCounter(5);
      addTearDown(counter.dispose);

      // Set to same value
      counter.state = 5;

      final history = devTools.getHistory(counter);
      expect(history.length, equals(0));
    });
  });

  group('StateChangeRecord', () {
    test('toJson produces correct format', () {
      final timestamp = DateTime(2024, 1, 15, 10, 30, 0);
      final record = StateChangeRecord(
        stateId: 'TestCounter_123',
        stateName: 'TestCounter',
        oldState: '0',
        newState: '1',
        action: 'increment',
        timestamp: timestamp,
      );

      final json = record.toJson();

      expect(json['stateId'], equals('TestCounter_123'));
      expect(json['stateName'], equals('TestCounter'));
      expect(json['oldState'], equals('0'));
      expect(json['newState'], equals('1'));
      expect(json['action'], equals('increment'));
      expect(json['timestamp'], equals('2024-01-15T10:30:00.000'));
    });

    test('toString provides readable format', () {
      final record = StateChangeRecord(
        stateId: 'TestCounter_123',
        stateName: 'TestCounter',
        oldState: '0',
        newState: '1',
        action: 'increment',
        timestamp: DateTime.now(),
      );

      expect(
        record.toString(),
        equals('StateChange(TestCounter: 0 -> 1 [increment])'),
      );
    });

    test('toString without action', () {
      final record = StateChangeRecord(
        stateId: 'TestCounter_123',
        stateName: 'TestCounter',
        oldState: '0',
        newState: '1',
        timestamp: DateTime.now(),
      );

      expect(record.toString(), equals('StateChange(TestCounter: 0 -> 1)'));
    });
  });

  group('StateNotifier DevTools integration', () {
    setUp(() {
      EaseDevTools().clearHistory();
    });

    test('setState records action', () {
      final counter = TestCounter(0);
      addTearDown(counter.dispose);

      counter.setState(10, action: 'setTo10');

      final history = EaseDevTools().getHistory(counter);
      expect(history.length, equals(1));
      expect(history[0].action, equals('setTo10'));
      expect(history[0].newState, equals('10'));
    });

    test('update with action records action', () {
      final counter = TestCounter(5);
      addTearDown(counter.dispose);

      counter.update((c) => c * 2, action: 'double');

      final history = EaseDevTools().getHistory(counter);
      expect(history.length, equals(1));
      expect(history[0].action, equals('double'));
      expect(history[0].newState, equals('10'));
    });

    test('update without action still records change', () {
      final counter = TestCounter(5);
      addTearDown(counter.dispose);

      counter.update((c) => c + 1);

      final history = EaseDevTools().getHistory(counter);
      expect(history.length, equals(1));
      expect(history[0].action, isNull);
      expect(history[0].newState, equals('6'));
    });
  });
}
