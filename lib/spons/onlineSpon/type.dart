import 'package:flutter/material.dart';

import '../../button.dart';
import '../../text.dart';
import '../Model/selection.dart';
import 'link.dart';

class typePage extends StatelessWidget {
  final SponsoringData data; // Accept SponsoringData object

  typePage({required this.data});

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
                SystemTextStyle(text: 'Choose an option :', fontSize: 30,),
                SizedBox(height: 30),
                SystemButton(
                  text: 'Photo',
                  onPressed: () {
                    data.content = 'Photo'; // Update platform
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LinkPage(data: data),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                SystemButton(
                  text: 'Video',
                  onPressed: () {
                    data.content = 'Video'; // Update platform

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LinkPage(data: data),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                SystemButton(
                  text: 'Reel',
                  onPressed: () {
                    data.content = 'Reel'; // Update platform

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LinkPage(data: data),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                SystemButton(
                  text: 'Page',
                  onPressed: () {
                    data.content = 'Page'; // Update platform

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LinkPage(data: data),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
