import 'package:firebase_test_million/provider/auth_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  bool signUp = false;

  void handleExists(BuildContext context, bool value) {
    if (value) {
      final snackBar = SnackBar(
        content: Text(!signUp
            ? "You don't have an account, Sign up instead!"
            : "You already have an account, Sign in instead!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          FlutterLogo(size: 120),
          Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Hey There,\nWelcome Back",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Login to your account",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Spacer(),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
            icon: FaIcon(FontAwesomeIcons.google),
            label: Text("Sign " + (signUp ? "Up" : "In") + " with Google"),
            onPressed: () {
              final provider =
                  Provider.of<SignInProvider>(context, listen: false);
              provider
                  .googleLogin(signUp: signUp)
                  .then((value) => handleExists(context, value));
            },
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
            icon: FaIcon(FontAwesomeIcons.facebook),
            label: Text("Sign " + (signUp ? "Up" : "In") + " with Facebook"),
            onPressed: () {
              final provider =
                  Provider.of<SignInProvider>(context, listen: false);
              provider
                  .facebookLogin(signUp: signUp)
                  .then((value) => handleExists(context, value));
            },
          ),
          SizedBox(height: 20),
          TextButton(
            child: RichText(
                text: TextSpan(
              text: (signUp ? "Already" : "Don't") + " Have an Account? ",
              children: [
                TextSpan(
                  text: "Sign " + (!signUp ? "Up" : "In"),
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            )),
            onPressed: () {
              setState(() {
                signUp = !signUp;
              });
            },
          ),
          Spacer(),
        ],
      ),
    );
  }
}
