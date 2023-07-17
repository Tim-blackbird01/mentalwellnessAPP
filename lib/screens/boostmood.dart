import 'package:flutter/material.dart';

import 'affirmation.dart';
import 'musicscreen.dart'; // Import your music screen file here
import 'rock.dart';
import 'tictactoe.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/boostmood.png"), // Replace with your background image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GameIcon(
                    icon: Icons.gamepad,
                    label: 'Memorygame',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MemoryGame()),
                      );
                      // Open Game 1
                    },
                  ),
                  GameIcon(
                    icon: Icons.sports_esports,
                    label: 'TicTacToe',
                    onTap: () {
                      // Open Game 2
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TicTacToeGame()),
                      );
                    },
                  ),
                  
                  GameIcon(
                    icon: Icons.support_rounded,
                    label: 'Rockpaperscissors',
                    onTap: () {
                      // Open Game 4
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RockPaperScissorsGame()),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              GameIcon(
                icon: Icons.music_note,
                label: 'Music',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MusicPlayerScreen()), // Replace 'MusicScreen' with the actual class name of your music screen
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const GameIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GameScreen(),
  ));
}
