import 'package:firebase_test_million/generated/l10n.dart';
import 'package:firebase_test_million/provider/auth_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomLogInWidget extends StatefulWidget {
  final signUp;

  const CustomLogInWidget({Key? key, this.signUp = false}) : super(key: key);

  @override
  _CustomLogInWidgetState createState() => _CustomLogInWidgetState();
}

class _CustomLogInWidgetState extends State<CustomLogInWidget> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget _buildEmailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ]),
          height: 60,
          child: TextFormField(
            controller: usernameController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: [AutofillHints.email],
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.email,
              ),
              hintText: 'Enter your Email',
            ),
            validator: (value) {
              // if (value == null || value.isEmpty)
              //   return "Please enter some text";
              return null; // Null means success
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ]),
          height: 60,
          child: TextFormField(
            controller: passwordController,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            autofillHints: [AutofillHints.password],
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.lock,
              ),
              hintText: 'Enter your Password',
              // hintStyle: kHintTextStyle,
            ),
            validator: (value) {
              // if (value == null || value.isEmpty)
              //   return "Please enter some text";
              return null; // Null means success
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 25.0,
      ),
      width: double.infinity,
      child: ElevatedButton(
        // elevation: 5.0,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        onPressed: () {
          bool isValid = _formKey.currentState!.validate();
          print("Form Valid: " + isValid.toString());
          if (!isValid) {
            // Error in validation
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Validation Error!"),
            ));
            return;
          }

          print(widget.signUp ? "Sign Up Mode" : "Sign In Mode");
          final provider = Provider.of<SignInProvider>(context, listen: false);
          provider
              .customLogin(
            signUp: widget.signUp,
            email: usernameController.text,
            password: passwordController.text,
          )
              .then((value) {
            if (!value) {
              Navigator.of(context).pop();
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'LOGIN',
            style: TextStyle(
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 40.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Text(
                S.of(context).CustomSignIn,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: _formKey,
              child: Column(
                children: [
                  _buildEmailTextField(),
                  SizedBox(height: 20),
                  _buildPasswordTextField(),
                  _buildLoginButton(),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
