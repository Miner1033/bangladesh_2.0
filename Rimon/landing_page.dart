import 'dart:ui';  // Importing the 'dart:ui' package for using ImageFilter (for blur effect).
import 'package:flutter/material.dart';  // Importing Flutter's material design package for UI elements.

import 'botom_nav_guest.dart';  // Importing the BottomNavigationGuest widget for guest login functionality.
import 'login.dart';  // Importing the LoginPage widget.
import 'sign_up.dart';  // Importing the SignUpPage widget.

class LandingPage extends StatefulWidget {  
  // Stateful widget for the landing page.
  const LandingPage({Key? key}) : super(key: key);  // Constructor for the LandingPage widget.

  @override
  State<LandingPage> createState() => _LandingPageState();  // Creates the state for the landing page.
}

class _LandingPageState extends State<LandingPage> {
  void guestLogin() {
    // Function for guest login, navigating to BottomNavigationGuest screen.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const BottomavigationGuest(
          userName: 'Guest',
          profilePic: '',  // Empty profile picture for the guest.
          isGuest: true,  // Identifies the user as a guest.
          user: {},  // Empty user data.
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Scaffold provides basic app layout structure.
      body: Stack(  // Stack widget allows layering of elements.
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/memories.png'),  // Sets the background image.
                fit: BoxFit.cover,  // Ensures the image covers the entire screen.
              ),
            ),
          ),
          // Blur Effect for Peaceful Feel
          Positioned.fill(
            child: BackdropFilter(  
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),  // Adds blur effect with a sigma value.
              child: Container(color: Colors.black.withOpacity(0.4)),  // Adds a semi-transparent black overlay.
            ),
          ),
          // Centered Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),  // Adds horizontal padding.
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,  // Vertically centers the content.
                children: [
                  // App Title with Soft Glow
                  Text(
                    'Bangladesh 2.o',  // Title of the app.
                    style: TextStyle(
                      fontSize: 36,  // Font size of the app title.
                      fontWeight: FontWeight.bold,  // Makes the title bold.
                      color: Colors.white,  // Sets the color of the title to white.
                      letterSpacing: 1.2,  // Adds letter spacing for aesthetics.
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),  // Adds a shadow to the text.
                          blurRadius: 8,  // Controls the blur radius of the shadow.
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,  // Centers the text.
                  ),
                  const SizedBox(height: 10),  // Adds space between title and subtitle.
                  // Subtitle
                  Text(
                    'Dedicated to the brave souls who fought for freedom, justice, and a better tomorrow.',
                    style: TextStyle(
                      fontSize: 16,  // Font size of the subtitle.
                      color: Colors.white.withOpacity(0.7),  // Sets a white color with some opacity.
                      height: 1.5,  // Adjusts the line height for better readability.
                    ),
                    textAlign: TextAlign.center,  // Centers the subtitle.
                  ),
                  const SizedBox(height: 40),  // Adds space below the subtitle.
                  // Sign Up Button
                  buildButton(
                    text: 'Sign Up',
                    color1: Colors.teal,  // Gradient start color for the sign-up button.
                    color2: Colors.teal.shade700,  // Gradient end color for the sign-up button.
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage()));  // Navigates to the sign-up page.
                    },
                  ),
                  const SizedBox(height: 15),  // Adds space between buttons.
                  // Sign In Button
                  buildButton(
                    text: 'Sign In',
                    color1: Colors.red.shade600,  // Gradient start color for the sign-in button.
                    color2: Colors.green.shade700,  // Gradient end color for the sign-in button.
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));  // Navigates to the login page.
                    },
                  ),
                  const SizedBox(height: 20),  // Adds space between buttons and guest option.
                  // Continue as Guest Button
                  GestureDetector(
                    onTap: guestLogin,  // Calls the guestLogin function when tapped.
                    child: const Text(
                      'Continue as Guest',  // Text for the guest login button.
                      style: TextStyle(
                        fontSize: 16,  // Font size for the guest login text.
                        color: Colors.white60,  // Sets a lighter white color.
                        decoration: TextDecoration.underline,  // Underlines the text.
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Gradient Button for Better UI
  Widget buildButton({
    required String text,  // Text for the button.
    required Color color1,  // Start color for the button gradient.
    required Color color2,  // End color for the button gradient.
    required VoidCallback onPressed,  // Function to be called when the button is pressed.
  }) {
    return InkWell(
      onTap: onPressed,  // Calls the onPressed function when tapped.
      child: Container(
        width: double.infinity,  // Makes the button take full width.
        padding: const EdgeInsets.symmetric(vertical: 5),  // Adds vertical padding inside the button.
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color1, color2]),  // Gradient decoration for the button.
          borderRadius: BorderRadius.circular(25),  // Rounds the corners of the button.
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),  // Adds a shadow behind the button.
              blurRadius: 8,  // Controls the blur radius of the shadow.
              offset: const Offset(2, 4),  // Defines the offset for the shadow.
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,  // The button text.
            style: const TextStyle(
                fontSize: 18,  // Font size for the button text.
                fontWeight: FontWeight.bold,  // Makes the button text bold.
                color: Color(0xfff5f5f5),  // Sets a light gray color for the text.
                letterSpacing: 1.2),  // Adds letter spacing for aesthetics.
          ),
        ),
      ),
    );
  }
}
