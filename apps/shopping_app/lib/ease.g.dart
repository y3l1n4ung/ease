// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:ease_state_helper/ease_state_helper.dart';

import 'features/auth/view_models/auth_view_model.dart';
import 'features/cart/view_models/cart_view_model.dart';
import 'features/checkout/view_models/checkout_view_model.dart';
import 'features/orders/view_models/orders_view_model.dart';
import 'features/products/view_models/products_view_model.dart';

// ============================================
// Generated Providers List
// ============================================

/// All generated providers for @ease annotated classes.
///
/// Usage:
/// ```dart
/// import 'ease.g.dart';
///
/// void main() => runApp(
///   EaseScope(providers: $easeProviders, child: MyApp()),
/// );
/// ```
final $easeProviders = <ProviderBuilder>[
  (child) => AuthViewModelProvider(child: child),
  (child) => CartViewModelProvider(child: child),
  (child) => CheckoutViewModelProvider(child: child),
  (child) => OrdersViewModelProvider(child: child),
  (child) => ProductsViewModelProvider(child: child),
];

// ============================================
// Generic Context Extension
// ============================================

/// Extension providing generic access to all @ease states.
///
/// Note: Local providers are not accessible via get<T>() or read<T>().
/// Use the typed context extensions instead (e.g., context.formState).
extension EaseContext on BuildContext {
  /// Gets a state by type and subscribes to changes.
  ///
  /// Example:
  /// ```dart
  /// final counter = context.get<CounterState>();
  /// ```
  T get<T extends StateNotifier>() {
    if (T == AuthViewModel) return authViewModel as T;
    if (T == CartViewModel) return cartViewModel as T;
    if (T == CheckoutViewModel) return checkoutViewModel as T;
    if (T == OrdersViewModel) return ordersViewModel as T;
    if (T == ProductsViewModel) return productsViewModel as T;
    throw StateError('No provider found for $T. Did you add @ease annotation?');
  }

  /// Gets a state by type without subscribing to changes.
  ///
  /// Example:
  /// ```dart
  /// final counter = context.read<CounterState>();
  /// ```
  T read<T extends StateNotifier>() {
    if (T == AuthViewModel) return readAuthViewModel() as T;
    if (T == CartViewModel) return readCartViewModel() as T;
    if (T == CheckoutViewModel) return readCheckoutViewModel() as T;
    if (T == OrdersViewModel) return readOrdersViewModel() as T;
    if (T == ProductsViewModel) return readProductsViewModel() as T;
    throw StateError('No provider found for $T. Did you add @ease annotation?');
  }
}
