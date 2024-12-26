import 'package:app/button.dart';
import 'package:app/text.dart';
import 'package:flutter/material.dart';

import 'package:country_picker/country_picker.dart';

import '../Model/selection.dart';
import 'amount.dart';

class CountrySelectionPage extends StatefulWidget {
  final SponsoringData data; // Accept SponsoringData object

  const CountrySelectionPage({Key? key, required this.data}) : super(key: key);

  @override
  State<CountrySelectionPage> createState() => _CountrySelectionPageState();
}

class _CountrySelectionPageState extends State<CountrySelectionPage> {
  Country? selectedCountry;

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
              children: [
                SystemTextStyle(
                    text: selectedCountry?.name ?? 'No Country Selected', fontSize: 30,),
                SizedBox(height: 50),
                const SizedBox(height: 20),
                SystemButton(
                  text: 'Choose Country',
                  onPressed: () {
                    showCountryPicker(
                      context: context,
                      onSelect: (Country country) {
                        setState(() {
                          selectedCountry = country;
                        });
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: SystemButton(
                    text: 'Next',
                    onPressed: () {
                      widget.data.country =
                          selectedCountry!.name; // Update platform

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewsPage(
                            data: widget.data,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
