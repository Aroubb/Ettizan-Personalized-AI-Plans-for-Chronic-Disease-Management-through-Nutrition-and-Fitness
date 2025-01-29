import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'favorite_nutrition_plans_page.dart';
import 'nutritionHistoryPage.dart';

class HistoryPage extends StatelessWidget {
  final String userId;

  const HistoryPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Stream of all meal plan docs for this user, sorted by timestamp descending
    final plansStream = FirebaseFirestore.instance
        .collection('nutritionPlans')
        .doc(userId)
        .collection('dailyMeals')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Scaffold(
      // We remove the default AppBar to replicate the wave header style
      body: Stack(
        children: [
          // Header Section with gradient & waves
          Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF76D7C4), Color(0xFF66BB6A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // First wave
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
                // Second wave
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

                // Page Title

                // Back Button (top-left)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 0,
                  left: 16,
                  child: SafeArea(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 30,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.fastfood_outlined,
                          size: 50,
                          color: Colors.teal,
                        ),
                      ),

                      const SizedBox(height: 10),
                      const Text(
                        ' Nurtition Plans History',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: "Raleway",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 20,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavoriteNutritionPlansPage(userId: 'user.id')), // Replace 'FavoritesPage' with your actual favorites page class
                      );
                    },
                  ),
                ),
              ],
            ),
          ),


          // Main content
          Padding(
            padding: const EdgeInsets.only(top: 240),
            child: StreamBuilder<QuerySnapshot>(
              stream: plansStream,
              builder: (context, snapshot) {
                // Show loading spinner if data is still being fetched
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // If no plans exist, display a message
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No past plans found.',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                // We have data
                final docs = snapshot.data!.docs;

                // Build a ListView of plan cards
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>?;

                    // Extract meal lists
                    final breakfast = List<Map<String, dynamic>>.from(data?['Breakfast'] ?? []);
                    final lunch = List<Map<String, dynamic>>.from(data?['Lunch'] ?? []);
                    final dinner = List<Map<String, dynamic>>.from(data?['Dinner'] ?? []);
                    final snack = List<Map<String, dynamic>>.from(data?['Snack'] ?? []);

                    // Convert Firestore timestamp to DateTime
                    final timestamp = data?['timestamp'] as Timestamp?;
                    final dateTime = timestamp?.toDate() ?? DateTime.now();

                    // Format date/time
                    final formattedDate =
                        '${dateTime.day}/${dateTime.month}/${dateTime.year}  '
                        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ExpansionTile(
                        title: Text(
                          'Plan from $formattedDate',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        children: [
                          _buildMealTile('Breakfast', breakfast),
                          _buildMealTile('Lunch', lunch),
                          _buildMealTile('Dinner', dinner),
                          _buildMealTile('Snack', snack),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Helper widget to display each meal inside the ExpansionTile
  Widget _buildMealTile(String mealTitle, List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return ListTile(
        title: Text('$mealTitle:'),
        subtitle: const Text('No items.'),
      );
    }
    return ListTile(
      title: Text('$mealTitle:'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) => Text('- $item')).toList(),
      ),
    );
  }
}

/// WaveClipper class to match the Nutrition page header
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height - 20,
    );
    path.quadraticBezierTo(
      3 * size.width / 4,
      size.height - 40,
      size.width,
      size.height - 20,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
