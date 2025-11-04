import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'api_client.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<String?> get getIdToken async {
    return await firebaseAuth.currentUser?.getIdToken(true);
  }

  Future<void> _syncUserWithBackend() async {
    try {
      final token = await getIdToken;
      if (token == null) return;
      await ApiClient.post("/api/auth/ensureUser", {});
    } catch (_) {}
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final cred=  await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _syncUserWithBackend();
    return cred;
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    final cred= await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _syncUserWithBackend();
    return cred;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
