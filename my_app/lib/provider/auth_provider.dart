import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/firebase_auth_api.dart';

class AuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> uStream;
  User? userObj;

  // initiate authentication service
  AuthProvider() {
    authService = FirebaseAuthAPI();
    fetchAuthentication();
  }

  Stream<User?> get userStream => uStream;

  void fetchAuthentication() {
    uStream = authService.getUser();

    notifyListeners();
  }
  
  // sign up with email and password
  Future<String?> signUp(String email, String password, String name) async {
    String? error = await authService.signUp(email, password, name);
    notifyListeners();

    return error;
  }

  // log in with email and password
  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    String? error = await authService.signInUsingEmailAndPassword(email, password);
    notifyListeners();

    return error;
  }

  // sign in with google
  Future<String?> loginWithGoogle() async {
    String? error = await authService.signInUsingGoogle();
    notifyListeners();

    return error;
  }

  // sign in with Facebook
  Future<String?> loginWithFacebook() async {
    String? error = await authService.signInWithFacebook();
    notifyListeners();

    return error;
  }
  
  Future<void> signOut() async {
    await authService.signOut();
    notifyListeners();
  }
}