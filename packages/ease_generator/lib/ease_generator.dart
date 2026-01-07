import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/generator.dart';

/// Builder factory for per-file ease code generation.
///
/// Generates Provider and InheritedWidget for each @ease class.
Builder easeBuilder(BuilderOptions options) =>
    PartBuilder([EaseGenerator()], '.ease.dart');
