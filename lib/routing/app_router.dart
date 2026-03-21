import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/signup_page.dart';
import '../features/auth/providers/auth_providers.dart';
import '../features/dashboard/pages/dashboard_page.dart';
import '../features/events/pages/create_event_page.dart';
import '../features/events/pages/event_detail_page.dart';
import '../features/participants/pages/participants_page.dart';
import '../features/payments/pages/payments_review_page.dart';
import '../features/public_event/pages/public_event_page.dart';
import '../features/public_event/pages/upload_receipt_page.dart';
import '../features/public_event/pages/upload_success_page.dart';
import 'go_router_refresh_stream.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authServiceProvider).authStateChanges();

  return GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: GoRouterRefreshStream(authState),
    redirect: (context, state) {
      final user = ref.read(currentUserProvider);
      final path = state.uri.path;
      final isPublic = path.startsWith('/e/');
      final isLogin = path == '/login';
      final isSignUp = path == '/signup';

      debugPrint(
        '[AUTH_ROUTER] path=$path uid=${user?.uid} isPublic=$isPublic isLogin=$isLogin isSignUp=$isSignUp',
      );

      if (isPublic) return null;
      if (user == null && !isLogin && !isSignUp) {
        debugPrint('[AUTH_ROUTER] redirect -> /login');
        return '/login';
      }
      if (user != null && (isLogin || isSignUp)) {
        debugPrint('[AUTH_ROUTER] redirect -> /dashboard');
        return '/dashboard';
      }
      debugPrint('[AUTH_ROUTER] no redirect');
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/events/new',
        builder: (context, state) => const CreateEventPage(),
      ),
      GoRoute(
        path: '/events/:eventId',
        builder: (context, state) {
          final eventId = state.pathParameters['eventId']!;
          return EventDetailPage(eventId: eventId);
        },
      ),
      GoRoute(
        path: '/events/:eventId/participants',
        builder: (context, state) {
          final eventId = state.pathParameters['eventId']!;
          return ParticipantsPage(eventId: eventId);
        },
      ),
      GoRoute(
        path: '/events/:eventId/payments',
        builder: (context, state) {
          final eventId = state.pathParameters['eventId']!;
          return PaymentsReviewPage(eventId: eventId);
        },
      ),
      GoRoute(
        path: '/e/:slug',
        builder: (context, state) {
          final slug = state.pathParameters['slug']!;
          return PublicEventPage(slug: slug);
        },
      ),
      GoRoute(
        path: '/e/:slug/upload',
        builder: (context, state) {
          final slug = state.pathParameters['slug']!;
          return UploadReceiptPage(slug: slug);
        },
      ),
      GoRoute(
        path: '/e/:slug/success',
        builder: (context, state) {
          final slug = state.pathParameters['slug']!;
          return UploadSuccessPage(slug: slug);
        },
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(child: Text('Ruta no encontrada: ${state.uri.path}')),
      );
    },
  );
});
