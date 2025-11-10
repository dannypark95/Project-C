import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in anonymously (automatic, no UI needed)
  Future<User?> signInAnonymously() async {
    try {
      // If already signed in, return current user
      if (_auth.currentUser != null) {
        return _auth.currentUser;
      }

      // Sign in anonymously
      final userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print('Error signing in anonymously: $e');
      return null;
    }
  }

  // Sign out (optional, for testing)
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

