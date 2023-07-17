import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

  void _sendMessage(String message) async {
    setState(() {
      _messages.add({'role': 'user', 'content': message});
    });

    String apiUrl = 'https://api.openai.com/v1/chat/completions';
    String apiKey = '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';

    Map<String, dynamic> requestBody = {
      'model': 'gpt-3.5-turbo',
      'messages': _messages.map((m) => {'role': m['role'], 'content': m['content']}).toList(),
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String reply = data['choices'][0]['message']['content'].toString();

        setState(() {
          _messages.add({'role': 'assistant', 'content': reply});
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    return ListTile(
      title: Text(message['content']),
      subtitle: Text(message['role']),
      tileColor: message['role'] == 'assistant'
          ? Colors.blueGrey[100]
          : Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessageItem(_messages[index]),
            ),
          ),
          Divider(height: 1.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration.collapsed(hintText: 'Type a message'),
                    onSubmitted: (value) {
                      _sendMessage(value);
                      _textEditingController.clear();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_textEditingController.text.trim());
                    _textEditingController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChatScreen(),
  ));
}