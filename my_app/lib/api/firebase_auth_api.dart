import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:my_app/model/app_users.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  String? get currentUserId => auth.currentUser?.uid;
  
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

      AppUser user = AppUser(name: name, email: email, uid: credential.user?.uid);
      addUser(user);

      return null;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      else if (e.code == 'account-exists-with-different-credential') {
        return 'You used a different sign in method for this email. Please use the correct sign in method.';
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
      await GoogleSignIn.instance.initialize();

      // Trigger the authentication flow
      final googleUser = await GoogleSignIn.instance.authenticate();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      // Once signed in, return the UserCredential
      UserCredential firebaseCredential = await auth.signInWithCredential(credential);

      // get profile data and add user document
      AppUser user = AppUser(name: googleUser.displayName, email: googleUser.email, uid: firebaseCredential.user?.uid);

      addUser(user);

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return 'You used a different sign in method for this email. Please use the correct sign in method.';
      }
      return 'Failed with error ${e.code} - ${e.message}';
    } on FirebaseException catch (e) {
      return 'Failed with error ${e.code} - ${e.message}';
    } on GoogleSignInException catch (e) {
      return 'Failed with error ${e.code} - ${e.description}';
    }  catch (e) {
      return 'Unsuccessful sign in';
    }
  }

  // sign in with Facebook
  Future<String?> signInUsingFacebook() async {
    try {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.status == LoginStatus.success) {
      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

      // sign to firebase auth and add user doc to firestore
      UserCredential firebaseCredential = await auth.signInWithCredential(facebookAuthCredential);

      // get profile data
      final userData = await FacebookAuth.instance.getUserData();
      AppUser user = AppUser(name: userData['name'], email: userData['email'], uid: firebaseCredential.user?.uid);

      addUser(user);

      return null;
    } else {
      return 'Facebook sign in failed';
    }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return 'You used a different sign in method for this email. Please use the correct sign in method.';
      }
      return 'Failed with error ${e.code} - ${e.message}';
    } on FirebaseException catch (e) {
        return 'Failed with error ${e.code} - ${e.message}';
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
  Future<String?> addUser(AppUser user) async {
    try {
      await db.collection('users').doc(user.uid).set(user.toJson());
      return null;
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // check user verification status
  Future<String?> checkVerificationStatus(String uid) async {
    try {
      DocumentSnapshot doc = await db.collection('users').doc(uid).get();

      if (doc.get('isVerified')) {
        return null;
      }
      else {
        return "User not yet verified";
      }
    } on FirebaseException catch (e) {
      return ("Failed with error '${e.code}: ${e.message}");
    }
  }

  // check if user tags, role preferences, and food interests status are complete
  Future<String?> checkUserProfileComplete(String uid) async {
    try {
      DocumentSnapshot doc = await db.collection('users').doc(uid).get();

      if (doc.get('dietaryTags').length > 0 && doc.get('foodInterests') && doc.get('rolePreference') != null) {
        return null;
      }
      else {
        return "Please fill up the incomplete details in your profile to continue";
      }
    } on FirebaseException catch (e) {
      return ("Failed with error '${e.code}: ${e.message}");
    }
  }
}