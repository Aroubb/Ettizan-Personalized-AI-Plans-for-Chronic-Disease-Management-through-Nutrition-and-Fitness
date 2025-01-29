import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'favorite_exercise_plans_page.dart'; // Import UserInfo model
class ExerciseHistory extends StatefulWidget {
  const ExerciseHistory({super.key});

  @override
  State<ExerciseHistory> createState() => _ExerciseHistoryState();
}

class _ExerciseHistoryState extends State<ExerciseHistory> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  List<Map<String, dynamic>> _exercisePlans = [];

  Future<void> _fetchExerciseHistory() async {
    setState(() {
      _isLoading = true;
    });

    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Fetch exercise plans for the user from Firestore
        final querySnapshot = await _firestore
            .collection('exercisePlans')
            .doc(user.uid)
            .collection('dailyWorkouts')
            .orderBy('timestamp', descending: true) // Order by timestamp (latest first)
            .get();

        // Parse the retrieved data
        setState(() {
          _exercisePlans = querySnapshot.docs.map((doc) {
            return {
              'timestamp': doc['timestamp'],
              'warmUp': doc['warmUp'] ?? [],
              'mainWorkout': doc['mainWorkout'] ?? [],
              'coolDown': doc['coolDown'] ?? [],
              'additionalNotes': doc['additionalNotes'] ?? [],
            };
          }).toList();
        });
      } catch (e) {
        print('Error fetching exercise history: $e');
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchExerciseHistory();
  }
  @override
  Widget build(BuildContext context) {
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
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10, // Adjust for status bar height
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.white,size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavoritePlansPage(userId: 'user.id')), // Replace 'FavoritesPage' with your actual favorites page class
                      );
                    },
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
                          Icons.fitness_center,
                          size: 50,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Exercise History',
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
                  // Loading Indicator
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator()),
                  // No Data Message
                  if (_exercisePlans.isEmpty && !_isLoading)
                    const Center(child: Text('No exercise history found.')),
                  // Exercise Plans List
                  if (!_isLoading && _exercisePlans.isNotEmpty)
                    ..._exercisePlans.map((exercisePlan) {
                      final timestamp = (exercisePlan['timestamp'] as Timestamp)
                          .toDate()
                          .toString();

                      return _buildExerciseCard(exercisePlan, timestamp);
                    }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildExerciseCard(Map<String, dynamic> exercisePlan, String timestamp) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(
              title: Text(
                'Exercise Plan - $timestamp',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              children: [
                _buildExerciseDetail('Warm-Up:', exercisePlan['warmUp']),
                _buildExerciseDetail('Main Workout:', exercisePlan['mainWorkout']),
                _buildExerciseDetail('Cool-Down:', exercisePlan['coolDown']),
                _buildExerciseDetail('Additional Notes:', exercisePlan['additionalNotes']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseDetail(String title, dynamic activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        ...activities.map<Widget>((activity) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text('- $activity', style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        const SizedBox(height: 10),
      ],
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
