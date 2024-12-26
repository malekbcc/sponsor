import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../spons/invoiceDetails/online.dart';
import '../../spons/invoiceDetails/place.dart';
import '../../spons/invoiceDetails/product.dart';

class FactureList extends StatefulWidget {
  @override
  _FactureListState createState() => _FactureListState();
}

class _FactureListState extends State<FactureList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<void> _deleteFacture(String factureId) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this Invoice?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _firestore
                    .collection('sponsoring')
                    .doc(factureId)
                    .delete();
              } catch (e) {
                print('Error deleting facture: $e');
                // Handle error gracefully
              }
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _navigateToPage(
      BuildContext context, String factureId, DocumentSnapshot facture) {
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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Factures'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Online'),
              Tab(text: 'Direct'),
              Tab(text: 'Product'),
            ],
            indicatorColor: Color.fromRGBO(9, 159, 179, 1),
          ),
        ),
        body: TabBarView(
          children: [
            _buildFactureList(null), // All factures
            _buildFactureList('online'), // Online factures
            _buildFactureList('locale', 'place'), // Locale place factures
            _buildFactureList('locale', 'Product'), // Product factures
          ],
        ),
      ),
    );
  }

  Widget _buildFactureList(String? type, [String? localType]) {
    return FutureBuilder<User?>(
      future: getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No user logged in'));
        } else {
          return StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('sponsoring')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No factures found'));
              } else {
                final factures = snapshot.data!.docs.where((facture) {
                  if (type == null) return true;
                  final factureType = facture['type'];
                  final Map<String, dynamic> factureData =
                      facture.data() as Map<String, dynamic>;
                  final factureLocalType = factureData['localeType'];
                  return (type == factureType) &&
                      (localType == null || localType == factureLocalType);
                }).toList();
                return ListView.builder(
                  itemCount: factures.length,
                  itemBuilder: (context, index) {
                    final facture = factures[index];
                    final Timestamp timestamp = facture['timestamp'];
                    final DateTime date = timestamp.toDate();
                    final formattedDate =
                        DateFormat.yMMMd().add_jm().format(date);

                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text(facture['type'] ?? 'No Title'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(facture['status'] ?? 'No Status'),
                            Text('Date: $formattedDate'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteFacture(
                                facture.id); // Delete facture from Firebase
                          },
                        ),
                        onTap: () {
                          _navigateToPage(context, facture.id, facture);
                        },
                      ),
                    );
                  },
                );
              }
            },
          );
        }
      },
    );
  }
}
