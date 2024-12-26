import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_icons/line_icons.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart'; // Import crystal_navigation_bar

import '../profile/profile.dart';
import 'FactureList/ListOfFatcure.dart';
import 'Home/home.dart';
import 'UserList/userlist.dart';

class Adminnavbar extends StatefulWidget {
  const Adminnavbar({super.key});

  @override
  State<Adminnavbar> createState() => _navbarState();
}

class _navbarState extends State<Adminnavbar> {
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
      0: HomePage(),
      1: AllUsersPage(),
      2: FactureList(),
      3: profile(
        userId: userId,
      )
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
        selectedItemColor: const Color.fromARGB(
            255, 255, 255, 255), // Set the color of selected item
        unselectedItemColor: Colors.white, // Set the color of unselected items
        backgroundColor:
            const Color.fromARGB(129, 0, 0, 0), // Set background color
        items: [
          // Define navigation bar items
          CrystalNavigationBarItem(
            icon: LineIcons.home,
          ),
          CrystalNavigationBarItem(
            icon: LineIcons.listUl,
          ),
          CrystalNavigationBarItem(
            icon: LineIcons.fileInvoice,
          ),
          CrystalNavigationBarItem(
            icon: LineIcons.user,
          ),
        ],
      ),
    );
  }
}
