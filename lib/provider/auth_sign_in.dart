import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  Future<AuthCredential?> googleLoginCredential() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return credential;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> googleLogin({bool signUp = false}) async {
    try {
      AuthCredential? credential = await googleLoginCredential();
      if (credential == null) return false;

      final signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(googleSignIn.currentUser!.email);
      if (signUp ^ signInMethods.isEmpty) {
        // sign_in   empty    cancel (Can't sign in, user doesn't exist)
        // sign_in  !empty    continue
        // sign_up   empty    continue
        // sign_up  !empty    cancel (Can't sign up, user exists)
        googleSignIn.disconnect();
        // TODO Prompt User to sign in or sign up instead
        return true;
      }

      await FirebaseAuth.instance.signInWithCredential(credential);
      // FirebaseAuth.instance.
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
    return false;
  }

  Future googleLink() async {
    try {
      AuthCredential? credential = await googleLoginCredential();
      if (credential == null) return;
      await FirebaseAuth.instance.currentUser!.linkWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<AuthCredential?> facebookLoginCredential() async {
    try {
      // enum LoginStatus { success, cancelled, failed, operationInProgress }
      final LoginResult loginResult = await FacebookAuth.instance.login(
        // developers.facebook.com/docs/permissions/reference
        permissions: [
          "email",
          "public_profile",
        ],
        loginBehavior: LoginBehavior.dialogOnly,
      );

      switch (loginResult.status) {
        case (LoginStatus.cancelled):
          print("Facebook Login Cancelled");
          print(loginResult.message);
          return null;
        case (LoginStatus.failed):
          print("Facebook Login Failed");
          print(loginResult.message);
          return null;
        case (LoginStatus.operationInProgress):
          print("Facebook Login Operation In Progress");
          print(loginResult.message);
          return null;
        default:
      }

      final credential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      return credential;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> facebookLogin({bool signUp = false}) async {
    try {
      AuthCredential? credential = await facebookLoginCredential();
      if (credential == null) return false;

      final signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail((await FacebookAuth.instance
              .getUserData(fields: "email"))["email"]);
      if (signUp ^ signInMethods.isEmpty) {
        // sign_in   empty    cancel (Can't sign in, user doesn't exist)
        // sign_in  !empty    continue
        // sign_up   empty    continue
        // sign_up  !empty    cancel (Can't sign up, user exists)
        FacebookAuth.instance.logOut();
        return true;
      }

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
    return false;
  }

  Future facebookLink() async {
    try {
      AuthCredential? credential = await facebookLoginCredential();
      if (credential == null) return;
      await FirebaseAuth.instance.currentUser!.linkWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future logout() async {
    if (await googleSignIn.isSignedIn()) await googleSignIn.disconnect();
    if (await FacebookAuth.instance.accessToken != null) {
      await FacebookAuth.instance.logOut();
    }
    FirebaseAuth.instance.signOut();
  }
}
