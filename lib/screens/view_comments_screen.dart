import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewCommentsScreen extends StatelessWidget {
  final DocumentSnapshot postDocument;

  ViewCommentsScreen({required this.postDocument});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Comments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: postDocument.reference.collection('comments').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> commentData = document.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(commentData['comment']),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
