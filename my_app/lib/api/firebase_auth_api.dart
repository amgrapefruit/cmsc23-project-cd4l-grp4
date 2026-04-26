import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:my_app/model/app_users.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // signs in user using email and password
  Future<String?> signInUsingEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: email, password: password);

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-credential') {
        return 'Email or password do not match';
      } else {
        return 'Failed with error ${e.code} - ${e.message}';
      }
    }
  }

  // signs up user using email and password
  Future<String?> signUp(String email, String password, String name) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      AppUser user = AppUser(name: name, email: email);
      addUser(user.toMap());

      return null;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      else if (e.code == 'unknown') {
        return """Password may not meet the following requirements: 
  - Password must contain at least 6 characters
  - Password must contain an upper case character
  - Password must contain a numeric character
  - Password must contain a non-alphanumeric character""";
      }
      else {
        return "Failed with error '${e.code}: ${e.message}'";
      }
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}'";
    }
  }

  // signs in with Google
  Future<String?> signInUsingGoogle() async {
    try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

    // Once signed in, return the UserCredential
    await auth.signInWithCredential(credential);

    // get profile data and add user document
    AppUser user = AppUser(name: googleUser.displayName, email: googleUser.email);

    addUser(user.toMap());

    return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-credential') {
        return 'Email or password do not match';
      } else {
        return 'Failed with error ${e.code} - ${e.message}';
      }
    } catch (e) {
      return 'Unsuccessful sign in';
    }
  }

  // sign in with Facebook
  Future<String?> signInWithFacebook() async {
    try {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.status == LoginStatus.success) {
      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

      // sign to firebase auth and add user doc to firestore
      await auth.signInWithCredential(facebookAuthCredential);

      // get profile data
      final userData = await FacebookAuth.instance.getUserData();
      AppUser user = AppUser(name: userData['name'], email: userData['email']);

      addUser(user.toMap());

      return null;
    } else {
      return 'Facebook sign in failed';
    }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-credential') {
        return 'Email or password do not match';
      } else {
        return 'Failed with error ${e.code} - ${e.message}';
      }
    } catch (e) {
      return 'Unsuccessful sign in';
    }
  }

  // sign out user
  Future<String?> signOut() async {
    try {
      await auth.signOut();
      return null;
    } on FirebaseAuthException catch (e) {
      return 'Failed with error ${e.code} - ${e.message}';
    }
  }

  // add user to firestore database
  Future<String?> addUser(Map<String, dynamic> user) async {
    try {
      await db.collection('users').add(user);
      return null;
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}