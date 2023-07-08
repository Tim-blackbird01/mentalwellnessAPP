import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MentalHealthReadingScreen extends StatefulWidget {
  @override
  _MentalHealthReadingScreenState createState() => _MentalHealthReadingScreenState();
}

class _MentalHealthReadingScreenState extends State<MentalHealthReadingScreen> {
  List<ReadingMaterial> _readingMaterials = [];

  @override
  void initState() {
    super.initState();
    _fetchReadingMaterials();
  }

  Future<void> _fetchReadingMaterials() async {
    final snapshot = await FirebaseFirestore.instance.collection('reading_materials').get();
    final List<ReadingMaterial> materials = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return ReadingMaterial(
        title: data['title'],
        description: data['description'],
        content: data['content'],
      );
    }).toList();

    setState(() {
      _readingMaterials = materials;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mental Health Reading Material'),
      ),
      body: ListView.builder(
        itemCount: _readingMaterials.length,
        itemBuilder: (context, index) {
          final material = _readingMaterials[index];
          return ListTile(
            title: Text(material.title),
            subtitle: Text(material.description),
            onTap: () {
              _navigateToReadingMaterial(material);
            },
          );
        },
      ),
    );
  }

  void _navigateToReadingMaterial(ReadingMaterial material) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReadingMaterialScreen(material: material),
      ),
    );
  }
}

class ReadingMaterialScreen extends StatelessWidget {
  final ReadingMaterial material;

  const ReadingMaterialScreen({required this.material});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(material.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(material.content),
      ),
    );
  }
}

class FirestoreService {
  static Stream<List<ReadingMaterial>> getReadingMaterials() {
    return FirebaseFirestore.instance.collection('reading_materials').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ReadingMaterial(
          title: data['title'],
          description: data['description'],
          content: data['content'],
        );
      }).toList();
    });
  }

  static Future<void> saveReadingMaterial(ReadingMaterial material) async {
    await FirebaseFirestore.instance.collection('reading_materials').add({
      'title': material.title,
      'description': material.description,
      'content': material.content,
    });
  }
}

class ReadingMaterial {
  final String title;
  final String description;
  final String content;

  ReadingMaterial({required this.title, required this.description, required this.content});
}
