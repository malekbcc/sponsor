import 'package:app/Admin/UserList/updateUserProfile.dart';
import 'package:app/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({Key? key}) : super(key: key);

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String searchText = "";
  String searchField = "firstname"; // Default search field

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<void> deleteUser(String userId) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _firestore.collection('users').doc(userId).delete();
              } catch (e) {
                print('Error deleting user: $e');
              }
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void navigateToUserProfile(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => profile(userId: userId)),
    );
  }

  void updateUser(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateUserProfilePage(
          UserId: userId,
        ),
      ),
    );
    print("Navigate to update user page for ID: $userId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
        actions: [
          DropdownButton<String>(
            value: searchField,
            items: [
              DropdownMenuItem(
                value: "firstname",
                child: Text("First Name"),
              ),
              DropdownMenuItem(
                value: "lastname",
                child: Text("Last Name"),
              ),
              DropdownMenuItem(
                value: "email",
                child: Text("Email"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                searchField = value!;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by $searchField",
              ),
              onChanged: (text) {
                setState(() {
                  searchText = text;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<User?>(
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
                    stream: searchText.isEmpty
                        ? _firestore.collection('users').snapshots()
                        : _firestore
                            .collection('users')
                            .where(searchField,
                                isGreaterThanOrEqualTo: searchText)
                            .where(searchField,
                                isLessThanOrEqualTo: searchText + 'z')
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No users found'));
                      } else {
                        final users = snapshot.data!.docs.where((doc) {
                          final fieldValue = doc[searchField];
                          return fieldValue
                              .toLowerCase()
                              .startsWith(searchText.toLowerCase());
                        }).toList();

                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(user['image']),
                                  onBackgroundImageError:
                                      (exception, stackTrace) {
                                    print(
                                        'Error loading profile picture: $exception');
                                  },
                                ),
                                title: Text(user['email']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user['firstname']),
                                    Text(user['lastname']),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => deleteUser(user.id),
                                ),
                                onTap: () => navigateToUserProfile(user.id),
                              ),
                            );
                          },
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
