import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'updateprofile.dart';

class profile extends StatefulWidget {
  final String userId;
  profile({required this.userId});

  @override
  State<profile> createState() => ProfileState();
}

class ProfileState extends State<profile> {
  String image = "";
  String firstname = "";
  String lastname = "";
  String email = "";
  String region = "";
  String telephone = "";

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void updateUserProfile() {
    getUserData();
  }

  getUserData() async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    setState(() {
      image = user.data()!['image'];
      firstname = user.data()!['firstname'];
      lastname = user.data()!['lastname'];
      email = user.data()!['email'];
      region = user.data()!['region'];
      telephone = user.data()!['number'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      updateProfile(onUpdateProfile: updateUserProfile),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 100, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(image),
                ),
                SizedBox(height: 20),
                profileInfoItem(Icons.person, "First Name", firstname),
                profileInfoItem(Icons.person, "Last Name", lastname),
                profileInfoItem(Icons.email, "Email", email),
                profileInfoItem(Icons.location_on, "Region", region),
                profileInfoItem(Icons.phone, "Telephone", telephone),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget profileInfoItem(IconData icon, String title, String value) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
