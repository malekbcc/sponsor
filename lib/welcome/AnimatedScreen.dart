import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/loginorsignup.dart';

class AnimatedScreen extends StatefulWidget {
  @override
  _AnimatedScreenState createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  List<Shape> shapes = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
    _generateShapes();
    _controller.addListener(() {
      _updateShapes();
    });
  }

  void _generateShapes() {
    final random = Random();
    for (int i = 0; i < 11; i++) {
      double size = random.nextDouble() * 150 + 100;
      Color color = Colors.primaries[random.nextInt(Colors.primaries.length)];
      Offset position =
          Offset(random.nextDouble() * 300, random.nextDouble() * 600);
      double speed = -0.2;
      double angle = random.nextDouble() * 2 * pi;
      shapes.add(
        Shape(
          color: color,
          size: size,
          position: position,
          speed: speed,
          angle: angle,
        ),
      );
    }
  }

  void _updateShapes() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double speed = -0.2;

    for (final shape in shapes) {
      final double distance = speed * 20;
      double dx = shape.position.dx + distance * cos(shape.angle);
      double dy = shape.position.dy + distance * sin(shape.angle);
      if (dx < 0 || dx > screenWidth) {
        shape.angle = pi - shape.angle;
        dx = dx.clamp(0.0, screenWidth);
      }
      if (dy < 0 || dy > screenHeight) {
        shape.angle = -shape.angle;
        dy = dy.clamp(0.0, screenHeight);
      }
      shape.position = Offset(dx, dy);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/images/tt.jpeg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          for (final shape in shapes)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Positioned(
                  left: shape.position.dx,
                  top: shape.position.dy,
                  child: Transform.rotate(
                    angle: shape.angle,
                    child: Container(
                      width: shape.size,
                      height: shape.size,
                      decoration: BoxDecoration(
                        color: shape.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 40),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Image.asset(
                      'lib/images/welcome.png', // Change to your logo image path
                      width: 150, // Adjust logo size as needed
                      height: 150,
                    ),
                    /* Text(
                      'SponsorSPot',
                      style: GoogleFonts.blackOpsOne(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                        height:
                            50), // Adjust the height between the image and text as needed
                    Image.asset(
                      'lib/images/cat.png', // Replace 'path_to_your_image/logo.png' with the actual path to your image
                      width: 80, // Adjust width as needed
                      height: 80, // Adjust height as needed
                    ),*/
                    SizedBox(
                        height:
                            50), // Adjust the height between the image and text as needed
                    Text(
                      'Where Dreams Meet Sponsorship!',
                      style: GoogleFonts.prostoOne(
                        fontSize: 24,
                        color: Color.fromARGB(221, 0, 0, 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            height: 60,
            left: MediaQuery.of(context).size.width / 2 - 80,
            child: GestureDetector(
              onTap: () {
                _showAnimatedDialog(context);
              },
              child: Container(
                width: 160,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 177, 222, 179),
                      Colors.blue.shade600,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.shade600,
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Let's start",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAnimatedDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Builder(builder: (BuildContext context) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, -1),
              end: Offset.zero,
            ).animate(animation),
            child: Dialog(
              child: Container(
                height: 600,
                width: 950,
                child: signinorsignup(),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          );
        });
      },
      transitionDuration: Duration(milliseconds: 500),
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Shape {
  final Color color;
  final double size;
  late Offset position;
  final double speed;
  double angle;

  Shape({
    required this.color,
    required this.size,
    required this.position,
    required this.speed,
    required this.angle,
  });
}
