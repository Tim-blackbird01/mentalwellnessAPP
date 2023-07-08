import 'dart:math';

import 'package:flutter/material.dart';

class GuessTheNumberGame extends StatefulWidget {
  @override
  _GuessTheNumberGameState createState() => _GuessTheNumberGameState();
}

class _GuessTheNumberGameState extends State<GuessTheNumberGame> {
  final int _minNumber = 1;
  final int _maxNumber = 100;
  late int _targetNumber;
  int? _guess;
  late String _feedback;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _targetNumber = Random().nextInt(_maxNumber - _minNumber + 1) + _minNumber;
      _guess = null;
      _feedback = '';
    });
  }

  void _makeGuess(int number) {
    setState(() {
      _guess = number;

      if (_guess == _targetNumber) {
        _feedback = 'Congratulations! You guessed it right.';
      } else if (_guess! < _targetNumber) {
        _feedback = 'Try a higher number.';
      } else {
        _feedback = 'Try a lower number.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guess the Number'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Guess a number between $_minNumber and $_maxNumber:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                _guess != null ? 'Your guess: $_guess' : 'Make a guess',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              if (_feedback.isNotEmpty)
                Text(
                  _feedback,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 16),
              if (_guess == null || _feedback.isNotEmpty)
                ElevatedButton(
                  onPressed: () => _startNewGame(),
                  child: Text('Start New Game'),
                ),
              if (_guess == null || _feedback.isEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    for (int number = _minNumber; number <= _maxNumber; number++)
                      ElevatedButton(
                        onPressed: () => _makeGuess(number),
                        child: Text(number.toString()),
                      ),
                  ],
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
    home: GuessTheNumberGame(),
  ));
}
