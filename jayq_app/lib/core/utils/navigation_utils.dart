import 'package:flutter/material.dart';

/// Utility class untuk navigasi
class NavigationUtils {
  // Push to new screen
  static Future<T?> push<T>(BuildContext context, Widget screen) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Push and replace current screen
  static Future<T?> pushReplacement<T>(BuildContext context, Widget screen) {
    return Navigator.pushReplacement<T, void>(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Push and remove all previous screens
  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context,
    Widget screen, {
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      MaterialPageRoute(builder: (context) => screen),
      predicate ?? (route) => false,
    );
  }

  // Pop current screen
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  // Pop until specific route
  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  // Pop until root
  static void popToRoot(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  // Can pop (check if can go back)
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  // Push with slide transition
  static Future<T?> pushWithSlide<T>(
    BuildContext context,
    Widget screen, {
    SlideDirection direction = SlideDirection.right,
  }) {
    return Navigator.push<T>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin;
          switch (direction) {
            case SlideDirection.left:
              begin = const Offset(-1.0, 0.0);
              break;
            case SlideDirection.right:
              begin = const Offset(1.0, 0.0);
              break;
            case SlideDirection.up:
              begin = const Offset(0.0, -1.0);
              break;
            case SlideDirection.down:
              begin = const Offset(0.0, 1.0);
              break;
          }

          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  // Push with fade transition
  static Future<T?> pushWithFade<T>(BuildContext context, Widget screen) {
    return Navigator.push<T>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  // Push with scale transition
  static Future<T?> pushWithScale<T>(BuildContext context, Widget screen) {
    return Navigator.push<T>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOut;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return ScaleTransition(scale: animation.drive(tween), child: child);
        },
      ),
    );
  }

  // Push named route
  static Future<T?> pushNamed<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  // Push named and replace
  static Future<T?> pushReplacementNamed<T, TO extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(
      context,
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  // Push named and remove until
  static Future<T?> pushNamedAndRemoveUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }
}

enum SlideDirection { left, right, up, down }
