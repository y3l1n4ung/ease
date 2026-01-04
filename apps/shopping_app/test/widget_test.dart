import 'package:ease_state_helper/ease_state_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shopping_app/ease.g.dart';
import 'package:shopping_app/main.dart';

void main() {
  testWidgets('Shopping app loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      Ease(providers: $easeProviders, child: const ShoppingApp()),
    );
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
