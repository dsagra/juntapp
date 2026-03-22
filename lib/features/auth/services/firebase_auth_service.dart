import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService {
  FirebaseAuthService(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges().map((user) {
      debugPrint('[AUTH] state changed uid=${user?.uid} email=${user?.email}');
      return user;
    });
  }

  User? get currentUser => _auth.currentUser;

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    debugPrint('[LOGIN] start email=$email');
    try {
      final credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint(
        '[LOGIN] success uid=${credentials.user?.uid} email=${credentials.user?.email}',
      );
    } on FirebaseAuthException catch (e, stack) {
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

  Future<void> createAccountWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    debugPrint('[SIGNUP] start email=$email nameLength=${name.length}');

    try {
      debugPrint('[SIGNUP] creating firebase auth user...');
      final credentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credentials.user;
      if (user == null) {
        debugPrint('[SIGNUP] error: credentials.user is null');
        throw StateError('No se pudo crear la cuenta (user null).');
      }

      debugPrint('[SIGNUP] auth user created uid=${user.uid}');

      debugPrint('[SIGNUP] updating displayName...');
      await user.updateDisplayName(name);
      debugPrint('[SIGNUP] displayName updated');

      debugPrint(
        '[SIGNUP] writing user profile in firestore users/${user.uid}...',
      );
      await _firestore.collection('users').doc(user.uid).set({
        'id': user.uid,
        'email': email,
        'displayName': name,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });
      debugPrint('[SIGNUP] firestore profile created successfully');
    } on FirebaseAuthException catch (e, stack) {
      debugPrint(
        '[SIGNUP] FirebaseAuthException code=${e.code} message=${e.message}',
      );
      debugPrint('[SIGNUP] stack=$stack');
      rethrow;
    } on FirebaseException catch (e, stack) {
      debugPrint(
        '[SIGNUP] FirebaseException source=${e.plugin} code=${e.code} message=${e.message}',
      );
      debugPrint('[SIGNUP] stack=$stack');
      rethrow;
    } catch (e, stack) {
      debugPrint('[SIGNUP] unexpected error=$e');
      debugPrint('[SIGNUP] stack=$stack');
      rethrow;
    }
  }

  Future<void> signOut() async {
    debugPrint('[LOGOUT] start uid=${_auth.currentUser?.uid}');
    try {
      await _auth.signOut();
      debugPrint('[LOGOUT] success');
    } catch (e, stack) {
      debugPrint('[LOGOUT] error=$e');
      debugPrint('[LOGOUT] stack=$stack');
      rethrow;
    }
  }
}
