import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test_million/provider/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoggedInWidgetless extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;

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
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            },
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
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
              backgroundImage: NetworkImage(user.photoURL!),
            ),
            SizedBox(height: 8),
            Text(
              "Name: " + user.displayName!,
            ),
            SizedBox(height: 8),
            Text(
              "Email: " +
                  user.email! +
                  " | " +
                  (user.emailVerified ? "Verified" : "Not Verified"),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class LoggedInWidget extends StatefulWidget {
  const LoggedInWidget({Key? key}) : super(key: key);

  @override
  _LoggedInWidgetState createState() => _LoggedInWidgetState();
}

class _LoggedInWidgetState extends State<LoggedInWidget> {
  final user = FirebaseAuth.instance.currentUser!;

  // TODO Remove
  List userList = [];
  int _counter = 0;

  void getUsers() async {
    DocumentReference _userDocumentReference = FirebaseFirestore.instance
        .collection("user")
        .doc("eohm2VZlvjs2Ub99NT4O");
    CollectionReference _recentsCollectionReference =
        _userDocumentReference.collection("recents");

    DocumentSnapshot user = await _userDocumentReference.get();
    QuerySnapshot recents = await _recentsCollectionReference.get();
    print(user.data());
    if (recents.docs.length != 0)
      for (var doc in recents.docs) {
        print(doc.data());
        userList.add(doc.data());
      }
  }

  void _update() {
    print("-----------------------------------------------------");
    getUsers();
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
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            },
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
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
              backgroundImage: NetworkImage(user.photoURL!),
            ),
            SizedBox(height: 8),
            Text(
              "Name: " + user.displayName!,
            ),
            SizedBox(height: 8),
            Text(
              "Email: " +
                  user.email! +
                  " | " +
                  (user.emailVerified ? "Verified" : "Not Verified"),
            ),
            SizedBox(height: 8),
            Text("$_counter"),
            SizedBox(height: 8),
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
