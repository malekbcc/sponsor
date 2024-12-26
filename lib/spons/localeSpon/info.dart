import 'package:app/button.dart';
import 'package:app/spons/localeSpon/LocaleType.dart';
import 'package:app/text.dart';
import 'package:app/textfield.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

import '../Model/selection.dart';

class InfoPage extends StatefulWidget {
  final LocaleSponsoringData data;

  InfoPage({required this.data});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final TextEditingController FirstnameController = TextEditingController();

  final TextEditingController LastnameController = TextEditingController();

  final TextEditingController telNumController = TextEditingController();

  final TextEditingController AdressController = TextEditingController();

  Country? selectedCountry;

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
            color: Colors.white, // Change the back arrow color here
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
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 60), // Add SizedBox here
                    SystemTextStyle(text: 'First Name:', fontSize: 20),

                    SizedBox(height: 10),
                    SystemTextField(
                        controller: FirstnameController,
                        hintText: 'Enter your First Name'),
                    SizedBox(height: 10),
                    SystemTextStyle(text: 'Last Name:', fontSize: 20),

                    SizedBox(height: 10),
                    SystemTextField(
                        controller: LastnameController,
                        hintText: 'Enter your Last Name'),

                    SizedBox(height: 10),
                    SystemTextStyle(text: 'Mobile number:', fontSize: 20),

                    SizedBox(height: 10),
                    SystemTextField(
                        controller: telNumController,
                        hintText: 'Enter your Mobile Number'),

                    SizedBox(height: 10),
                    SystemTextStyle(
                        text: selectedCountry?.name ?? 'No Country Selected',
                        fontSize: 20),

                    SizedBox(height: 20),
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

                    SizedBox(height: 10),
                    SystemTextStyle(text: 'adresse:', fontSize: 20),

                    SizedBox(height: 10),
                    SystemTextField(
                        controller: AdressController,
                        hintText: 'Enter your Adress'),

                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: SystemButton(
                        text: 'Next',
                        onPressed: () async {
                          // Get the link entered by the user
                          String FirstName = FirstnameController.text;
                          String LastName = LastnameController.text;
                          String Telnum = telNumController.text;
                          String Address = AdressController.text;
                          widget.data.firstName = FirstName;
                          widget.data.lastName = LastName;
                          widget.data.mobileNumber = Telnum;
                          widget.data.address = Address;
                          widget.data.country = selectedCountry!.name;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocaleTypePage(
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
            ),
          ],
        ),
      ),
    );
  }
}
