@Tags(['integration'])
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// Integration tests for ease_generator.
///
/// These tests run the actual build_runner on a fixture project
/// to verify the complete code generation pipeline.
///
/// Run with: dart test --tags=integration
/// Note: Requires Flutter SDK to be available in PATH.
void main() {
  final fixtureDir = p.join(
    Directory.current.path,
    'test',
    'integration',
    'fixtures',
    'test_project',
  );

  setUpAll(() async {
    // Clean any previous generated files
    await _cleanGeneratedFiles(fixtureDir);

    // Run flutter pub get (ease_state_helper requires Flutter)
    final pubGetResult = await Process.run(
      'flutter',
      ['pub', 'get'],
      workingDirectory: fixtureDir,
    );

    if (pubGetResult.exitCode != 0) {
      throw Exception(
        'flutter pub get failed:\n${pubGetResult.stderr}\n${pubGetResult.stdout}',
      );
    }

    // Run build_runner (using flutter pub run for Flutter projects)
    final buildResult = await Process.run(
      'flutter',
      ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      workingDirectory: fixtureDir,
    );

    if (buildResult.exitCode != 0) {
      throw Exception(
        'build_runner failed:\n${buildResult.stderr}\n${buildResult.stdout}',
      );
    }
  });

  // Note: We don't clean up in tearDownAll because:
  // 1. Generated files in test fixture don't affect anything
  // 2. Cleaning causes issues when pre-commit hooks re-run tests

  group('EaseGenerator (per-file)', () {
    test('generates .ease.dart for CounterState', () {
      final file = File(p.join(fixtureDir, 'lib', 'counter_state.ease.dart'));
      expect(file.existsSync(), isTrue,
          reason: 'counter_state.ease.dart should exist');

      final content = file.readAsStringSync();

      // Verify Provider widget
      expect(content,
          contains('class CounterStateProvider extends StatefulWidget'));

      // Verify InheritedModel
      expect(content,
          contains('class _CounterStateInherited extends InheritedModel'));

      // Verify context extension
      expect(
          content, contains('extension CounterStateContext on BuildContext'));

      // Verify getter methods
      expect(content, contains('CounterState get counterState'));
      expect(content, contains('CounterState readCounterState()'));
    });

    test('generates .ease.dart for UserState', () {
      final file = File(p.join(fixtureDir, 'lib', 'user_state.ease.dart'));
      expect(file.existsSync(), isTrue,
          reason: 'user_state.ease.dart should exist');

      final content = file.readAsStringSync();

      // Verify Provider widget
      expect(
          content, contains('class UserStateProvider extends StatefulWidget'));

      // Verify correct state type in InheritedModel
      expect(content, contains('User?'));

      // Verify context extension
      expect(content, contains('extension UserStateContext on BuildContext'));
    });

    test('generates .ease.dart for local FormState', () {
      final file = File(p.join(fixtureDir, 'lib', 'form_state.ease.dart'));
      expect(file.existsSync(), isTrue,
          reason: 'form_state.ease.dart should exist');

      final content = file.readAsStringSync();

      // Local providers still get their own Provider widget
      expect(
          content, contains('class FormStateProvider extends StatefulWidget'));
      expect(content, contains('extension FormStateContext on BuildContext'));
    });
  });

  group('Generated code compilation', () {
    test('generated code is valid Dart (analyzes without errors)', () async {
      final result = await Process.run(
        'flutter',
        ['analyze'],
        workingDirectory: fixtureDir,
      );

      // Check for actual errors
      final output = '${result.stdout}\n${result.stderr}';
      expect(output, isNot(contains('error •')),
          reason: 'Generated code should analyze without errors:\n$output');
    });
  });
}

/// Removes all generated files from the fixture project.
Future<void> _cleanGeneratedFiles(String fixtureDir) async {
  final libDir = Directory(p.join(fixtureDir, 'lib'));
  if (!libDir.existsSync()) return;

  await for (final entity in libDir.list()) {
    if (entity is File) {
      final name = p.basename(entity.path);
      if (name.endsWith('.ease.dart') || name == 'ease.g.dart') {
        await entity.delete();
      }
    }
  }

  // Also clean .dart_tool cache
  final dartToolDir = Directory(p.join(fixtureDir, '.dart_tool'));
  if (dartToolDir.existsSync()) {
    await dartToolDir.delete(recursive: true);
  }
}
