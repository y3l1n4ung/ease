import 'dart:convert';

import 'package:ease_annotation/ease_annotation.dart';
import 'package:ease_state_helper/ease_state_helper.dart';
import 'package:flutter/widgets.dart';

import '../../../core/logging/logger.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';
import '../models/auth_state.dart';
import '../models/user.dart';

part 'auth_view_model.ease.dart';

@ease
class AuthViewModel extends StateNotifier<AuthState> {
  final ApiService _apiService;

  AuthViewModel({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      super(_loadInitialState());

  /// Load initial state synchronously from pre-initialized storage
  static AuthState _loadInitialState() {
    try {
      final token = StorageService.getString(StorageService.authTokenKey);
      final userJson = StorageService.getString(StorageService.authUserKey);

      if (token != null && userJson != null) {
        final user = User.fromJson(json.decode(userJson));
        logger.info('AUTH', 'Restored session for: ${user.username}');
        return AuthState(
          token: token,
          user: user,
          status: AuthStatus.authenticated,
        );
      }
    } catch (e) {
      logger.error('AUTH', 'Failed to restore session', e);
    }
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> _saveSession(String token, User user) async {
    await StorageService.setString(StorageService.authTokenKey, token);
    await StorageService.setString(
      StorageService.authUserKey,
      json.encode(user.toJson()),
    );
  }

  Future<void> _clearSession() async {
    await StorageService.remove(StorageService.authTokenKey);
    await StorageService.remove(StorageService.authUserKey);
  }

  Future<void> login(String username, String password) async {
    logger.userAction('login_attempt', {'username': username});
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final token = await _apiService.login(username, password);
      final user = await _apiService.getUser(1); // Get first user for demo

      await _saveSession(token, user);

      state = state.copyWith(
        token: token,
        user: user,
        status: AuthStatus.authenticated,
      );
      logger.info('AUTH', 'Login successful for: ${user.username}');
    } catch (e) {
      logger.error('AUTH', 'Login failed', e);
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final userId = await _apiService.registerUser(
        email: email,
        username: username,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      final user = User(
        id: userId,
        email: email,
        username: username,
        name: Name(firstname: firstName, lastname: lastName),
        phone: phone,
      );

      final token = 'registered_user_token_$userId';
      await _saveSession(token, user);

      state = state.copyWith(
        token: token,
        user: user,
        status: AuthStatus.authenticated,
      );
      logger.info('AUTH', 'Registration successful for: $username');
    } catch (e) {
      logger.error('AUTH', 'Registration failed', e);
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    logger.userAction('logout');
    await _clearSession();
    state = const AuthState(status: AuthStatus.unauthenticated);
    logger.info('AUTH', 'User logged out');
  }
}
