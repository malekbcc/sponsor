import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class online extends StatefulWidget {
  final String factureId;

  online({required this.factureId});

  @override
  _FacturePageState createState() => _FacturePageState();
}

class _FacturePageState extends State<online> {
  String firstname = "";
  String lastname = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentSnapshot? factureData;
  bool isAdmin = false; // Flag to check admin role
  bool paymentRegistered = false;

  @override
  void initState() {
    super.initState();
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

  Future<void> fetchFactureData() async {
    final data = await FirebaseFirestore.instance
        .collection('sponsoring')
        .doc(widget.factureId)
        .get();

    if (data.exists) {
      final userId = data['userId'];
      final user = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (user.exists) {
        setState(() {
          factureData = data;
          firstname = user['firstname'];
          lastname = user['lastname'];
        });
      }
    }
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
          color: Colors.white,
          size: 30,
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
                    _buildTableRow('Status:', factureData!['status']),
                    _buildTableRow('User:', firstname),
                    _buildTableRow('Type:', factureData!['type']),
                    _buildTableRow('Platform:', factureData!['platform']),
                    _buildTableRow(
                        'Duration:', '${factureData!['duration']} days'),
                    _buildTableRow('Views:', factureData!['views'].toString()),
                    _buildTableRow('Price:',
                        '${factureData!['price'].toStringAsFixed(2)} DT'),
                    _buildIconRow(
                      'Payment:',
                      factureData!['paymentRegistered']
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : Icon(Icons.cancel, color: Colors.red),
                    ),
                  ],
                ),
                SizedBox(height: 30),
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
              ],
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

  TableRow _buildIconRow(String label, Widget icon) {
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
          child: icon,
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
