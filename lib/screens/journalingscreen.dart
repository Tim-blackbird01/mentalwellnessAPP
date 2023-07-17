import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'add_entry_screen.dart';
import 'calendar_screen.dart';
import 'journal_entry_details_screen.dart';

class JournalingScreen extends StatefulWidget {
  @override
  _JournalingScreenState createState() => _JournalingScreenState();
}

class _JournalingScreenState extends State<JournalingScreen> {
  final TextEditingController _entryController = TextEditingController();

  void _addEntry() {
    String entryText = _entryController.text;

    if (entryText.isNotEmpty) {
      // Add your entry to the database or perform any other desired action
      _entryController.clear();
    }
  }

  void _navigateToCalendar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarScreen(),
      ),
    );
  }

  void _editJournal(String entryId, String entryText) {
    // Navigate to the JournalEntryDetailsScreen with the provided entryId and entryText for editing
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEntryDetailsScreen(entryId: entryId, entryText: entryText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFFABCDEF), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFF88CC99)), // Calming green
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Journal'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/backgroundtwo.png"), // Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
              Card(
                color: Colors.transparent, // Set card background color to transparent
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 3 / 1, // Make the image fill a third of the screen
                      child: Image.asset(
                        'assets/images/checkin.png',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}', // Date without importing any packages
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          const SizedBox(height: 10),
                          const Text(
                            'Write about your day and experiences.',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddJournalEntryScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).colorScheme.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text('Check-in'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('entries')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final entries = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index].data() as Map<String, dynamic>;
                        final entryId = entries[index].id;
                        final entryText = entry['text'] as String;
                        final entryTimestamp = entry['timestamp'] as Timestamp;
                        final entryDate =
                            DateTime.fromMicrosecondsSinceEpoch(entryTimestamp.microsecondsSinceEpoch);

                        return GestureDetector(
                          onTap: () {
                            _editJournal(entryId, entryText);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.secondary, // Border color
                                width: 1.0, // Border width
                              ),
                              borderRadius: BorderRadius.circular(10.0), // Border radius
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              title: Text(
                                entryText.length > 30 ? '${entryText.substring(0, 30)}...' : entryText,
                                style: const TextStyle(
                                  fontSize: 16.0, // Fixed font size for the heading
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${entryDate.year}-${entryDate.month}-${entryDate.day}', // Date without importing any packages
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToCalendar,
          child: const Icon(Icons.calendar_today),
        ),
      ),
    );
  }
}
