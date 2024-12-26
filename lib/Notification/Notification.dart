import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../spons/invoiceDetails/online.dart';
import '../spons/invoiceDetails/place.dart';
import '../spons/invoiceDetails/product.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> _getNotifications() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('notifications')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      return Stream.empty(); // Return an empty stream
    }
  }

  void _navigateToPage(BuildContext context, String factureId) async {
    final DocumentSnapshot facture =
        await _firestore.collection('sponsoring').doc(factureId).get();

    Widget page;
    final type = facture['type'];

    if (type == 'online') {
      page = online(factureId: factureId);
    } else if (type == 'locale') {
      final Map<String, dynamic> factureData =
          facture.data() as Map<String, dynamic>;
      if (factureData.containsKey('localeType')) {
        final localType = factureData['localeType'];
        if (localType == 'place') {
          page = Place(factureId: factureId);
        } else if (localType == 'Product') {
          page = Product(factureId: factureId);
        } else {
          page = Scaffold(body: Center(child: Text('Unknown local type')));
        }
      } else {
        page = Scaffold(body: Center(child: Text('Unknown local type')));
      }
    } else {
      page = Scaffold(body: Center(child: Text('Unknown type')));
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        
      ),
      body: Container(
        color: Color.fromARGB(255, 167, 202, 255), // Change to your desired background color
        child: StreamBuilder<QuerySnapshot>(
          stream: _getNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No notifications'));
            } else {
              final notifications = snapshot.data!.docs;
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  final factureId = notification[
                      'factureId']; // Assuming 'factureId' is in the notification data
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(
                        notification['title'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(notification['message']),
                      trailing: Text(
                        notification['timestamp'] != null
                            ? notification['timestamp'].toDate().toString()
                            : '',
                      ),
                      onTap: () {
                        _navigateToPage(context, factureId);
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
