import 'package:flutter/material.dart';  // Importing Flutter's material design package for UI elements.
import 'dart:async';  // Importing dart:async to use Timer for delaying navigation.

import 'landing.dart';  // Importing the LandingPage widget from landing.dart file.

class SplashScreen extends StatefulWidget {  // Defining a StatefulWidget for the splash screen.
  const SplashScreen({Key? key}) : super(key: key);  // Constructor for the SplashScreen widget.

  @override
  _SplashScreenState createState() => _SplashScreenState();  // Creates the state for the splash screen.
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {  
  // This class manages the state of the splash screen and implements SingleTickerProviderStateMixin for animation.
  late AnimationController _controller;  // Declaring the AnimationController for the fade-in animation.
  late Animation<double> _opacityAnimation;  // Declaring the animation that controls opacity.

  @override
  void initState() {  
    super.initState();  // Calls the superclass initState.

    // Fade-in animation for the logo.
    _controller = AnimationController(  
      vsync: this,  // Provides a ticker for the animation.
      duration: const Duration(seconds: 2),  // Defines the duration of the animation (2 seconds).
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);  
    // Tween defines the start (0) and end (1) opacity values for the animation.
    _controller.forward();  // Starts the animation.

    // Navigate to Landing Page after 3 seconds.
    Timer(const Duration(seconds: 3), () {  
      // After 3 seconds, navigate to the LandingPage.
      Navigator.pushReplacement(  
        context,  
        MaterialPageRoute(builder: (context) => const LandingPage()),  
      );
    });
  }

  @override
  void dispose() {  
    _controller.dispose();  // Disposes the controller to free resources when the screen is closed.
    super.dispose();  // Calls the superclass dispose method.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      // The base structure for the app, with a body section.
      body: Stack(  
        fit: StackFit.expand,  
        // The Stack widget allows children to overlap each other.
        children: [
          // Gradient Background.
          Container(  
            decoration: const BoxDecoration(  
              gradient: LinearGradient(  
                colors: [Colors.teal, Colors.red],  // Colors for the gradient background.
                begin: Alignment.topLeft,  // The gradient starts from the top left.
                end: Alignment.bottomRight,  // The gradient ends at the bottom right.
              ),
            ),
          ),

          // Centered Logo with Animation.
          Column(  
            mainAxisAlignment: MainAxisAlignment.center,  
            // Aligns children vertically at the center of the screen.
            children: [
              FadeTransition(  
                opacity: _opacityAnimation,  // Applies the fade-in animation.
                child: Image.asset(  
                  'assets/images/logo.jpg',  
                  // Loads the logo image from the assets.
                  width: 150,  // Sets the width of the image.
                  height: 150,  // Sets the height of the image.
                ),
              ),
              const SizedBox(height: 20),  
              // Adds a 20-pixel space between the logo and the text.

              // App Name with Cool Font.
              const Text(  
                'Bangladesh 2.o',  
                style: const TextStyle(  
                  fontSize: 28,  // Sets the font size of the app name.
                  fontWeight: FontWeight.bold,  // Makes the text bold.
                  color: Colors.white,  // Sets the text color to white.
                ),
              ),
              const SizedBox(height: 10),  
              // Adds a 10-pixel space below the app name.

              // Animated Loading Indicator.
              const CircularProgressIndicator(  
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),  
                // Creates a circular progress indicator with white color.
              ),
            ],
          ),
        ],
      ),
    );
  }
}
