import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test_million/provider/auth_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoggedInWidget extends StatefulWidget {
  const LoggedInWidget({Key? key}) : super(key: key);

  @override
  _LoggedInWidgetState createState() => _LoggedInWidgetState();
}

class _LoggedInWidgetState extends State<LoggedInWidget> {
  var user = FirebaseAuth.instance.currentUser!;

  // TODO Remove
  List userList = [];
  int _counter = 0;

  void _update() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logged In"),
        centerTitle: true,
        actions: [
          TextButton(
            child: Text("Logout"),
            onPressed: () {
              final provider =
                  Provider.of<SignInProvider>(context, listen: false);
              provider.logout();
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Profile",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 32),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.photoURL ?? ''),
            ),
            SizedBox(height: 8),
            Text(
              "Name: " + (user.displayName ?? 'null'),
            ),
            SizedBox(height: 8),
            Text(
              "Email: " +
                  (user.email ?? 'null') +
                  " | " +
                  (user.emailVerified ? "Verified" : "Not Verified"),
            ),
            SizedBox(height: 8),
            Text(
              "Linked Accounts: ",
            ),
            for (var prov in user.providerData)
              Text(prov.providerId + ": " + prov.email.toString()),
            SizedBox(height: 8),
            Text("$_counter"),
            SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              icon: FaIcon(FontAwesomeIcons.google),
              label: Text("Link Google Account"),
              onPressed: () {
                final provider =
                    Provider.of<SignInProvider>(context, listen: false);
                provider.googleLink().then((value) {
                  setState(() {
                    user = FirebaseAuth.instance.currentUser!;
                  });
                });
              },
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              icon: FaIcon(FontAwesomeIcons.google),
              label: Text("Unlink Google Account"),
              onPressed: () {
                user.unlink("google.com").then((value) {
                  final provider =
                      Provider.of<SignInProvider>(context, listen: false);
                  provider.googleSignIn.disconnect().then((value) {
                    setState(() {
                      user = FirebaseAuth.instance.currentUser!;
                    });
                  });
                });
              },
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              icon: FaIcon(FontAwesomeIcons.facebook),
              label: Text("Link Facebook Account"),
              onPressed: () {
                final provider =
                    Provider.of<SignInProvider>(context, listen: false);
                provider.facebookLink().then((value) {
                  setState(() {
                    user = FirebaseAuth.instance.currentUser!;
                  });
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _update,
        tooltip: "Increment Counter",
        child: Icon(Icons.add),
      ),
    );
  }
}
