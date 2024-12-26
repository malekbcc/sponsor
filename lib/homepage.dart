import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';

class map extends StatefulWidget {
  @override
  _mapState createState() => _mapState();
}

class _mapState extends State<map> {
  String locationMessage = 'Get current location';
  late double lat = 35.033949;
  late double long = 9.473821;
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color:
              Color.fromARGB(255, 7, 34, 56), // Set the color of the back arrow
        ),
        backgroundColor: Color.fromARGB(255, 241, 241, 241),
        title: Center(
          child: Text(
            'Location',
            style: GoogleFonts.poppins(
              color: Color.fromARGB(255, 10, 59, 67),
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: LatLng(lat, long),
          zoom: 16.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/%7Bz%7D/%7Bx%7D/%7By%7D.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(lat, long),
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.location_on,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
              ),
              ..._markers,
            ],
          ),
        ],
      ),
    );
  }
}