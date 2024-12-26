import 'package:app/spons/onlineSpon/type.dart';
import 'package:flutter/material.dart';

import '../../button.dart';
import '../../text.dart';
import '../Model/selection.dart';

class SocialMediaPage extends StatelessWidget {
  final SponsoringData data; // Accept SponsoringData object
  SocialMediaPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Color(0xFFF5F3E5), // Change the back arrow color here
          size: 50,
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                SystemTextStyle(
                  text: 'Social Media:',
                  fontSize: 30,
                ),
                SizedBox(height: 80),
                SystemButton(
                  text: 'Facebook',
                  onPressed: () {
                    data.platform = 'Facebook'; // Update platform
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => typePage(data: data)),
                    );
                  },
                ),
                SizedBox(height: 36),
                SystemButton(
                  text: 'Instagram',
                  onPressed: () {
                    data.platform = 'Instagram'; // Update platform

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => typePage(data: data)),
                    );
                  },
                ),
                SizedBox(height: 36),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
