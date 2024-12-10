import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart'; // Import Login Page
import 'user_profile_page.dart';
import 'nutritionPlans_page.dart';
import 'exercise_plan_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Stack(
        children: [
          // Header with Curved Design
          Stack(
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF76D7C4), // Light green
                      Color(0xFF66BB6A), // Softer green
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              ClipPath(
                clipper: HeaderClipper(), // Custom clipper for curved design
                child: Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF008080), // Teal
                        Color(0xFF66BB6A), // Softer green
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Text(
                          'ETTIZAN',
                          style: TextStyle(
                            fontFamily: 'Atop',
                            color: Colors.white,
                            fontSize: 42,
                          ),
                        ),
                      ),
                      // Back Arrow Button
                      Positioned(
                        top: 40,
                        left: 16,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
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
          // Scrollable Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 220.0),
              child: Column(
                children: [
                  // Personalized Welcome Message
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Welcome, ${user?.displayName ?? 'User'}!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Fetch and display meals and exercises from Firestore
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Your Meal Plan',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('meals').snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const Text("No meals available.");
                            }
                            final meals = snapshot.data!.docs;
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: meals.length,
                              itemBuilder: (context, index) {
                                final mealData = meals[index];
                                return ListTile(
                                  title: Text(mealData['name'] ?? 'Meal Name'),
                                  subtitle: Text(mealData['description'] ?? 'No Description'),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Your Exercise Plan',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('exercises').snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const Text("No exercises available.");
                            }
                            final exercises = snapshot.data!.docs;
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: exercises.length,
                              itemBuilder: (context, index) {
                                final exerciseData = exercises[index];
                                return ListTile(
                                  title: Text(exerciseData['name'] ?? 'Exercise Name'),
                                  subtitle: Text(exerciseData['description'] ?? 'No Description'),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Footer with Icon Boxes Section
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildIconBox(
                          context,
                          title: 'Exercises',
                          icon: Icons.fitness_center,
                          color: Colors.teal.shade300,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ExercisePlanPage()),
                            );
                          },
                        ),
                        _buildIconBox(
                          context,
                          title: 'Nutrition',
                          icon: Icons.fastfood,
                          color: Colors.green.shade400,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NutritionPage()),
                            );
                          },
                        ),
                        _buildIconBox(
                          context,
                          title: 'Profile',
                          icon: Icons.person,
                          color: const Color(0xFFFFB6C1),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const UserProfilePage()),
                            );
                          },
                        ),
                      ],
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

  Widget _buildIconBox(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper for the Header
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50); // Start from bottom-left
    path.quadraticBezierTo(
      size.width / 2, size.height, // Control point
      size.width, size.height - 50, // End at bottom-right
    );
    path.lineTo(size.width, 0); // Top-right
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
