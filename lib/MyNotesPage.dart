import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyNotesPage extends StatefulWidget {
  const MyNotesPage({Key? key}) : super(key: key);

  @override
  _MyNotesPageState createState() => _MyNotesPageState();
}

class _MyNotesPageState extends State<MyNotesPage> {
  final List<String> _notes = [];
  final TextEditingController _noteController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data();
          if (data != null && data['notes'] != null) {
            setState(() {
              _notes.clear();
              _notes.addAll(List<String>.from(data['notes']));
            });
          }
        }
      } catch (e) {
        print('Error loading notes: $e');
      }
    }
  }

  Future<void> _saveNotes() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).set(
          {'notes': _notes},
          SetOptions(merge: true),
        );
      } catch (e) {
        print('Error saving notes: $e');
      }
    }
  }

  void _addNote() {
    if (_noteController.text.trim().isNotEmpty) {
      setState(() {
        _notes.add(_noteController.text.trim());
        _noteController.clear();
      });
      _saveNotes();
    }
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
    _saveNotes();
  }

  Widget _buildHeader() {
    return Container(
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
              child: Container(height: 100, color: const Color(0xFF008080).withOpacity(0.3)),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 16,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.note, size: 40, color: Colors.teal),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'My Notes',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Keep track of your thoughts',
                      style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: 'Add a new note',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add, color: Colors.teal),
                        onPressed: _addNote,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _notes.isEmpty
                        ? const Center(
                      child: Text(
                        'No notes yet. Start adding some!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                        : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ExpansionTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.teal.withOpacity(0.1),
                                child: const Icon(Icons.note, color: Colors.teal),
                              ),
                              title: Text(
                                _notes[index],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              childrenPadding: const EdgeInsets.all(16.0),
                              expandedAlignment: Alignment.centerLeft,
                              expandedCrossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _notes[index],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteNote(index),
                                  ),
                                ),
                              ],
                            ),
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
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 * size.width / 4, size.height - 40, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
