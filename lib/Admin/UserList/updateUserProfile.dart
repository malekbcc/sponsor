// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../auth/component/button.dart';

class UpdateUserProfilePage extends StatefulWidget {
  final String UserId;
  UpdateUserProfilePage({required this.UserId});

  @override
  _UpdateUserProfilePageState createState() => _UpdateUserProfilePageState();
}

class _UpdateUserProfilePageState extends State<UpdateUserProfilePage> {
  late User _user;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  String? _profileImageUrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _user = FirebaseAuth.instance.currentUser!;

    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.UserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          _firstNameController.text = doc.data()!['firstname'] ?? '';
          _lastNameController.text = doc.data()!['lastname'] ?? '';
          _profileImageUrl = doc.data()!['image'];
        });
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
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

      final uploadTask = imageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});

      final imageUrl = await imageRef.getDownloadURL();
      setState(() {
        _profileImageUrl = imageUrl;
      });

      // Close the loading dialog
      Navigator.pop(context);
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('users').doc(_user.uid).update({
        'firstname': _firstNameController.text,
        'lastname': _lastNameController.text,
        'image': _profileImageUrl
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('update profile')),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 5),

                const SizedBox(height: 25),
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
                      backgroundImage: _profileImageUrl != null
                          ? NetworkImage(_profileImageUrl!)
                          : null,
                      child:
                          _profileImageUrl == null ? Icon(Icons.person) : null,
                    ),
                  ),
                ),

                // first name textfield
                TextFormField(
                  controller: _firstNameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'first name is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'First Name',
                  ),
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                // last name textfield
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Last Name',
                  ),
                  controller: _lastNameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Last name is required';
                    }
                    return null;
                  },
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                // email textfield

                const SizedBox(height: 10),

                const SizedBox(height: 5),

                MyButton(
                  text: "valider",
                  onTap: _saveProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
