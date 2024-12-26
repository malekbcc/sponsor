import 'package:app/button.dart';
import 'package:flutter/material.dart';

import '../../text.dart';
import '../../textfield.dart';
import '../Model/selection.dart';
import 'country.dart';

class LinkPage extends StatelessWidget {
  final SponsoringData data; // Accept SponsoringData object
  final TextEditingController linkController = TextEditingController();

  LinkPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapped outside of the TextField
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
          fit: StackFit.expand,
          children: [
            Image.asset(
              'lib/images/er.jpeg', // Replace with your image path
              fit: BoxFit.cover,
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: SystemTextStyle(
                          text: 'post your link here:',
                          fontSize: 30,
                        ),
                      ),

                      SizedBox(height: 50),
                      // Add a text input field for the video link
                      SystemTextField(
                        controller: linkController,
                        hintText: 'Enter your link here please',
                      ),

                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Center(
                            child: SystemButton(
                          text: 'Next',
                          onPressed: () async {
                            // Get the link entered by the user
                            String link = linkController.text;
                            data.link = link;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CountrySelectionPage(data: data),
                              ),
                            );
                          },
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
