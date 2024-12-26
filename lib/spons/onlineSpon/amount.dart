import 'package:app/button.dart';
import 'package:app/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Model/selection.dart';
import 'facture.dart';

class ViewsPage extends StatefulWidget {
  final SponsoringData data; // Accept SponsoringData object

  ViewsPage({required this.data});

  @override
  _ViewsPageState createState() => _ViewsPageState();
}

class _ViewsPageState extends State<ViewsPage> {
  int selectedViews = 1000; // Default views
  late User? user;
  late String? userId;
  int selectedDuration = 1; // Default duration
  static const int minDuration = 1;
  static const int maxDuration = 365; // 1 year
  double pricePerView =
      0.001; // Price per view (adjust according to your requirement)
  double pricePerDay =
      1.0; // Price per day (adjust according to your requirement)

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
  }

  double calculatePrice() {
    return (selectedViews * pricePerView * selectedDuration * pricePerDay);
  }

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SystemTextStyle(
                    text: 'Select Number of Views:',
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 10.0),
                Slider(
                  value: selectedViews.toDouble(),
                  min: 100.0,
                  max: 10000.0,
                  divisions: 99,
                  onChanged: (double value) {
                    setState(() {
                      selectedViews = value.toInt();
                    });
                  },
                  label: selectedViews.toString(),
                ),
                SizedBox(height: 10.0),
                SystemTextStyle(
                  text: '$selectedViews views',
                  fontSize: 25,
                ),
                SizedBox(height: 40.0),
                SystemTextStyle(
                  text: 'Select Duration :',
                  fontSize: 25,
                ),
                SizedBox(height: 10.0),
                Slider(
                  value: selectedDuration.toDouble(),
                  min: minDuration.toDouble(),
                  max: maxDuration.toDouble(),
                  divisions: maxDuration - minDuration,
                  onChanged: (double value) {
                    setState(() {
                      selectedDuration = value.round();
                    });
                  },
                  label: selectedDuration.toString(),
                ),
                SizedBox(height: 10.0),
                SystemTextStyle(
                  text: '$selectedDuration days',
                  fontSize: 25,
                ),
                SizedBox(height: 10.0),
                SystemTextStyle(
                  text:
                      'Total Price: ${calculatePrice().toStringAsFixed(2)} DT',
                  fontSize: 25,
                ),
                SizedBox(height: 10.0),
                SystemButton(
                  text: 'Next',
                  onPressed: () {
                    widget.data.views = selectedViews; // Update platform
                    widget.data.duration = selectedDuration; // Update platform
                    widget.data.price = calculatePrice(); // Update platform

                    // Navigate to the next page passing selected views
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FacturePage(
                          data: widget.data,
                        ),
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
