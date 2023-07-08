import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'view_comments_screen.dart';

class ForumPostCard extends StatefulWidget {
  final DocumentSnapshot postDocument;
  final String author;
  final String title;
  final String content;

  ForumPostCard({
    required this.postDocument,
    required this.author,
    required this.title,
    required this.content,
  });

  @override
  _ForumPostCardState createState() => _ForumPostCardState();
}

class _ForumPostCardState extends State<ForumPostCard> {
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    final String comment = _commentController.text;

    if (comment.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('forum_posts')
          .doc(widget.postDocument.id)
          .collection('comments')
          .add({
        'author': widget.author,
        'comment': comment,
      });

      _commentController.clear();
    }
  }

  void _viewComments() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewCommentsScreen(postDocument: widget.postDocument)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.author,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(widget.content),
            SizedBox(height: 16),
            Text(
              'Comments:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: widget.postDocument.reference.collection('comments').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final comments = snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> commentData = document.data() as Map<String, dynamic>;
                  String commentAuthor = commentData['author'] ?? 'Unknown';
                  String commentText = commentData['comment'] ?? '';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          commentAuthor,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(commentText),
                      ],
                    ),
                  );
                }).toList();

                return Column(
                  children: comments,
                );
              },
            ),
            SizedBox(height: 8),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Add a comment',
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _addComment,
                  child: Text('Add Comment'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _viewComments,
                  child: Text('View Comments'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
