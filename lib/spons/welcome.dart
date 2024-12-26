import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../chatbot/chat.dart';
import '../invoice.dart';
import 'sposoringPage.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

final User user = FirebaseAuth.instance.currentUser!;

Future<Map<String, dynamic>> getUserData() async {
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  return userDoc.data() as Map<String, dynamic>;
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              signOut();
            },
            child: Text('Logout'),
          ),
        ],
      );
    },
  );
}

void signOut() {
  FirebaseAuth.instance.signOut();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue, // Change this to your desired color
        ),
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Center(
          child: Text(
            'Welcome to ReachUp',
            style: GoogleFonts.bungee(
              color: Color.fromARGB(
                  255, 57, 133, 255), // Change app bar font color here
              fontSize: 20, // Adjust app bar font size as needed
            ),
          ),
        ),
      ),
      drawer: FutureBuilder<Map<String, dynamic>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Drawer(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Drawer(
              child: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else {
            var userData = snapshot.data!;
            var firstName = userData['firstname'];
            var lastName = userData['lastname'];
            var userImage = userData[
                'image']; // Assuming you have a field for the user's image URL

            return Drawer(
              backgroundColor: Colors.grey[900],
              child: Container(
                child: ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                      ),
                      accountName: Text(
                        '$firstName $lastName',
                        style: TextStyle(
                          fontSize: 20, // Font size
                          fontWeight: FontWeight.bold, // Font weight
                          color: Colors.white, // Font color
                        ),
                      ),
                      accountEmail: Text(
                        user.email!,
                        style: TextStyle(
                          fontSize: 16, // Font size
                          color: Colors.white, // Font color
                        ),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(userImage),
                      ),
                    ),
                    ListTile(
                      leading: Image.asset('lib/images/chatbot.png',
                          width: 24, height: 30), // Custom icon for Page 1
                      title: Text(
                        'A S S I S T  B O T',
                        style: GoogleFonts.arvo(
                          textStyle: TextStyle(
                            color: Colors.white, // Change the text color here
                            fontSize: 18.0, // Change the font size here
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatBot(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Image.asset('lib/images/invoice.png',
                          width: 24, height: 30), // Custom icon for Page 1
                      title: Text(
                        'M Y  I N V O I C E',
                        style: GoogleFonts.arvo(
                          textStyle: TextStyle(
                            color: Colors.white, // Change the text color here
                            fontSize: 18.0, // Change the font size here
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FactureListPage(),
                          ),
                        );
                      },
                    ),
                    const Divider(color: Colors.black),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(
                        'L O G  O U T',
                        style: GoogleFonts.arvo(
                          textStyle: TextStyle(
                            color: Colors.white, // Change the text color here
                            fontSize: 18.0, // Change the font size here
                          ),
                        ),
                      ),
                      onTap: () => showLogoutDialog(context),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(height: 50),
          Image.asset(
            'lib/images/vv.jpeg', // Change to your background image path
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/images/improve.png', // Change to your logo image path
                width: 150, // Adjust logo size as needed
                height: 150,
              ),
              SizedBox(height: 20),
              SizedBox(height: 50),
              Text(
                'Unleash your potential. Embrace the future.',
                style: GoogleFonts.bungee(
                  color: Color.fromARGB(255, 165, 196, 250),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SponsoringPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: GoogleFonts.bungee(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
