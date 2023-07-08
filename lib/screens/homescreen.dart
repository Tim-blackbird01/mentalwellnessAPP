import 'package:flutter/material.dart';

import 'boostmood.dart';
import 'chat_screen.dart';
import 'communitysupportscreen.dart';
import 'goalscreen.dart';
import 'journalingscreen.dart';
import 'resourcescreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            children: [
              FeatureCard(
                title: 'Chatbox',
                imagePath: 'assets/images/chat.png',
                onTap: () {
                  // Handle chatbox feature onTap
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen()),
                  );
                },
              ),
              FeatureCard(
                title: 'Journaling',
                imagePath: 'assets/images/journal.png',
                onTap: () {
                  // Navigate to the journaling screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JournalingScreen()),
                  );
                },
              ),
              FeatureCard(
                title: 'Goal Setting',
                imagePath: 'assets/images/goal.png',
                onTap: () {
                  // Handle goal setting feature onTap
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GoalSettingScreen()),
                  );
                },
              ),
              FeatureCard(
                title: 'Community Support',
                imagePath: 'assets/images/community.png',
                onTap: () {
                  // Handle community support feature onTap
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommunitySupportScreen()),
                  );
                },
              ),
              FeatureCard(
                title: 'Resources',
                imagePath: 'assets/images/resources.png',
                onTap: () {
                  // Handle community support feature onTap
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MentalHealthReadingScreen()),
                  );
                },
              ),
              FeatureCard(
                title: 'Boost Mood',
                imagePath: 'assets/images/boost.png',
                onTap: () {
                  // Navigate to the journaling screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen()),
                  );
                },
              ),
              // Add more FeatureCard widgets for other features
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const FeatureCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.blue, // Customize the splash color on tap
        borderRadius: BorderRadius.circular(8.0), // Add border radius to the InkWell
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 34, 99, 124), // Customize the card's background color
            borderRadius: BorderRadius.circular(8.0), // Add border radius to the card
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0, 2),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath,
                width: 48.0,
                height: 48.0,
              ),
              SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Customize the text color
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
