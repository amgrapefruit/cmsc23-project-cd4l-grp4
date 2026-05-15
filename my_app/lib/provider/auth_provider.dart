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
  Future<String?> signUpWithEmailAndPassword(String email, String password, String name) async {
    String? error = await authService.signUp(email, password, name);
    notifyListeners();

    return error;
  }

  // log in with email and password
  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    String? error = await authService.signInUsingEmailAndPassword(email, password);
    notifyListeners();

    if (error == null) {
      return validateProfile(authService.currentUserId!); 
    }

    return error;
  }

  // sign in with google
  Future<String?> signInWithGoogle() async {
    String? error = await authService.signInUsingGoogle();
    notifyListeners();
    
    if (error == null) {
      return validateProfile(authService.currentUserId!); 
    }

    return error;
  }

  // sign in with Facebook
  Future<String?> signInWithFacebook() async {
    String? error = await authService.signInUsingFacebook();
    notifyListeners();

    if (error == null) {
      return validateProfile(authService.currentUserId!); 
    }

    return error;
  }
  
  Future<void> signOut() async {
    await authService.signOut();
    notifyListeners();
  }

  // validate profile completion and verification status
  Future<String?> validateProfile(String uid) async {
    String? verificationError = await authService.checkVerificationStatus(uid);
    if (verificationError != null) {
      return verificationError;
    }

    String? profileError = await authService.checkUserProfileComplete(uid);
    if (profileError != null) {
      return profileError;
    }

    return null;
  }

  // push correct verification or interest selection screen based on profile completion and verification status
  void handleSignInError(BuildContext context, String? error) {
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );

      if (error == 'Please fill up the incomplete details in your profile to continue') {
        Navigator.pushNamed(context, '/interests');
        return;
      }

      else if (error == 'User not yet verified') {
        Navigator.pushNamed(context, '/verification');
        return;
      }

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account logged in')),
    );
  }
}