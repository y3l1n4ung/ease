import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  FadePageRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final SlideDirection direction;

  SlidePageRoute({
    required this.child,
    this.direction = SlideDirection.right,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final begin = switch (direction) {
              SlideDirection.right => const Offset(1.0, 0.0),
              SlideDirection.left => const Offset(-1.0, 0.0),
              SlideDirection.up => const Offset(0.0, 1.0),
              SlideDirection.down => const Offset(0.0, -1.0),
            };

            final tween = Tween(begin: begin, end: Offset.zero).chain(
              CurveTween(curve: Curves.easeInOut),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}

enum SlideDirection { right, left, up, down }

class ScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  ScalePageRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween(begin: 0.9, end: 1.0).chain(
              CurveTween(curve: Curves.easeOut),
            );

            return ScaleTransition(
              scale: animation.drive(tween),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}

CustomTransitionPage<T> fadeTransitionPage<T>({
  required Widget child,
  LocalKey? key,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

CustomTransitionPage<T> slideTransitionPage<T>({
  required Widget child,
  LocalKey? key,
  SlideDirection direction = SlideDirection.right,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = switch (direction) {
        SlideDirection.right => const Offset(1.0, 0.0),
        SlideDirection.left => const Offset(-1.0, 0.0),
        SlideDirection.up => const Offset(0.0, 1.0),
        SlideDirection.down => const Offset(0.0, -1.0),
      };

      final tween = Tween(begin: begin, end: Offset.zero).chain(
        CurveTween(curve: Curves.easeInOut),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
