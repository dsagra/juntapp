import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../core/analytics/app_analytics.dart';

class FirebaseAuthService {
  FirebaseAuthService(this._auth, this._firestore, this._analytics);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final AppAnalytics _analytics;

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges().map((user) {
      debugPrint('[AUTH] state changed uid=${user?.uid} email=${user?.email}');
      return user;
    });
  }

  User? get currentUser => _auth.currentUser;

  Future<void> signInWithGoogle() async {
    debugPrint('[LOGIN] start google sign-in');
    try {
      final provider = GoogleAuthProvider()
        ..addScope('email')
        ..setCustomParameters({'prompt': 'select_account'});

      final credentials = kIsWeb
          ? await _auth.signInWithPopup(provider)
          : await _auth.signInWithProvider(provider);

      final user = credentials.user;
      if (user == null) {
        throw StateError('No se pudo completar el acceso con Google.');
      }

      await _upsertUserProfile(user);
      await _analytics.logLoginSuccess();

      debugPrint(
        '[LOGIN] success uid=${credentials.user?.uid} email=${credentials.user?.email}',
      );
    } on FirebaseAuthException catch (e, stack) {
      await _analytics.logLoginError(e.code);
      debugPrint(
        '[LOGIN] FirebaseAuthException code=${e.code} message=${e.message}',
      );
      debugPrint('[LOGIN] stack=$stack');
      rethrow;
    } catch (e, stack) {
      debugPrint('[LOGIN] unexpected error=$e');
      debugPrint('[LOGIN] stack=$stack');
      rethrow;
    }
  }

  Future<void> _upsertUserProfile(User user) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final existing = await docRef.get();

    await docRef.set({
      'id': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
      'provider': 'google',
      if (!existing.exists) 'createdAt': Timestamp.fromDate(DateTime.now()),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    }, SetOptions(merge: true));
  }

  Future<void> signOut() async {
    debugPrint('[LOGOUT] start uid=${_auth.currentUser?.uid}');
    try {
      await _auth.signOut();
      await _analytics.logLogout();
      debugPrint('[LOGOUT] success');
    } catch (e, stack) {
      debugPrint('[LOGOUT] error=$e');
      debugPrint('[LOGOUT] stack=$stack');
      rethrow;
    }
  }
}
