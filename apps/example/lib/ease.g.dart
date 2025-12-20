// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:ease/ease.dart';

import 'view_models/auth_view_model.dart';
import 'view_models/cart_view_model.dart';
import 'view_models/counter_view_model.dart';
import 'view_models/form_view_model.dart';
import 'view_models/network_view_model.dart';
import 'view_models/pagination_view_model.dart';
import 'view_models/search_view_model.dart';
import 'view_models/theme_view_model.dart';
import 'view_models/todo_view_model.dart';

// ============================================
// Ease Root Widget
// ============================================

/// Root widget that provides all @ease states to descendants.
///
/// Wrap your app with this widget to enable state access:
/// ```dart
/// void main() => runApp(Ease(child: MyApp()));
/// ```
///
/// Note: Local providers (@ease(local: true)) are not included here.
/// They must be manually placed in your widget tree.
class Ease extends StatelessWidget {
  final Widget child;

  const Ease({super.key, required this.child});

  static final _providers = <Widget Function(Widget)>[
    (child) => AuthViewModelProvider(child: child),
    (child) => CartViewModelProvider(child: child),
    (child) => CounterViewModelProvider(child: child),
    (child) => RegistrationFormViewModelProvider(child: child),
    (child) => NetworkViewModelProvider(child: child),
    (child) => PaginationViewModelProvider(child: child),
    (child) => SearchViewModelProvider(child: child),
    (child) => ThemeViewModelProvider(child: child),
    (child) => TodoViewModelProvider(child: child),
  ];

  @override
  Widget build(BuildContext context) {
    return _providers.fold(child, (child, provider) => provider(child));
  }
}

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
    if (T == CounterViewModel) return counterViewModel as T;
    if (T == RegistrationFormViewModel) return registrationFormViewModel as T;
    if (T == NetworkViewModel) return networkViewModel as T;
    if (T == PaginationViewModel) return paginationViewModel as T;
    if (T == SearchViewModel) return searchViewModel as T;
    if (T == ThemeViewModel) return themeViewModel as T;
    if (T == TodoViewModel) return todoViewModel as T;
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
    if (T == CounterViewModel) return readCounterViewModel() as T;
    if (T == RegistrationFormViewModel)
      return readRegistrationFormViewModel() as T;
    if (T == NetworkViewModel) return readNetworkViewModel() as T;
    if (T == PaginationViewModel) return readPaginationViewModel() as T;
    if (T == SearchViewModel) return readSearchViewModel() as T;
    if (T == ThemeViewModel) return readThemeViewModel() as T;
    if (T == TodoViewModel) return readTodoViewModel() as T;
    throw StateError('No provider found for $T. Did you add @ease annotation?');
  }
}
