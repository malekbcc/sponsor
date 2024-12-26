import 'package:app/button.dart';
import 'package:app/spons/localeSpon/LocalePlace.dart';
import 'package:app/spons/localeSpon/product.dart';
import 'package:app/text.dart';
import 'package:flutter/material.dart';

import '../Model/selection.dart';

class LocaleTypePage extends StatelessWidget {
  final LocaleSponsoringData data;
  LocaleTypePage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.yellow, // Change the back arrow color here
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
                SystemTextStyle(text: 'Type', fontSize: 50),
                SizedBox(height: 70),
                SystemButton(
                  text: 'Locale Place',
                  onPressed: () {
                    data.localeType = 'place';

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LocalePlacePage(data: data)),
                    );
                  },
                ),
                SizedBox(height: 50),
                SystemButton(
                  text: 'Product',
                  onPressed: () {
                    data.localeType = 'Product';

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductPage(data: data)),
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
