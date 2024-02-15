import 'package:away_review/core/auth/firebase_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  AuthService(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user == null) {
        throw Exception('No user found for that email.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else {
        throw Exception('An error occurred while signing up.');
      }
    } catch (e) {
      throw Exception('An error occurred while signing in.');
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('No user found for that email.');
      }

      await signInWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      } else {
        throw Exception('An error occurred while signing up.');
      }
    } catch (e) {
      throw Exception('An error occurred while signing up.');
    }
  }

  Future<void> signOut() async => _firebaseAuth.signOut();

  User? get currentUser => _firebaseAuth.currentUser;
}

final authServiceProvider = Provider((ref) {
  return AuthService(ref.read(firebaseAuthProvider));
});

final signedInProvider = Provider((ref) {
  return ref.read(authServiceProvider).currentUser != null;
});
