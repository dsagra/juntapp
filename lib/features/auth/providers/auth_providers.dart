import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/analytics_providers.dart';
import '../../../core/providers/firebase_providers.dart';
import '../services/firebase_auth_service.dart';

final authServiceProvider = Provider<FirebaseAuthService>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firestoreProvider);
  final analytics = ref.watch(appAnalyticsProvider);
  return FirebaseAuthService(auth, firestore, analytics);
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authServiceProvider).currentUser;
});
