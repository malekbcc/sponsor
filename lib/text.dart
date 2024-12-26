import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SystemTextStyle extends StatelessWidget {
  final String text;
  final double fontSize;

  SystemTextStyle({required this.text, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.lightBlueAccent, Colors.white],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: GoogleFonts.racingSansOne(
          textStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.blue,
                offset: Offset(0, 0),
              ),
              Shadow(
                blurRadius: 20.0,
                color: Colors.lightBlueAccent,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}