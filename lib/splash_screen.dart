import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the Login Page

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-Page Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF008080), // Teal
                  Color(0xFFE75480  ), // Light green
                  Color(0xFF66BB6A), // Softer green
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Circular Shape 1: Larger Circle on the Left
          Positioned(
            left: -100, // Move circle partially off-screen
            top: MediaQuery.of(context).size.height * 0.2, // Position vertically
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24, // Semi-transparent white
              ),
            ),
          ),
          // Circular Shape 2: Smaller Circle on the Bottom Right
          Positioned(
            right: -50, // Move circle partially off-screen
            bottom: MediaQuery.of(context).size.height * 0.1, // Position vertically
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white30, // Slightly more transparent white
              ),
            ),
          ),
          // Transparent Pink Circle 1: Medium Circle at the Top Right
          Positioned(
            right: -70,
            top: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFB6C1).withOpacity(0.3), // LightPink with transparency
              ),
            ),
          ),
          // Transparent Pink Circle 2: Small Circle in the Bottom Left
          Positioned(
            left: 20,
            bottom: MediaQuery.of(context).size.height * 0.2,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFC0CB).withOpacity(0.3), // Pink with transparency
              ),
            ),
          ),
          // Content in the Center
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ETTIZAN',
                  style: TextStyle(
                    fontFamily: 'Roboto', // Replace with your preferred font
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Personalized AI Plans for Chronic Disease Management\nthrough Nutrition and Fitness',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'MTF Base', // Replace with your preferred font
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                ),
                const SizedBox(height: 30),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
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