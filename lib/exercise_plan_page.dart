import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_exercise_page.dart'; // Ensure this file exists

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

class ExercisePlanPage extends StatefulWidget {
  const ExercisePlanPage({Key? key}) : super(key: key);

  @override
  State<ExercisePlanPage> createState() => _ExercisePlanPageState();
}

class _ExercisePlanPageState extends State<ExercisePlanPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> exercises = [];
  int completedExercises = 0;

  @override
  void initState() {
    super.initState();
    _fetchExerciseData();
  }

  // Fetch exercise data from Firestore
  Future<void> _fetchExerciseData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('exercisePlans')
          .doc(user.uid)
          .collection('exercises')
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          exercises = snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
              .toList();
          completedExercises = exercises
              .where((exercise) => exercise['completed'] == true)
              .length;
        });
        print("Fetched exercises: $exercises");  // Debugging line
      } else {
        print("No exercises found");
      }
    } else {
      print("User is not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalExercises = exercises.length;
    final double progress = totalExercises > 0 ? completedExercises / totalExercises : 0.0;

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
                          'Exercise Plan',
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
                                builder: (context) => EditExercisePage(),
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
                        // Text above Progress Bar
                        const Text(
                          'This is your exercise plan for today, Enjoy!',
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
                          '${(progress * 100).toStringAsFixed(1)}% of exercises completed',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Exercises List Section
                  Expanded(
                    child: ListView.builder(
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        return _buildExerciseCard(exercise);
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

  // Function to build exercise cards
  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    IconData exerciseIcon;

    // Set icon based on the exercise type
    switch (exercise['type']) {
      case 'cardio':
        exerciseIcon = Icons.directions_run; // Running icon for cardio
        break;
      case 'strength':
        exerciseIcon = Icons.fitness_center; // Strength icon
        break;
      case 'yoga':
        exerciseIcon = Icons.self_improvement; // Yoga icon
        break;
      default:
        exerciseIcon = Icons.accessibility_new; // Default icon if type is unknown
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          child: Icon(exerciseIcon, color: Colors.teal),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Safely check if 'type' is null before using toUpperCase()
            Text(
              (exercise['type'] ?? '').toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            Text(
              exercise['name'] ?? 'Exercise',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duration: ${exercise['duration'] ?? 'N/A'} minutes'),
            Text('Calories: ${exercise['calories'] ?? 'N/A'} kcal'),
          ],
        ),
        trailing: Checkbox(
          value: exercise['completed'] ?? false,
          onChanged: (value) async {
            final userId = FirebaseAuth.instance.currentUser!.uid;
            await FirebaseFirestore.instance
                .collection('exercisePlans')
                .doc(userId)
                .collection('exercises')
                .doc(exercise['id'])
                .update({'completed': value});
            setState(() {
              exercise['completed'] = value;
              completedExercises += value == true ? 1 : -1;
            });
          },
        ),
      ),
    );
  }
}
