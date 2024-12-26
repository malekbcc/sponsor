import 'package:app/button.dart';
import 'package:flutter/material.dart';
import '../text.dart';
import 'Model/selection.dart';
import 'localeSpon/info.dart';
import 'onlineSpon/Media.dart';

class SponsoringPage extends StatelessWidget {
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
      body: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.blueAccent, Colors.blue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //----------------------------------------------------------------
              SystemTextStyle(text:'Type  of  sponsoring :', fontSize: 30,),
              
              SizedBox(height: 80),
              SystemButton(
                text: 'Sponsoring Online',
                onPressed: () 
                { SponsoringData data = SponsoringData(
                      type: 'online',
                      platform: '', // Empty for now
                      link: '', // Empty for now
                      duration: 0, // Default duration
                      views: 1000, // Default views
                      price: 0,
                      content: '',
                      country: '', // Default price
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SocialMediaPage(data: data),
                      ),
                    ); },
                ),
              SizedBox(height: 36),
              //----------------------------------------------------------------
              SystemButton(
                text: 'Sponsoring Direct',
                onPressed: () 
                {  LocaleSponsoringData data = LocaleSponsoringData(
                        type: 'locale',
                        firstName: '',
                        lastName: '',
                        mobileNumber: '',
                        country: '',
                        address: '',
                        localeType: '',
                        image: '',
                        product: '',
                        maker: '',
                        price: 0,
                        description: '',
                        budget: 0,
                        placeName: '',
                        placetype: '');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InfoPage(data: data),
                      ),
                    );},
                ),
              
              SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}
