import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/register_screen.dart';
import '../../features/auth/view_models/auth_view_model.dart';
import '../logging/logger.dart';
import '../../features/cart/views/cart_screen.dart';
import '../../features/checkout/views/checkout_screen.dart';
import '../../features/checkout/views/order_confirmation_screen.dart';
import '../../features/orders/views/orders_screen.dart';
import '../../features/product_detail/views/product_detail_screen.dart';
import '../../features/products/views/products_screen.dart';
import '../../features/profile/views/profile_screen.dart';
import '../../shared/animations/page_transitions.dart';

/// Routes that require authentication
const _protectedRoutes = ['/checkout', '/orders', '/profile'];

/// Routes that should redirect to home if already authenticated
const _authRoutes = ['/login', '/register'];

/// Creates the app router with auth viewmodel for navigation guards
GoRouter createAppRouter(AuthViewModel authViewModel) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,

    // Refresh when auth state changes - AuthViewModel extends ChangeNotifier
    refreshListenable: authViewModel,

    // Global redirect for auth guards
    redirect: (context, state) {
      final isAuthenticated = authViewModel.state.isAuthenticated;
      final currentPath = state.matchedLocation;
      final fullPath = state.uri.toString();

      logger.debug('ROUTER', 'Redirect check: matchedLocation=$currentPath, fullUri=$fullPath, isAuthenticated=$isAuthenticated, authStatus=${authViewModel.state.status}');

      // Check if trying to access protected route without auth
      if (_protectedRoutes.any((route) => currentPath.startsWith(route))) {
        if (!isAuthenticated) {
          logger.info('ROUTER', 'Redirecting to login (protected route)');
          return '/login?redirect=${Uri.encodeComponent(currentPath)}';
        }
      }

      // Redirect from auth pages if already authenticated
      if (_authRoutes.contains(currentPath) && isAuthenticated) {
        final redirect = state.uri.queryParameters['redirect'];
        final target = redirect != null ? Uri.decodeComponent(redirect) : '/';
        logger.info('ROUTER', 'Redirecting from auth page to: $target');
        return target;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(
          redirectPath: state.uri.queryParameters['redirect'],
        ),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen(
          redirectPath: state.uri.queryParameters['redirect'],
        ),
      ),
      GoRoute(
        path: '/cart',
        pageBuilder: (context, state) => slideTransitionPage(
          key: state.pageKey,
          child: const CartScreen(),
          direction: SlideDirection.up,
        ),
      ),
      GoRoute(
        path: '/product/:id',
        pageBuilder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return fadeTransitionPage(
            key: state.pageKey,
            child: ProductDetailScreen(productId: id),
          );
        },
      ),
      GoRoute(
        path: '/checkout',
        pageBuilder: (context, state) => slideTransitionPage(
          key: state.pageKey,
          child: const CheckoutScreen(),
        ),
      ),
      GoRoute(
        path: '/order-confirmation/:orderId',
        pageBuilder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: OrderConfirmationScreen(orderId: orderId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                ),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/orders',
        pageBuilder: (context, state) => slideTransitionPage(
          key: state.pageKey,
          child: const OrdersScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => slideTransitionPage(
          key: state.pageKey,
          child: const ProfileScreen(),
        ),
      ),
    ],
  );
}
