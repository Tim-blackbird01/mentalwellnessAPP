import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'add_entry_screen.dart';

class JournalEntryDetailsScreen extends StatefulWidget {
  final String entryId;
  final String entryText;

  JournalEntryDetailsScreen({required this.entryId, required this.entryText});

  @override
  _JournalEntryDetailsScreenState createState() => _JournalEntryDetailsScreenState();
}

class _JournalEntryDetailsScreenState extends State<JournalEntryDetailsScreen> {
  String entryText = '';

  @override
  void initState() {
    super.initState();
    entryText = widget.entryText;
  }

  Future<void> _editEntry(BuildContext context) async {
    final updatedEntry = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddJournalEntryScreen(entryId: widget.entryId, initialText: entryText),
      ),
    );

    if (updatedEntry != null && updatedEntry is String) {
      setState(() {
        entryText = updatedEntry;
      });
    }
  }

  Future<void> _deleteEntry(BuildContext context) async {
    await FirebaseFirestore.instance.collection('entries').doc(widget.entryId).delete();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal Entry'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/backgroundtwo.png"), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entryText,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _editEntry(context).then((_) {
                      // Refresh entry text after editing
                      FirebaseFirestore.instance
                          .collection('entries')
                          .doc(widget.entryId)
                          .get()
                          .then((snapshot) {
                        final data = snapshot.data();
                        if (data != null && data['text'] is String) {
                          setState(() {
                            entryText = data['text'];
                          });
                        }
                      });
                    }),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text('Edit'),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      await _deleteEntry(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
