import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

import 'src/ease_devtools_extension.dart';

void main() {
  runApp(const EaseDevToolsExtensionApp());
}

class EaseDevToolsExtensionApp extends StatelessWidget {
  const EaseDevToolsExtensionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DevToolsExtension(
      child: EaseDevToolsExtension(),
    );
  }
}
