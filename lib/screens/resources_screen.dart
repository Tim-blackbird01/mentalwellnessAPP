import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Resource {
  final String title;
  final String content;
  final String imageUrl;

  Resource({
    required this.title,
    required this.content,
    required this.imageUrl,
  });
}

class ResourcesScreen extends StatefulWidget {
  @override
  _ResourcesScreenState createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  List<Resource>? resources;

  @override
  void initState() {
    super.initState();
    fetchResources();
  }

 Future<void> fetchResources() async {
  final String apiKey = '902fece127b0418eb3e03f469f08bb00';
  final String apiBaseUrl = 'https://api.nhs.uk/mental-health';
  final String apiVersion = '?api-version=1.0';

  final response = await http.get(
    Uri.parse('$apiBaseUrl/$apiVersion'),
    headers: {'subscription-key': apiKey},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print('Response body: $data');

    final resource = Resource(
      title: data['name'],
      content: data['description'],
      imageUrl: data['url'],
    );

    setState(() {
      resources = [resource];
    });
  } else {
    // Error handling
    print('Failed to fetch resources. Error: ${response.statusCode}');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resources'),
      ),
      body: resources != null
          ? ListView.builder(
              itemCount: resources!.length,
              itemBuilder: (context, index) {
                final resource = resources![index];
                return ListTile(
                  title: Text(resource.title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResourceScreen(resource: resource),
                      ),
                    );
                  },
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class ResourceScreen extends StatelessWidget {
  final Resource resource;

  ResourceScreen({required this.resource});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(resource.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(resource.imageUrl),
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(resource.content),
          ),
        ],
      ),
    );
  }
}
