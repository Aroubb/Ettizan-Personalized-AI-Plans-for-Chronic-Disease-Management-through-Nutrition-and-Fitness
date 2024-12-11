import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'user_profile_page.dart';
import 'nutritionPlans_page.dart';
import 'exercise_plan_page.dart';
import 'setting_page.dart';


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
                      // User Profile Picture Placeholder
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: user?.photoURL != null
                            ? ClipOval(
                          child: Image.network(
                            user!.photoURL!,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          ),
                        )
                            : const Icon(Icons.person, size: 30, color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hello,',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            user?.displayName ?? 'User',
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // App Title
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 90),
                    child: const Text(
                      'ETTIZAN',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 6,
                      ),
                    ),
                  ),
                ),
                // Menu Button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  right: 16,
                  child: SafeArea(
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                      color: const Color(0xFFF5F5DC), // Beige color for dropdown menu
                      elevation: 6, // Adds shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      itemBuilder: (BuildContext context) {
                        return [
                          _buildMenuItem(
                            icon: Icons.person,
                            text: 'Profile',
                            color: Colors.teal,
                          ),
                          _buildMenuItem(
                            icon: Icons.mail,
                            text: 'Contact Us',
                            color: Colors.blue,
                          ),
                          _buildMenuItem(
                            icon: Icons.settings,
                            text: 'Settings',
                            color: Colors.grey,
                          ),
                          _buildMenuItem(
                            icon: Icons.restaurant_menu,
                            text: 'Nutrition Plans',
                            color: Colors.orange,
                          ),
                          _buildMenuItem(
                            icon: Icons.fitness_center,
                            text: 'Exercise Plans',
                            color: Colors.purple,
                          ),
                          _buildMenuItem(
                            icon: Icons.logout,
                            text: 'Log Out',
                            color: Colors.red,
                          ),
                        ];
                      },
                      onSelected: (value) {
                        switch (value) {
                          case 'Profile':
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const UserProfilePage()),
                            );
                            break;
                          case 'Contact Us':
                            _showContactDialog(context);
                            break;
                          case 'Settings':
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SettingsPage()),
                            );
                            break;

                          case 'Nutrition Plans':
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NutritionPage()),
                            );
                            break;
                          case 'Exercise Plans':
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ExercisePlanPage()),
                            );
                            break;

                          case 'Log Out':
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
                  // Progress Section
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: 0.0, // Example progress (50%)
                            minHeight: 12,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF40E0D0)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '0% Completed',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'Every journey starts with a single step—let’s get started!',
                            style: TextStyle(
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
                  const SizedBox(height: 20),
                  // Water Reminder
                  _buildWaterReminder(),
                  const SizedBox(height: 20),
                  // Example Meals Section
                  _buildExampleMeal(),
                  const SizedBox(height: 20),
                  // Example Exercises Section
                  _buildExampleExercise(),
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
