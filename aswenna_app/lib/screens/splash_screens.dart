import 'package:aswenna_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

//----------------------------------- splash screen navigate to login --------------------------------
class MySplashScreenToLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 4,
      navigateAfterSeconds: LoginScreen(),
      image: Image.asset(
        "assets/images/logo.png",
      ),
      photoSize: 140.0,
      gradientBackground: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF09CB9B),
          Color(0xFF07B086),
          Color(0xFF069370),
          Color(0xFF057659),
        ],
        stops: [0.1, 0.4, 0.7, 0.9],
      ),
      loaderColor: Color(0xFFfed47e),
    );
  }
}
