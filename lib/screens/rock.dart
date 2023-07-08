import 'dart:math';

import 'package:flutter/material.dart';

enum Choice {
  Rock,
  Paper,
  Scissors,
}

class RockPaperScissorsGame extends StatefulWidget {
  @override
  _RockPaperScissorsGameState createState() => _RockPaperScissorsGameState();
}

class _RockPaperScissorsGameState extends State<RockPaperScissorsGame> {
  Choice? _userChoice;
  Choice? _computerChoice;
  String _result = '';

  void _playGame(Choice userChoice) {
    setState(() {
      _userChoice = userChoice;
      _computerChoice = _getRandomChoice();
      _result = _getResult(_userChoice, _computerChoice);
    });
  }

  Choice _getRandomChoice() {
    final random = Random();
    final values = Choice.values;
    return values[random.nextInt(values.length)];
  }

  String _getResult(Choice? userChoice, Choice? computerChoice) {
    if (userChoice == computerChoice) {
      return 'It\'s a tie!';
    } else if ((userChoice == Choice.Rock && computerChoice == Choice.Scissors) ||
        (userChoice == Choice.Paper && computerChoice == Choice.Rock) ||
        (userChoice == Choice.Scissors && computerChoice == Choice.Paper)) {
      return 'You win!';
    } else {
      return 'Computer wins!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rock, Paper, Scissors'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose your move:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _playGame(Choice.Rock),
                  child: Text('Rock'),
                ),
                ElevatedButton(
                  onPressed: () => _playGame(Choice.Paper),
                  child: Text('Paper'),
                ),
                ElevatedButton(
                  onPressed: () => _playGame(Choice.Scissors),
                  child: Text('Scissors'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Your choice: ${_userChoice?.toString().split('.').last ?? "-"}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Computer\'s choice: ${_computerChoice?.toString().split('.').last ?? "-"}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              _result,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RockPaperScissorsGame(),
  ));
}
