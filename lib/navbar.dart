import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_icons/line_icons.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart'; // Import crystal_navigation_bar
import 'Notification/Notification.dart';
import 'homepage.dart';
import 'profile/profile.dart';
import 'spons/welcome.dart';

class navbar extends StatefulWidget {
  const navbar({super.key});

  @override
  State<navbar> createState() => _navbarState();
}

class _navbarState extends State<navbar> {
  late User? user;
  late String userId;
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
  }

  int _selectedIndex = 0;
  late Map<int, Widget> _pages;
  @override
  Widget build(BuildContext context) {
    _pages = {
      2: map(),
      0: WelcomePage(),
      3: profile(userId: userId),
      1:NotificationPage(),
    };
    void ontaptapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: CrystalNavigationBar(
        // Customize the CrystalNavigationBar here

        currentIndex: _selectedIndex, // Set the current selected index
        onTap: (index) => ontaptapped(index), // Handle on tap event
        selectedItemColor: Colors.blue, // Set the color of selected item
        unselectedItemColor: Colors.grey, // Set the color of unselected items
        backgroundColor: Colors.transparent, // Set background color
        items: [
          // Define navigation bar items
          CrystalNavigationBarItem(
            icon: LineIcons.home,
          ),
          CrystalNavigationBarItem(
            icon: LineIcons.bell,
          ),
          CrystalNavigationBarItem(
            icon: LineIcons.mapMarker,
          ),
          CrystalNavigationBarItem(
            icon: LineIcons.user,
          ),
        ],
      ),
    );
  }
}
