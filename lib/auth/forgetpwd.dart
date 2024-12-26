import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'component/button.dart';
import 'component/text.dart';


class forgetpwd extends StatefulWidget {
  const forgetpwd({super.key});

  @override
  State<forgetpwd> createState() => _forgetpwdState();
}

class _forgetpwdState extends State<forgetpwd> {
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future forgetpwd() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('password reset link sent'),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Please enter your email to reset your password"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
          ),
          MyButton(
            text: "submit",
            onTap: forgetpwd,
          ),
        ],
      ),
    );
  }
}
