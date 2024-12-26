import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Admin/navbar.dart';
import '../navbar.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _currentUser; // create a variable to hold the current user

  @override
  void initState() {
    super.initState();
    // get the currently signed-in user and store their information
    _currentUser = _auth.currentUser!;
    // update the user's online status to true when they log in
  }

  Future<String> getUserRole() async {
    final id = FirebaseAuth.instance.currentUser!.uid;
    final user =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    if (user.id == _currentUser.uid) {
      // check the uid of the current user
      return user.data()!['role'];
    }
    return 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final role = snapshot.data;

          print('UserSSSSS role: $role');

          if (role == 'admin') {
            return Adminnavbar();
          } else if (role == 'user') {
            return navbar();
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Image.asset(
                  'lib/images/reach.png', // Replace with the actual image path
                  width: 200, // Adjust the width as per your requirements
                  height: 200, // Adjust the height as per your requirements
                ),
              ),
            );
          }
        }
      },
    );
  }
}
