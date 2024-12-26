import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

class Signup extends StatefulWidget {
  final Function()? onTap;
  const Signup({super.key, required this.onTap});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final numberController = TextEditingController();
  final regionController = TextEditingController();
  String? pimage;
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final uuid = Uuid();
      final uniqueName = uuid.v4();

      final imageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$uniqueName.jpg');
      // Show loading dialog while the image is being uploaded
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text('Uploading image...'),
                ],
              ),
            ),
          );
        },
      );

      await imageRef.putFile(imageFile);
      final imageUrl = await imageRef.getDownloadURL();
      setState(() {
        pimage = imageUrl;
      });

      // Close the loading dialog
      Navigator.pop(context);
    }
  }

  void signup() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        // Check if pimage is null, if it is, pass the default image URL
        String imageUrl = pimage != null
            ? pimage!
            : 'https://firebasestorage.googleapis.com/v0/b/what-5626b.appspot.com/o/profile_images%2F07c2caa1-da41-4e26-80aa-7a500d89c446.jpg?alt=media&token=040a189a-cf39-4211-a24e-e84723b68f63';
        addUserDetails(
          nameController.text.trim(),
          lastnameController.text.trim(),
          emailController.text.trim(),
          numberController.text.trim(),
          regionController.text.trim(),
          imageUrl, // Pass imageUrl here
        );
      } else {
        showErrorMessage("password incorrect please try again");
      }
      Navigator.pop(context); // Dismiss progress dialog after successful login

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.purple,
            title: Center(
              child: Text(
                message,
                style: TextStyle(color: Color.fromARGB(255, 208, 255, 0)),
              ),
            ),
          );
        });
  }

  void addUserDetails(String firstname, String lastname, String email,
      String number, String region, String Image) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'role': 'user',
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'number': number,
      'region': region,
      'image': Image, // Use Image parameter here
    });
  }

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'lib/images/uu.jpeg', // Replace with your image path
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 5),

                        const SizedBox(height: 25),

                        Text(
                          'Let\'s create an account for you!',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),

                        GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  pimage != null ? NetworkImage(pimage!) : null,
                              child: pimage == null
                                  ? Image.asset(
                                      'lib/images/homme.png',
                                    )
                                  : null,
                            )),
                        const SizedBox(height: 25),

                        // first name textfield
                        Container(
                          width: 260,
                          height: 60,
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: "First name",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        // last name textfield
                        Container(
                          width: 260,
                          height: 60,
                          child: TextField(
                            controller: lastnameController,
                            decoration: InputDecoration(
                              labelText: "Last name",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),

                        // email textfield
                        Container(
                          width: 260,
                          height: 60,
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),

                        // password textfield
                        Container(
                          width: 260,
                          height: 60,
                          child: TextField(
                            controller: passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                child: Icon(
                                  _isPasswordVisible
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  color: Colors.red,
                                ),
                              ),
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),

                        // confirm password textfield
                        Container(
                          width: 260,
                          height: 60,
                          child: TextField(
                            controller: confirmPasswordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                child: Icon(
                                  _isPasswordVisible
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  color: Colors.red,
                                ),
                              ),
                              labelText: "Confirm Password",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),

                        Container(
                          width: 260,
                          height: 60,
                          child: TextField(
                            controller: numberController,
                            decoration: InputDecoration(
                              labelText: "Mobile Number",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),

                        Container(
                          width: 260,
                          height: 60,
                          child: TextField(
                            controller: regionController,
                            decoration: InputDecoration(
                              labelText: "Region",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),

                        const SizedBox(height: 25),

                        // sign in button
                        GestureDetector(
                          onTap: signup,
                          child: Container(
                            alignment: Alignment.center,
                            width: 250,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFF8A2387),
                                  Color(0xFFE94057),
                                  Color(0xFFF27121),
                                ],
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        const SizedBox(height: 5),

                        // or continue with
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  'Or continue with',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // not a member? register now
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: const Text(
                                'Login now',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
