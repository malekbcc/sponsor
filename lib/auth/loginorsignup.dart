import 'package:flutter/material.dart';

import 'login.dart';
import 'signup.dart';


class signinorsignup extends StatefulWidget {
  const signinorsignup({super.key});
  @override
  State<signinorsignup> createState() => _signinorsignupState();
}

class _signinorsignupState extends State<signinorsignup> {
  bool showsigninpage = true;
  void togglepages() {
    setState(() {
      showsigninpage = !showsigninpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showsigninpage == true) {
      return login(
        onTap: togglepages,
      );
    } else {
      return Signup(
        onTap: togglepages,
      );
    }
  }
}
