import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../Model/selection.dart'; // Import your model class

class FacturePage extends StatefulWidget {
  final SponsoringData data; // Accept SponsoringData object
  FacturePage({required this.data});

  @override
  _FacturePageState createState() => _FacturePageState();
}

class _FacturePageState extends State<FacturePage> {
  String firstname = "";
  String lastname = "";
  bool paymentRegistered = false;
  List<String> adminPhoneNumbers = []; // Variable to hold admin phone numbers
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getUserData();
    fetchAdminPhoneNumbers();
  }

  getUserData() async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      firstname = user.data()!['firstname'];
      lastname = user.data()!['lastname'];
    });
  }

  Future<void> fetchAdminPhoneNumbers() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'admin')
        .get();

    setState(() {
      adminPhoneNumbers = querySnapshot.docs
          .map((doc) => doc.data()['number'] as String)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.white, // Change the back arrow color here
          size: 30,
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Center(
                  child: Text(
                    'Facture Details',
                    style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.blue,
                          offset: Offset(0, 0),
                        ),
                        Shadow(
                          blurRadius: 20.0,
                          color: Colors.lightBlueAccent,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Table(
                  columnWidths: {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
                  border: TableBorder.all(color: Colors.blueAccent),
                  children: [
                    _buildTableRow('User:', firstname),
                    _buildTableRow('Type:', widget.data.type),
                    _buildTableRow('Platform:', widget.data.platform),
                    _buildTableRow('Duration:', '${widget.data.duration} days'),
                    _buildTableRow('Views:', widget.data.views.toString()),
                    _buildTableRow(
                        'Price:', '${widget.data.price.toStringAsFixed(2)}DT'),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  'Payment',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    FlutterSwitch(
                      width: 50.0,
                      height: 25.0,
                      toggleSize: 20.0,
                      value: paymentRegistered,
                      borderRadius: 30.0,
                      padding: 4.0,
                      showOnOff: false,
                      onToggle: (val) {
                        setState(() {
                          paymentRegistered = val;
                        });
                      },
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: paymentRegistered
                          ? Center(
                              child: Text(
                                adminPhoneNumbers.join(", "),
                                style: GoogleFonts.orbitron(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                paymentRegistered
                    ? Center(
                        child: Text(
                          "Send money to this number and we will check it later",
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSystemButton('Back', () {
                      Navigator.pop(context);
                    }),
                    _buildSystemButton('Confirm', () {
                      _showConfirmationDialog(context);
                    }),
                  ],
                ),
              ],
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
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.blueAccent.withOpacity(0.5),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.blueAccent, width: 2),
        ),
        padding: EdgeInsets.zero,
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            text,
            style: GoogleFonts.orbitron(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.blue,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            "Confirm",
            style: GoogleFonts.orbitron(color: Colors.white),
          ),
          content: Text(
            "Are you sure you want to confirm?",
            style: GoogleFonts.orbitron(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.orbitron(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                final String userId = _auth.currentUser!.uid;

                // Save data to Firebase
                FirebaseFirestore.instance.collection('sponsoring').add({
                  'userId': userId,
                  'status': 'on hold',
                  'type': widget.data.type,
                  'platform': widget.data.platform,
                  'content': widget.data.content,
                  'link': widget.data.link,
                  'country': widget.data.country,
                  'duration': widget.data.duration,
                  'views': widget.data.views,
                  'price': widget.data.price,
                  'paymentRegistered': paymentRegistered,
                  'timestamp':
                      FieldValue.serverTimestamp(), // Add timestamp field
                });
                // Return to the home page
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text(
                "Confirm",
                style: GoogleFonts.orbitron(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
