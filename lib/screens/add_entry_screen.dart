import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddJournalEntryScreen extends StatefulWidget {
  final String? entryId;
  final String? initialText;

  AddJournalEntryScreen({this.entryId, this.initialText});

  @override
  _AddJournalEntryScreenState createState() => _AddJournalEntryScreenState();
}

class _AddJournalEntryScreenState extends State<AddJournalEntryScreen> {
  late TextEditingController _entryController;

  @override
  void initState() {
    super.initState();
    _entryController = TextEditingController(text: widget.initialText);
  }

  void _saveEntry() {
    String entryText = _entryController.text;

    if (entryText.isNotEmpty) {
      if (widget.entryId != null) {
        // Update existing entry
        FirebaseFirestore.instance.collection('entries').doc(widget.entryId).update({
          'text': entryText,
        }).then((_) {
          _entryController.clear();
          Navigator.pop(context);
        }).catchError((error) {
          // Handle error while updating entry
          print('Error updating entry: $error');
        });
      } else {
        // Add new entry
        FirebaseFirestore.instance.collection('entries').add({
          'text': entryText,
          'timestamp': DateTime.now(),
        }).then((_) {
          _entryController.clear();
          Navigator.pop(context);
        }).catchError((error) {
          // Handle error while adding entry
          print('Error adding entry: $error');
        });
      }
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entryId != null ? 'Edit Journal Entry' : 'Add Journal Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _entryController,
              decoration: InputDecoration(
                labelText: 'Write your journal entry',
              ),
            ),
            ElevatedButton(
              onPressed: _saveEntry,
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(widget.entryId != null ? 'Save Changes' : 'Add Entry'),
            ),
          ],
        ),
      ),
    );
  }
}
