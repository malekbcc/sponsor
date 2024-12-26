import 'package:app/Admin/FactureList/ListOfFatcure.dart';
import 'package:app/Admin/UserList/userlist.dart';
import 'package:app/button.dart';
import 'package:app/chatbot/chat.dart';
import 'package:app/profile/profile.dart';
import 'package:app/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final User user = FirebaseAuth.instance.currentUser!;

  Future<Map<String, dynamic>> getUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return userDoc.data() as Map<String, dynamic>;
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                signOut();
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: signOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SystemButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllUsersPage(),
                  ),
                );
              },
              text: 'accounts',
            ),
            SizedBox(height: 20), // Add some space between buttons
            SystemButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FactureList(),
                  ),
                );
              },
              text: 'invoice',
            ),
            SizedBox(height: 20), // Add some space between buttons
            SystemButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => profile(
                      userId: user.uid,
                    ),
                  ),
                );
              },
              text: 'profile',
            ),
          ],
        ),
      ),
    );
  }
}
