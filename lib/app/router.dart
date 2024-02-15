// ignore_for_file: avoid_print

import 'package:away_review/core/auth/auth_service.dart';
import 'package:away_review/core/models/review.dart';
import 'package:away_review/features/confirm_email_sent/confirm_email_sent_screen.dart';
import 'package:away_review/features/create_review/create_review_screen.dart';
import 'package:away_review/features/home/home_screen.dart';
import 'package:away_review/features/login/login_screen.dart';
import 'package:away_review/features/register/register_screen.dart';
import 'package:away_review/features/view_review/view_review_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routesProvider = Provider((ref) {
  return [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
      routes: [
        GoRoute(
          path: 'confirm-email-sent',
          builder: (context, state) => const ConfirmEmailSentScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/review',
      builder: (context, state) => ViewReviewScreen(state.extra! as Review),
    ),
    GoRoute(
      path: '/create-review',
      pageBuilder: (context, state) {
        // Custom animation so that the `CreateReviewScreen` slides up from the bottom
        return CustomTransitionPage(
          child: const CreateReviewScreen(),
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            );
          },
        );
      },
    ),
  ];
});

/// The initial route for the app.
///
/// This is useful for testing purposes, as it allows you to set the initial route/
final initialRouteProvider = Provider((ref) {
  return '/';
});

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: ref.read(initialRouteProvider),
    observers: [
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      if (kDebugMode) _RouteObserver(),
    ],
    redirect: (context, state) {
      final signedIn = ref.watch(signedInProvider);
      final location = state.uri.toString();

      if (location == '/' && signedIn || location == '/login' && signedIn) {
        return '/home';
      }

      if (location == '/' && !signedIn || location == '/home' && !signedIn) {
        return '/login';
      }

      return null;
    },
    routes: ref.read(routesProvider),
  );
});

class _RouteObserver extends RouteObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    print('Route pushed: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    print('Route popped: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print('Route replaced: ${newRoute!.settings.name}');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    print('Route removed: ${route.settings.name}');
  }
}
