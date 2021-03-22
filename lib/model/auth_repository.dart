import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;

String get currentUid => _auth.currentUser?.uid ?? '';

Stream<bool> get authSteam =>
    _auth.authStateChanges().map((user) => user != null);

Future<void> signOut() => _auth.signOut();

Future<UserCredential> signIn() {
  final googleProvider = GoogleAuthProvider();
  return _auth.signInWithPopup(googleProvider);
}
