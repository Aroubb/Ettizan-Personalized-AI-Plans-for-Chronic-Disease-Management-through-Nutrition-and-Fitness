import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_nutrition_page.dart'; // Ensure this file exists
import 'home_page.dart';

// Custom header clipper for curved design
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.quadraticBezierTo(size.width / 2, size.height / 2, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class NutritionPage extends StatefulWidget {
  const NutritionPage({Key? key}) : super(key: key);

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> meals = [];
  int completedMeals = 0;

  @override
  void initState() {
    super.initState();
    _fetchNutritionData();
  }

  Future<void> _fetchNutritionData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('nutritionPlans')
          .doc(user.uid)
          .collection('meals')
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          meals = snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
              .toList();
          completedMeals = meals.where((meal) => meal['completed'] == true).length;
        });
      }
    }
  }

@override
Widget build(BuildContext context) {
  final int totalMeals = meals.length;
  final double progress = totalMeals > 0 ? completedMeals / totalMeals : 0.0;

  return Scaffold(
    body: Stack(
      children: [
        // Header with Curved Design (without ETTIZAN)
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
                        'Nutrition Plan',
                        style: TextStyle(
                          fontFamily: 'Atop',
                          color: Colors.white,
                          fontSize: 40,
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
                              builder: (context) =>  HomePage(),
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
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Column(
                    children: [
                      const Text(
                        'This is your meal plan for today, Enjoy!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      // Progress Bar Section
                      LinearProgressIndicator(
                        value: progress,
                        color: Colors.teal,
                        backgroundColor: Colors.teal.shade100,
                        minHeight: 7,
                      ),
                      const SizedBox(height: 7),
                      Text(
                        '${(progress * 100).toStringAsFixed(1)}% of meals completed',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Meals List Section
                Expanded(
                  child: ListView.builder(
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return _buildMealCard(meal);
                    },
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


  Widget _buildMealCard(Map<String, dynamic> meal) {
  IconData mealIcon;

  // Set icon based on the meal type
  switch (meal['type']) {
    case 'breakfast':
      mealIcon = Icons.wb_sunny; // Sun icon for breakfast
      break;
    case 'lunch':
      mealIcon = Icons.lunch_dining; // Lunch icon
      break;
    case 'dinner':
      mealIcon = Icons.night_shelter; // Dinner icon
      break;
    default:
      mealIcon = Icons.fastfood; // Default fast food icon if type is unknown
  }

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: ListTile(
      contentPadding: const EdgeInsets.all(12),
      leading: CircleAvatar(
        backgroundColor: Colors.teal.shade100,
        child: Icon(mealIcon, color: Colors.teal),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Safely check if 'type' is null before using toUpperCase()
          Text(
            (meal['mealType'] ?? '').toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            meal['name'] ?? 'Meal',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Calories: ${meal['calories'] ?? 'N/A'}'),
          Text('Protein: ${meal['protein'] ?? 'N/A'}g'),
          Text('Carbs: ${meal['carbs'] ?? 'N/A'}g'),
          Text('Fat: ${meal['fat'] ?? 'N/A'}g'),
          if (meal['ingredients'] != null)
            Text('Ingredients: ${meal['ingredients'].join(', ')}'),
        ],
      ),
      trailing: Checkbox(
        value: meal['completed'] ?? false,
        onChanged: (value) async {
          final userId = FirebaseAuth.instance.currentUser!.uid;
          await FirebaseFirestore.instance
              .collection('nutritionPlans')
              .doc(userId)
              .collection('meals')
              .doc(meal['id'])
              .update({'completed': value});
          setState(() {
            meal['completed'] = value;
            completedMeals += value == true ? 1 : -1;
          });
        },
      ),
    ),
  );
}

}
