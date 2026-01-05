import 'package:ease_state_helper/ease_state_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Ease widget', () {
    testWidgets('renders child when no providers', (tester) async {
      await tester.pumpWidget(
        const Ease(
          child: Text('Hello', textDirection: TextDirection.ltr),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('wraps child with single provider', (tester) async {
      var providerCalled = false;

      await tester.pumpWidget(
        Ease(
          providers: [
            (child) {
              providerCalled = true;
              return Container(child: child);
            },
          ],
          child: const Text('Hello', textDirection: TextDirection.ltr),
        ),
      );

      expect(providerCalled, isTrue);
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('wraps child with multiple providers in order', (tester) async {
      final order = <int>[];

      await tester.pumpWidget(
        Ease(
          providers: [
            (child) {
              order.add(1);
              return Container(key: const Key('p1'), child: child);
            },
            (child) {
              order.add(2);
              return Container(key: const Key('p2'), child: child);
            },
            (child) {
              order.add(3);
              return Container(key: const Key('p3'), child: child);
            },
          ],
          child: const Text('Hello', textDirection: TextDirection.ltr),
        ),
      );

      // Providers should be applied in order (fold starts with child)
      expect(order, equals([1, 2, 3]));
      expect(find.text('Hello'), findsOneWidget);
      expect(find.byKey(const Key('p1')), findsOneWidget);
      expect(find.byKey(const Key('p2')), findsOneWidget);
      expect(find.byKey(const Key('p3')), findsOneWidget);
    });

    testWidgets('providers nest correctly (last wraps first)', (tester) async {
      // Build widget tree and verify nesting order
      // With fold, providers are applied in order: p1(p2(p3(child)))
      // So the last provider in the list becomes the outermost wrapper
      await tester.pumpWidget(
        Ease(
          providers: [
            (child) => Container(key: const Key('first'), child: child),
            (child) => Container(key: const Key('last'), child: child),
          ],
          child: const Text('Hello', textDirection: TextDirection.ltr),
        ),
      );

      final firstFinder = find.byKey(const Key('first'));
      final lastFinder = find.byKey(const Key('last'));

      expect(firstFinder, findsOneWidget);
      expect(lastFinder, findsOneWidget);

      // With fold, last provider wraps first provider
      // Result: last(first(child))
      expect(
        find.descendant(of: lastFinder, matching: firstFinder),
        findsOneWidget,
      );
    });
  });

  group('ProviderBuilder typedef', () {
    test('can be used as function type', () {
      ProviderBuilder builder = (child) => Container(child: child);
      final result =
          builder(const Text('test', textDirection: TextDirection.ltr));
      expect(result, isA<Container>());
    });
  });
}
