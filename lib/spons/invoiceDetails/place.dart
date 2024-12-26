import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class Place extends StatefulWidget {
  final String factureId;

  Place({required this.factureId});

  @override
  State<Place> createState() => _LocalePlaceFactureState();
}

class _LocalePlaceFactureState extends State<Place> {
  String firstname = "";
  String lastname = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentSnapshot? factureData;
  bool isAdmin = false; // Flag to check admin role

  @override
  void initState() {
    super.initState();
    getUserData();
    fetchFactureData();
    _checkIfAdmin(); // Check admin role on init
  }

  void _checkIfAdmin() async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    setState(() {
      isAdmin = user.data()!['role'] == "admin"; // Check for admin role in data
    });
  }

  getUserData() async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    setState(() {
      firstname = user.data()!['firstname'];
      lastname = user.data()!['lastname'];
    });
  }

  fetchFactureData() async {
    final data = await FirebaseFirestore.instance
        .collection('sponsoring')
        .doc(widget.factureId)
        .get();
    setState(() {
      factureData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (factureData == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
          size: 50,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/images/er.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Facture Details:',
                      style: GoogleFonts.dynaPuff(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'User: $firstname $lastname',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(2),
                    },
                    border: TableBorder.all(),
                    children: [
                      _buildTableRow('status:', factureData!['status']),
                      _buildTableRow('Type:', factureData!['type']),
                      _buildTableRow('FirstName:', factureData!['firstName']),
                      _buildTableRow('LastName:', factureData!['lastName']),
                      _buildTableRow(
                          'Mobile Number:', factureData!['mobileNumber']),
                      _buildTableRow('Country:', factureData!['country']),
                      _buildTableRow('Address:', factureData!['address']),
                      _buildTableRow(
                          'Locale Type:', factureData!['localeType']),
                      _buildTableRow('Place Type:', factureData!['placetype']),
                      _buildTableRow('Place Name:', factureData!['placeName']),
                      _buildTableRow(
                          'Description:', factureData!['description']),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: factureData!['image'].isNotEmpty
                            ? Image.network(
                                factureData!['image'],
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
                  Visibility(
                    visible: isAdmin, // Show button only if admin
                    child: _buildSystemButton(
                      "Accept Facture",
                      () async {
                        _updateStatus('Accepted');
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Visibility(
                    visible: isAdmin, // Show button only if admin
                    child: _buildSystemButton(
                      "Refuse Facture",
                      () async {
                        _updateStatus('Refused');
                      },
                    ),
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

  void _updateStatus(String newStatus) async {
    try {
      // Update the status of the facture
      await FirebaseFirestore.instance
          .collection('sponsoring')
          .doc(widget.factureId)
          .update({'status': newStatus});

      // Get the user ID of the facture owner
      final userId = factureData!['userId'];

      // Create a notification for the facture owner
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': userId,
        'factureId': widget.factureId,
        'title': 'Facture Status Updated',
        'message': 'Your facture status has been updated to $newStatus',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Fetch the updated document after updating the status
      final updatedFactureData = await FirebaseFirestore.instance
          .collection('sponsoring')
          .doc(widget.factureId)
          .get();

      setState(() {
        factureData = updatedFactureData;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated successfully!'),
          backgroundColor: Colors.black,
        ),
      );
    } catch (e) {
      print('Error updating status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
}
