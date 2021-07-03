import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class SignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  static const ROOT = 'http://10.0.2.2:80/user_actions.php';
  static const CREATE_TABLE_ACTION = 'CREATE_USERS_TABLE';
  static const GET_ALL_FB_USERS_ACTION = 'GET_ALL_FIREBASE_EMAILS';
  static const ADD_USER_ACTION = 'ADD_USER';
  static const LINK_FIREBASE_ACTION = 'LINK_FIREBASE';
  static const UNLINK_FIREBASE_ACTION = 'UNLINK_FIREBASE';
  static const USER_EXISTS_ACTION = 'EXISTS';
  static const AUTH_USER_ACTION = 'AUTH_USER';

  Future<Map<String, dynamic>?> customLoginCredential(
      {required String email,
      required String password,
      bool signUp = false}) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = AUTH_USER_ACTION;
      map['email'] = email;
      map['password'] = password;
      map['sign_up'] = signUp;

      print("-----MAP-----");
      print(jsonEncode(map));

      final response = await http.post(Uri.parse(ROOT), body: map);
      print("-----RES-----");
      print(response.body);
      print("-----RES-----");
      Map<String, dynamic> credential = {};
      credential["success"] = jsonDecode(response.body)["success"];
      credential["error"] = jsonDecode(response.body)["error"];
      credential["message"] = jsonDecode(response.body)["message"];
      credential["email"] = jsonDecode(response.body)["email"];
      credential["token"] = jsonDecode(response.body)["auth_token"];
      print("-----CRED-----");
      print(credential);

      if (credential["success"] == 'false') {
        print("Error: " + credential["error"]);
        print("Message: " + credential["message"]);
        return null;
      }
      return credential;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> customLogin(
      {bool signUp = false,
      required String email,
      required String password}) async {
    try {
      // TODO REMOVE, JUST FOR TESTING
      email = "example@email.com";
      password = "test123";

      final signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      var userExists = signInMethods.isEmpty;

      var map = Map<String, dynamic>();
      map['action'] = USER_EXISTS_ACTION;
      map['email'] = email;
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (jsonDecode(response.body)["success"])
        userExists = userExists || jsonDecode(response.body)["firebase_exists"];

      print("User Exists: " + userExists.toString());

      if (signUp ^ !userExists) {
        // sign_in   empty    cancel (Can't sign in, user doesn't exist)
        // sign_in  !empty    continue
        // sign_up   empty    continue
        // sign_up  !empty    cancel (Can't sign up, user exists)
        // TODO Prompt User to sign in or sign up instead
        return true;
      }

      Map<String, dynamic>? credential = await customLoginCredential(
        email: email,
        password: password,
      );
      if (credential == null) return true;

      await FirebaseAuth.instance.signInWithCustomToken(credential["token"]);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
    return false;
  }

  Future customLink({required String email, required String password}) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = LINK_FIREBASE_ACTION;
      map['email'] = email;
      map['password'] = password;
      map['firebase_uid'] = FirebaseAuth.instance.currentUser!.uid;

      print("-----MAP-----");
      print(jsonEncode(map));

      final response = await http.post(Uri.parse(ROOT), body: map);
      print("-----RES-----");
      print(response.body);
      print("-----RES-----");
      Map<String, dynamic> credential = {};
      credential["success"] = jsonDecode(response.body)["success"];
      credential["error"] = jsonDecode(response.body)["error"];
      credential["message"] = jsonDecode(response.body)["message"];
      print("-----CRED-----");
      print(credential);

      if (credential["success"] == 'false') {
        print("Error: " + credential["error"]);
        print("Message: " + credential["message"]);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
    try {
      // TODO REMOVE, JUST FOR TESTING
      email = "example@email.com";
      password = "test123";

      AuthCredential? credential = await googleLoginCredential();
      if (credential == null) return;
      await FirebaseAuth.instance.currentUser!.linkWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

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
      if (credential == null) return true;

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
      if (credential == null) return true;

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
