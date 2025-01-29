import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_profile_page.dart';
import 'nutritionPlans_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Stack(
        children: [
          // Header Section
          Container(
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF76D7C4), Color(0xFF66BB6A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Wavy Background
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      height: 100,
                      color: const Color(0xFF008080).withOpacity(0.3),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      height: 80,
                      color: const Color(0xFF008080).withOpacity(0.5),
                    ),
                  ),
                ),
                // Welcome Text and Profile Icon
                Positioned(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 16,
                  child: Row(
                    children: [
                      const Center(
                        child: Text(
                          'ETTIZAN',
                        style: TextStyle(
                        fontFamily: 'Atop', // Replace 'Roboto' with your custom font name
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
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
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                            break;
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main Content Section
          Padding(
            padding: const EdgeInsets.only(top: 250),
            child: SingleChildScrollView(
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
                  // Progress Bar Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const Text(
                          'Your Progress',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Progress Bar with enhanced design
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: 0, // Example: 60% progress
                            minHeight: 12,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 213, 54, 54)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '0% Completed',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Motivational Message
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'Every journey starts with a single step—let’s get started!',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.teal,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Spacer to push the icons to the bottom
                  Spacer(),
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
                            // Navigate to Exercises Page
                          },
                        ),
                        _buildIconBox(
                          context,
                          title: 'Nutrition',
                          icon: Icons.fastfood,
                          color: Colors.green.shade400,
                          onTap: () {
                            // Navigate to Nutrition Page
                            Navigator.push(
                              context,
                                   MaterialPageRoute(
                                    builder: (context) => const NutritionPage(),
  ),
                            );
                          },
                        ),
                        _buildIconBox(
                          context,
                          title: 'Profile',
                          icon: Icons.person,
                          color: Color(0xFFFFB6C1),
                          onTap: () {
                            // Navigate to Profile Page
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


  PopupMenuItem<String> _buildMenuItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return PopupMenuItem<String>(
      value: text,
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Water Reminder Widget
  Widget _buildWaterReminder() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        leading: const Icon(Icons.local_drink, color: Colors.blue, size: 40),
        title: const Text(
          'Stay Hydrated!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('Drink 3 cups of water to start your day.'),
      ),
    );
  }

  // Example Meals Widget
  Widget _buildExampleMeal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Nutrition Plan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            _buildMealCard(
              title: 'Breakfast',
              calories: 386,
              items: [
                {'name': 'Cinnamon French Toast', 'calories': '127', 'image': 'images/cinnamon_toast.png'},
                {'name': 'Yogurt with Almonds & Honey', 'calories': '259', 'image': 'images/yogurt2.jpg'},
              ],
            ),
            const SizedBox(height: 10),
            _buildMealCard(
              title: 'Lunch',
              calories: 417,
              items: [
                {'name': 'Strawberry Smoothie', 'calories': '322', 'image': 'images/smoothie1.jpg'},
                {'name': 'Avocado Coleslaw', 'calories': '94', 'image': 'images/coleslaw.jpg'},
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMealCard({required String title, required int calories, required List<Map<String, String>> items}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text('$calories Calories', style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const Divider(),
            ...items.map((item) => ListTile(
              leading: Image.asset(item['image']!, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(item['name']!),
              subtitle: Text('${item['calories']} Calories'),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleExercise() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Exercises Plan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            _buildExerciseCard(
              title: 'Morning',
              items: [
                {'name': 'Running', 'duration': '20 mins', 'calories': '150', 'image': 'images/running.jpg'},
              ],
            ),
            const SizedBox(height: 10),
            _buildExerciseCard(
              title: 'Afternoon',
              items: [
                {'name': 'Yoga', 'duration': '15 mins', 'calories': '75', 'image': 'images/yoga.jpg'},
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExerciseCard({required String title, required List<Map<String, String>> items}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...items.map((item) => ListTile(
              leading: Image.asset(item['image']!, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(item['name']!),
              subtitle: Text('${item['duration']} • ${item['calories']} Calories'),
            )),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Contact Us'),
          content: const Text('For inquiries, please email us at ettizanapp@gmail.com.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

// Custom Clipper for Wave Background
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height - 20);
    path.quadraticBezierTo(3 * size.width / 4, size.height - 40, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
