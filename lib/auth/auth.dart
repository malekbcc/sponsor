import 'package:app/auth/rootPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../welcome/AnimatedScreen.dart';

class Auth extends StatelessWidget {
  const Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RootPage(); // Capitalized to match the class name
          } else {
            return AnimatedScreen();
          }
        },
      ),
    );
  }
}
