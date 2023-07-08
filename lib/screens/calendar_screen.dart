import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'journal_entry_details_screen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text('Select Date'),
          ),
          SizedBox(height: 16),
          Text(
            'Selected Date: ${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('entries')
                  .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day)))
                  .where('timestamp', isLessThan: Timestamp.fromDate(DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day + 1)))
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final entries = snapshot.data!.docs;

                  if (entries.isEmpty) {
                    return Center(child: Text('No entries for the selected date.'));
                  }

                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index].data() as Map<String, dynamic>;
                      final entryId = entries[index].id;
                      final entryText = entry['text'] as String;
                      final entryTimestamp = entry['timestamp'] as Timestamp;
                      final entryDate = DateTime.fromMicrosecondsSinceEpoch(
                          entryTimestamp.microsecondsSinceEpoch);

                      return GestureDetector(
                        onTap: () {
                          _editJournal(entryId, entryText);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).accentColor,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            title: Text(
                              entryText.length > 30 ? '${entryText.substring(0, 30)}...' : entryText,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${entryDate.year}-${entryDate.month}-${entryDate.day}',
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
