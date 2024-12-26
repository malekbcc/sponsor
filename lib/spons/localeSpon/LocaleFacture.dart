import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Model/selection.dart';

class LocaleFacturePage extends StatefulWidget {
  final LocaleSponsoringData data;
  final String userId;

  LocaleFacturePage({required this.data, required this.userId});

  @override
  State<LocaleFacturePage> createState() => _LocaleFacturePageState();
}

class _LocaleFacturePageState extends State<LocaleFacturePage> {
  String firstname = "";
  String lastname = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    setState(() {
      firstname = user.data()!['firstname'];
      lastname = user.data()!['lastname'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black, // Change the back arrow color here
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
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 35),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Facture Details :',
                      style: GoogleFonts.dynaPuff(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Table(
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(7),
                    },
                    children: [
                      _buildTableRow('User', '$firstname $lastname'),
                      _buildTableRow('Type', widget.data.type),
                      _buildTableRow('FirstName', widget.data.firstName),
                      _buildTableRow('LastName', widget.data.lastName),
                      _buildTableRow('Mobile Number', widget.data.mobileNumber),
                      _buildTableRow('Country', widget.data.country),
                      _buildTableRow('Address', widget.data.address),
                      _buildTableRow('Locale Type', widget.data.localeType),
                      _buildTableRow('Product', widget.data.product),
                      _buildTableRow('Maker', widget.data.maker),
                      _buildTableRow('Price', widget.data.price.toString()),
                      _buildTableRow('Description', widget.data.description),
                      _buildTableRow('Budget', widget.data.budget.toString()),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: widget.data.image.isNotEmpty
                            ? Image.network(
                                widget.data.image,
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Text(
                                  'No image selected',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Back'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _showConfirmationDialog(context);
                        },
                        child: Text('Confirm'),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm"),
          content: Text("Are you sure you want to confirm?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final String userId = _auth.currentUser!.uid;
                FirebaseFirestore.instance.collection('sponsoring').add({
                  'userId': userId,
                  'status': 'on hold',
                  'type': widget.data.type,
                  'firstName': widget.data.firstName,
                  'lastName': widget.data.lastName,
                  'mobileNumber': widget.data.mobileNumber,
                  'country': widget.data.country,
                  'address': widget.data.address,
                  'localeType': widget.data.localeType,
                  'image': widget.data.image,
                  'product': widget.data.product,
                  'maker': widget.data.maker,
                  'price': widget.data.price,
                  'description': widget.data.description,
                  'budget': widget.data.budget,
                  'timestamp': FieldValue.serverTimestamp(),
                });
                Navigator.of(context).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}
