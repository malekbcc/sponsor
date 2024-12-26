// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../auth/component/button.dart';

class updateProfile extends StatefulWidget {
  final VoidCallback onUpdateProfile;
  updateProfile({required this.onUpdateProfile});

  @override
  State<updateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<updateProfile> {
  late User user;
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController number = TextEditingController();
  String? pimage;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          firstname.text = doc.data()!['firstname'];
          lastname.text = doc.data()!['lastname'];
          number.text = doc.data()!['number'];
          pimage = doc.data()!['image'];
        });
      }
    });
  }

  @override
  void dispose() {
    firstname.dispose();
    lastname.dispose();
    number.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final imageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');

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

      final uploadTask = imageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});

      final imageUrl = await imageRef.getDownloadURL();
      setState(() {
        pimage = imageUrl;
      });

      Navigator.pop(context);
    }
  }

  void saveProfile() {
    if (_formkey.currentState!.validate()) {
      FirebaseFirestore.instance.collection("users").doc(user.uid).update({
        "firstname": firstname.text,
        "lastname": lastname.text,
        "number": number.text,
        "image": pimage
      }).then((_) {
        widget.onUpdateProfile();
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Update Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 100, left: 20, right: 20),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 5,
                          color: Color.fromARGB(255, 29, 217, 226),
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            pimage != null ? NetworkImage(pimage!) : null,
                        child: pimage == null
                            ? Icon(Icons.person, size: 80)
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: firstname,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'First name is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'First Name',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: lastname,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Number is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Telephone',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  MyButton(
                    text: "Save",
                    onTap: saveProfile,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
