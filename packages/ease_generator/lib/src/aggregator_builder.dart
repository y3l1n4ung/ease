import 'dart:async';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';

import 'utils.dart';

/// Aggregator builder that finds all @ease generated files
/// and creates a single ease.g.dart file with the Ease root widget.
///
/// Local providers (@ease(local: true)) are excluded from the global
/// Ease widget and EaseContext extension.
class AggregatorBuilder implements Builder {
  @override
  final buildExtensions = const {
    r'lib/$lib$': ['lib/ease.g.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final stateClasses = <_StateClassInfo>[];

    // Find all generated .ease.dart files
    await for (final input
        in buildStep.findAssets(Glob('lib/**/*.ease.dart'))) {
      // Derive source file path: .ease.dart -> .dart
      final sourcePath = input.path.replaceAll('.ease.dart', '.dart');
      final sourceId = AssetId(input.package, sourcePath);

      // Read and parse source file with analyzer
      final sourceContent = await buildStep.readAsString(sourceId);
      final parseResult = parseString(content: sourceContent);

      // Find @ease annotated classes
      for (final declaration in parseResult.unit.declarations) {
        if (declaration is! ClassDeclaration) continue;

        // Check for @ease annotation
        final easeAnnotation = _findEaseAnnotation(declaration);
        if (easeAnnotation == null) continue;

        // Skip local providers - they are not registered globally
        if (_isLocalProvider(easeAnnotation)) {
          log.fine('Skipping local provider: ${declaration.name.lexeme}');
          continue;
        }

        // Extract class info
        final className = declaration.name.lexeme;
        final getterName = toCamelCase(className);
        final importPath = sourcePath.replaceFirst('lib/', '');

        stateClasses.add(_StateClassInfo(
          className: className,
          providerName: '${className}Provider',
          getterName: getterName,
          importPath: importPath,
        ));
      }
    }

    if (stateClasses.isEmpty) {
      log.info('No global @ease annotated classes found.');
      return;
    }

    // Generate the aggregated file
    final buffer = StringBuffer();

    // Header
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln('// ignore_for_file: type=lint');
    buffer.writeln();
    buffer.writeln("import 'package:flutter/widgets.dart';");
    buffer
        .writeln("import 'package:ease_state_helper/ease_state_helper.dart';");
    buffer.writeln();

    // Import all state files (which include their .g.dart parts)
    for (final state in stateClasses) {
      buffer.writeln("import '${state.importPath}';");
    }
    buffer.writeln();

    // Generated providers list for convenience
    buffer.writeln('// ============================================');
    buffer.writeln('// Generated Providers List');
    buffer.writeln('// ============================================');
    buffer.writeln();
    buffer.writeln('/// All generated providers for @ease annotated classes.');
    buffer.writeln('///');
    buffer.writeln('/// Usage:');
    buffer.writeln('/// ```dart');
    buffer.writeln("/// import 'ease.g.dart';");
    buffer.writeln('///');
    buffer.writeln('/// void main() => runApp(');
    buffer.writeln(r"///   Ease(providers: $easeProviders, child: MyApp()),");
    buffer.writeln('/// );');
    buffer.writeln('/// ```');
    buffer.writeln(r'final $easeProviders = <ProviderBuilder>[');
    for (final state in stateClasses) {
      buffer.writeln('  (child) => ${state.providerName}(child: child),');
    }
    buffer.writeln('];');
    buffer.writeln();

    // Generate generic get<T>() extension
    buffer.writeln('// ============================================');
    buffer.writeln('// Generic Context Extension');
    buffer.writeln('// ============================================');
    buffer.writeln();
    buffer
        .writeln('/// Extension providing generic access to all @ease states.');
    buffer.writeln('///');
    buffer.writeln(
        '/// Note: Local providers are not accessible via get<T>() or read<T>().');
    buffer.writeln(
        '/// Use the typed context extensions instead (e.g., context.formState).');
    buffer.writeln('extension EaseContext on BuildContext {');
    buffer.writeln('  /// Gets a state by type and subscribes to changes.');
    buffer.writeln('  ///');
    buffer.writeln('  /// Example:');
    buffer.writeln('  /// ```dart');
    buffer.writeln('  /// final counter = context.get<CounterState>();');
    buffer.writeln('  /// ```');
    buffer.writeln('  T get<T extends StateNotifier>() {');
    for (final state in stateClasses) {
      buffer.writeln(
          '    if (T == ${state.className}) return ${state.getterName} as T;');
    }
    buffer.writeln(
        "    throw StateError('No provider found for \$T. Did you add @ease annotation?');");
    buffer.writeln('  }');
    buffer.writeln();
    buffer
        .writeln('  /// Gets a state by type without subscribing to changes.');
    buffer.writeln('  ///');
    buffer.writeln('  /// Example:');
    buffer.writeln('  /// ```dart');
    buffer.writeln('  /// final counter = context.read<CounterState>();');
    buffer.writeln('  /// ```');
    buffer.writeln('  T read<T extends StateNotifier>() {');
    for (final state in stateClasses) {
      buffer.writeln(
          '    if (T == ${state.className}) return read${state.className}() as T;');
    }
    buffer.writeln(
        "    throw StateError('No provider found for \$T. Did you add @ease annotation?');");
    buffer.writeln('  }');
    buffer.writeln('}');

    // Format and write the output
    final formatted = _formatDartCode(buffer.toString());

    final outputId = AssetId(
      buildStep.inputId.package,
      'lib/ease.g.dart',
    );
    await buildStep.writeAsString(outputId, formatted);

    log.info('Generated ease.g.dart with ${stateClasses.length} global states');
  }

  /// Find @ease annotation on a class declaration
  Annotation? _findEaseAnnotation(ClassDeclaration declaration) {
    for (final annotation in declaration.metadata) {
      final name = annotation.name;
      if (name is SimpleIdentifier && name.name == 'ease') {
        return annotation;
      }
    }
    return null;
  }

  /// Check if the annotation has local: true parameter
  bool _isLocalProvider(Annotation annotation) {
    final args = annotation.arguments;
    if (args == null) return false;

    for (final arg in args.arguments) {
      if (arg is NamedExpression &&
          arg.name.label.name == 'local' &&
          arg.expression is BooleanLiteral) {
        return (arg.expression as BooleanLiteral).value;
      }
    }
    return false;
  }

  /// Format Dart code
  String _formatDartCode(String code) {
    try {
      final formatter =
          DartFormatter(languageVersion: DartFormatter.latestLanguageVersion);
      return formatter.format(code);
    } catch (_) {
      // If formatting fails, return unformatted code
      return code;
    }
  }
}

class _StateClassInfo {
  final String className;
  final String providerName;
  final String getterName;
  final String importPath;

  _StateClassInfo({
    required this.className,
    required this.providerName,
    required this.getterName,
    required this.importPath,
  });
}
