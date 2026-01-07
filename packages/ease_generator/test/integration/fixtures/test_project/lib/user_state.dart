import 'package:ease_annotation/ease_annotation.dart';
import 'package:ease_state_helper/ease_state_helper.dart';
import 'package:flutter/widgets.dart';

part 'user_state.ease.dart';

/// User data model.
class User {
  final String name;
  final String email;

  const User({required this.name, required this.email});

  User copyWith({String? name, String? email}) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}

/// User state management for testing.
@ease
class UserState extends StateNotifier<User?> {
  UserState() : super(null);

  void login(String name, String email) {
    state = User(name: name, email: email);
  }

  void logout() => state = null;

  void updateName(String name) {
    if (state != null) {
      state = state!.copyWith(name: name);
    }
  }
}
