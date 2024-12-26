import 'dart:io';

import 'package:app/button.dart';
import 'package:app/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

import '../Model/selection.dart';
import 'localeplacefacture.dart';

class LocalePlacePage extends StatefulWidget {
  final LocaleSponsoringData data;
  LocalePlacePage({required this.data});

  @override
  _LocalePlacePageState createState() => _LocalePlacePageState();
}

class _LocalePlacePageState extends State<LocalePlacePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late User? user;
  late String? userId;
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _placeTypeController = TextEditingController();
  String _imageURL = '';
  File? _image;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final uuid = Uuid();
      final uniqueName = uuid.v4();

      final imageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('locale_place')
          .child('$uniqueName.jpg');

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
        _imageURL = imageUrl;
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapped outside of the TextField
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.white, // Change the back arrow color here
            size: 50,
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'lib/images/er.jpeg', // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.blueAccent,
                        backgroundImage: _imageURL.isNotEmpty
                            ? NetworkImage(_imageURL)
                            : null,
                        child: _imageURL.isEmpty
                            ? Image.asset('lib/images/shop.png')
                            : null,
                      ),
                    ),
                    _image != null
                        ? Image.file(
                            _image!,
                            height: 150,
                          )
                        : SizedBox(height: 10),
                  //  SystemButton(text: 'Select Image', onPressed: _pickImage),
                    SizedBox(height: 20),
                    SystemTextField(
                        controller: _placeNameController,
                        hintText: 'Place Name'),
                    SizedBox(height: 20),
                    SystemTextField(
                        controller: _descriptionController,
                        hintText: 'Please enter your description'),
                    SizedBox(height: 20),
                    SystemTextField(
                        controller: _placeTypeController,
                        hintText: 'Place Type'),
                    SizedBox(height: 50),
                    SystemButton(
                      text: 'Add Place',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          widget.data.image = _imageURL;
                          widget.data.placeName = _placeNameController.text;
                          widget.data.description = _descriptionController.text;
                          widget.data.placetype = _placeTypeController.text;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocalePlaceFacture(
                                data: widget.data,
                                userId: userId!,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
