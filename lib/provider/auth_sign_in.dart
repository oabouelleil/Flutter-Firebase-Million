import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future facebookLogin() async {
    try {
      // enum LoginStatus { success, cancelled, failed, operationInProgress }
      final LoginResult loginResult = await FacebookAuth.instance.login(
        // developers.facebook.com/docs/permissions/reference
        permissions: [
          "email",
          "public_profile",
        ],
      );

      switch (loginResult.status) {
        case (LoginStatus.cancelled):
          print("Facebook Login Cancelled");
          print(loginResult.message);
          return;
        case (LoginStatus.failed):
          print("Facebook Login Failed");
          print(loginResult.message);
          return;
        case (LoginStatus.operationInProgress):
          print("Facebook Login Operation In Progress");
          print(loginResult.message);
          return;
        default:
      }

      // Print Access Token TODO Remove
      print(loginResult.accessToken!.toJson());

      final facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future logout() async {
    if (await googleSignIn.isSignedIn()) await googleSignIn.disconnect();
    if (await FacebookAuth.instance.accessToken != null)
      await FacebookAuth.instance.logOut();
    FirebaseAuth.instance.signOut();
  }
}
