import 'package:ease/ease.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/logging/logger.dart';
import 'core/router/app_router.dart';
import 'core/services/storage_service.dart';
import 'ease.g.dart';
import 'features/auth/view_models/auth_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage before app starts
  final prefs = await SharedPreferences.getInstance();
  StorageService.initialize(prefs);

  runApp(Ease(providers: $easeProviders, child: const ShoppingApp()));
}

class ShoppingApp extends StatefulWidget {
  const ShoppingApp({super.key});

  @override
  State<ShoppingApp> createState() => _ShoppingAppState();
}

class _ShoppingAppState extends State<ShoppingApp> {
  GoRouter? _router;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final authViewModel = context.readAuthViewModel();
      _router = createAppRouter(authViewModel);

      // Debug: Listen to auth changes
      authViewModel.addListener(() {
        logger.info(
          'MAIN',
          'Auth state changed: ${authViewModel.state.status}, isAuthenticated: ${authViewModel.state.isAuthenticated}',
        );
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

    return MaterialApp.router(
      title: 'Shopping App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
