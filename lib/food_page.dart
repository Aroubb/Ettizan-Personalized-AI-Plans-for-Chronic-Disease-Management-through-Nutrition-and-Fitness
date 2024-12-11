import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart'; // Import Home Page
import 'user_info.dart'; // Import UserInfo model

class FoodPage extends StatefulWidget {
  final String userId;
  final UserInfo userInfo;

  const FoodPage({Key? key, required this.userId, required this.userInfo}) : super(key: key);

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final List<String> _foodPreferences = ['Vegetarian', 'Vegan', 'Gluten-Free', 'No Preferences'];
  final TextEditingController _allergyController = TextEditingController();

  String? _selectedFoodPreference;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _submitUserInfo() async {
    if (_selectedFoodPreference != null) {
      widget.userInfo.foodPreference = _selectedFoodPreference;
      widget.userInfo.allergies = _allergyController.text.trim();

      try {
        // Save user data to Firestore
        await _firestore.collection('users').doc(widget.userId).set(widget.userInfo.toMap());

        // Navigate to Home Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your food preference')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Header with Wave Design
            ClipPath(
              clipper: HeaderClipper(),
              child: Container(
                height: 300,
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
                child: const Center(
                  child: Text(
                    'ETTIZAN',
                    style: TextStyle(
                      fontFamily: 'OfficialNICK',
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            // Page Content
            Column(
              children: [
                const SizedBox(height: 200),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Food Preferences',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 20,
                                // fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Select Your Food Preference',
                                labelStyle: const TextStyle(color: Colors.black54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                              ),
                              items: _foodPreferences.map((preference) {
                                return DropdownMenuItem<String>(
                                  value: preference,
                                  child: Text(preference),
                                );
                              }).toList(),
                              value: _selectedFoodPreference,
                              onChanged: (value) {
                                setState(() {
                                  _selectedFoodPreference = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _allergyController,
                              decoration: InputDecoration(
                                labelText: 'Food Allergies (Optional)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                              ),
                              maxLines: 3,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _submitUserInfo,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF40E0D0), // Turquoise
                                  elevation: 10,
                                  shadowColor: Colors.black.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                ),
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Clipper for the Header's Curved Design
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
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
