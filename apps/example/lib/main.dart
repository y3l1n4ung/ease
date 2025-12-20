import 'package:ease/ease.dart';
import 'package:ease_example/view_models/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ease.g.dart';
import 'router/app_router.dart';
import 'view_models/auth_view_model.dart';

void main() {
  initializeEase(); // Initialize DevTools (debug mode only)
  StateNotifier.middleware = [
    LoggingMiddleware(),
    // Add your custom middleware
  ];
  runApp(const Ease(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoRouter? _router;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final authViewModel = context.readAuthViewModel();
      // Create router with auth viewmodel
      _router = createRouter(authViewModel);
      // Initialize auth from shared_preferences after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        authViewModel.initialize();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading until router is initialized
    if (_router == null) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    final themeViewModel = context.themeViewModel;

    return MaterialApp.router(
      title: 'Ease Examples',
      debugShowCheckedModeBanner: false,
      theme: themeViewModel.state.lightTheme,
      darkTheme: themeViewModel.state.darkTheme,
      themeMode: themeViewModel.state.themeMode,
      routerConfig: _router,
    );
  }
}
