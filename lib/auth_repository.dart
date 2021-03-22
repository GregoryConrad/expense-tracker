import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;

String get currentUid => _auth.currentUser?.uid ?? '';

Future<void> signOut() => _auth.signOut();

Stream<String?> get authSteam =>
    _auth.authStateChanges().map((user) => user?.uid);
