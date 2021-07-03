import 'package:firebase_test_million/generated/l10n.dart';
import 'package:firebase_test_million/provider/auth_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
    String flagGB = 'gb'.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    String flagES = 'es'.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
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
              S.of(context).HeyThere + "\n" + S.of(context).WelcomeBack,
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
              S.of(context).LoginToYourAccount,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Spacer(),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
            icon: FaIcon(FontAwesomeIcons.google),
            label: Text(signUp
                ? S.of(context).SignUpGoogle
                : S.of(context).SignInGoogle),
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
            label: Text(signUp
                ? S.of(context).SignUpFacebook
                : S.of(context).SignInFacebook),
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
                text: (signUp
                        ? S.of(context).SignInInstead
                        : S.of(context).SignUpInstead) +
                    " ",
                children: [
                  TextSpan(
                    text: !signUp ? S.of(context).SignUp : S.of(context).SignIn,
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
            onPressed: () {
              setState(() {
                signUp = !signUp;
              });
            },
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Text(
                  flagGB,
                  style: TextStyle(fontSize: 50),
                ),
                onPressed: () {
                  setState(() {
                    S.load(Locale('en'));
                  });
                },
              ),
              TextButton(
                child: Text(
                  flagES,
                  style: TextStyle(fontSize: 50),
                ),
                onPressed: () {
                  print(Intl.getCurrentLocale());
                  setState(() {
                    S.load(Locale('es'));
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
