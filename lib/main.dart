import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_test_million/page/home_page.dart';
import 'package:firebase_test_million/provider/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: HomePage(),
      ),
    );
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   List userList = [];
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   void getUsers() async {
//     DocumentReference _userDocumentReference = FirebaseFirestore.instance
//         .collection("user")
//         .doc("eohm2VZlvjs2Ub99NT4O");
//     CollectionReference _recentsCollectionReference =
//         _userDocumentReference.collection("recents");
//
//     DocumentSnapshot user = await _userDocumentReference.get();
//     QuerySnapshot recents = await _recentsCollectionReference.get();
//     print(user.data());
//     if (recents.docs.length != 0)
//       for (var doc in recents.docs) {
//         print(doc.data());
//         userList.add(doc.data());
//       }
//   }
//
//   void _update() {
//     print("-----------------------------------------------------");
//     getUsers();
//     setState(() {
//       _counter++;
//     });
//   }
//
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('You have pushed the button this many times:'),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _update,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
