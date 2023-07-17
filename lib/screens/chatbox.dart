import 'dart:async';

import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String apiKey = "<YOUR API KEY>";
  String response = "";
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                Text(response),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      sendMessage(message);
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage(String message) async {
    try {
      var openAI = OpenAIClient(apiKey);
      var completions = await openAI.complete(
        prompt: message,
        temperature: 0.7,
        maxTokens: 100,
      );
      setState(() {
        response += 'User: $message\n';
        response += 'AI: ${completions.choices.first.text}\n\n';
      });
    } catch (error) {
      print('Error: $error');
    }
  }
  
  OpenAIClient(String apiKey) {}
}
