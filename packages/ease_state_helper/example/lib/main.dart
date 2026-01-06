import 'package:ease_state_helper/ease_state_helper.dart';
import 'package:flutter/material.dart';

import 'ease.g.dart';
import 'view_models/counter_view_model.dart';

void main() {
  runApp(
    EaseScope(
      providers: $easeProviders,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ease Counter Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch - rebuilds when state changes
    final counter = context.counterViewModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Count:', style: TextStyle(fontSize: 24)),
            Text(
              '${counter.state}',
              style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'decrement',
                  onPressed: counter.decrement,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'reset',
                  onPressed: counter.reset,
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'increment',
                  onPressed: counter.increment,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
