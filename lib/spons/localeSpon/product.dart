import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../button.dart';
import '../../textfield.dart';
import '../Model/selection.dart';
import 'LocaleFacture.dart';

class ProductPage extends StatefulWidget {
  final LocaleSponsoringData data;
  ProductPage({required this.data});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late User? user;
  late String? userId;
  String _imageURL = '';
  File? _image;
  late TextEditingController _productNameController;
  late TextEditingController _makerNameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
    _productNameController = TextEditingController();
    _makerNameController = TextEditingController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
    _budgetController = TextEditingController();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _makerNameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final uuid = Uuid();
      final uniqueName = uuid.v4();

      final imageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('locale_product')
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
        _imageURL = imageUrl;
      });

      // Close the loading dialog
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
            color: Colors.yellow, // Change the back arrow color here
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
              padding: const EdgeInsets.all(8.0),
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
                            ? Image.asset('lib/images/box.png')
                            : null,
                      ),
                    ),
                    _image != null
                        ? Image.file(
                            _image!,
                            height: 150,
                          )
                        : SizedBox(height: 0),
                    

                    SystemTextField(
                      controller: _productNameController,
                      hintText: 'Product Name',
                    ),
                                        SizedBox(height: 20),

                    SystemTextField(
                      controller: _makerNameController,
                      hintText: 'Maker\'s Name',
                    ),
                                        SizedBox(height: 20),

                    SystemTextField(
                      controller: _priceController,
                      hintText: 'Price',
                    ),
                                        SizedBox(height: 20),

                    SystemTextField(
                      controller: _descriptionController,
                      hintText: 'Description',
                    ),
                                        SizedBox(height: 20),

                    SystemTextField(
                      controller: _budgetController,
                      hintText: 'Budget',
                    ),
                    SizedBox(height: 20),

                      SystemButton(
                        text: 'Add Product',
                        onPressed: () {
                          _formKey.currentState!.save();

                          widget.data.image = _imageURL;
                          widget.data.product = _productNameController.text;
                          widget.data.maker = _makerNameController.text;
                          widget.data.price = double.parse(_priceController.text);
                          widget.data.description = _descriptionController.text;
                          widget.data.budget = double.parse(_budgetController.text);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocaleFacturePage(
                                data: widget.data,
                                userId: userId!,
                              ),
                            ),
                          );
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
