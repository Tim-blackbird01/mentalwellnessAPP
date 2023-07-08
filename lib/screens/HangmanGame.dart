import 'dart:math';

import 'package:flutter/material.dart';

class HangmanGame extends StatefulWidget {
  @override
  _HangmanGameState createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  final List<String> _words = ['hangman', 'flutter', 'game', 'development', 'openai'];
  String _word = '';
  List<String> _guessedLetters = [];
  int _remainingGuesses = 6;
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _word = _words[Random().nextInt(_words.length)];
      _guessedLetters = [];
      _remainingGuesses = 6;
      _gameOver = false;
    });
  }

  void _guessLetter(String letter) {
    if (!_gameOver && !_guessedLetters.contains(letter)) {
      setState(() {
        _guessedLetters.add(letter);

        if (!_word.contains(letter)) {
          _remainingGuesses--;
        }

        if (_remainingGuesses == 0 || _isWordGuessed()) {
          _gameOver = true;
        }
      });
    }
  }

  bool _isLetterGuessed(String letter) {
    return _guessedLetters.contains(letter);
  }

  bool _isWordGuessed() {
    for (var letter in _word.split('')) {
      if (!_guessedLetters.contains(letter)) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hangman Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Guess the word:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var letter in _word.split(''))
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      _isLetterGuessed(letter) ? letter : '_',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Remaining guesses: $_remainingGuesses',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            if (_gameOver)
              Text(
                _isWordGuessed() ? 'You win!' : 'You lose!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 16),
            if (_gameOver)
              ElevatedButton(
                onPressed: () => _startNewGame(),
                child: Text('Play Again'),
              ),
            if (!_gameOver)
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 6,
                children: List.generate(26, (index) {
                  final letter = String.fromCharCode(index + 65);
                  return ElevatedButton(
                    onPressed: () => _guessLetter(letter),
                    child: Text(letter),
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HangmanGame(),
  ));
}
