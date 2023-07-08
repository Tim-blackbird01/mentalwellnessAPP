import 'dart:async';

import 'package:flutter/material.dart';

class MemoryGame extends StatefulWidget {
  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  late List<int> _cardIndices;
  late List<bool> _flippedCards;
  late int _previousIndex;
  late bool _isBusy;
  late int _matchedPairs;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _cardIndices = List<int>.generate(16, (index) => index ~/ 2);
      _cardIndices.shuffle();
      _flippedCards = List<bool>.filled(16, false);
      _previousIndex = -1;
      _isBusy = false;
      _matchedPairs = 0;
    });

    Timer(Duration(seconds: 5), () {
      setState(() {
        _flippedCards = List<bool>.filled(16, true);
      });
    });
  }

  void _flipCard(int index) {
    if (_isBusy || _flippedCards[index]) {
      return;
    }

    setState(() {
      _flippedCards[index] = true;

      if (_previousIndex == -1) {
        _previousIndex = index;
      } else {
        _isBusy = true;

        if (_cardIndices[_previousIndex] == _cardIndices[index]) {
          // Match found
          _matchedPairs++;

          if (_matchedPairs == 8) {
            // Game completed
            _showGameCompletedDialog();
          }
        } else {
          // No match
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _flippedCards[_previousIndex] = false;
              _flippedCards[index] = false;
              _isBusy = false;
            });
          });
        }

        _previousIndex = -1;
      }
    });
  }

  void _showGameCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You have completed the game.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startNewGame();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: 16,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _flipCard(index);
            },
            child: Container(
              decoration: BoxDecoration(
                color: _flippedCards[index] ? Colors.white : Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: _flippedCards[index]
                    ? Text(
                        '${_cardIndices[index]}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      )
                    : Icon(Icons.memory, size: 48),
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MemoryGame(),
  ));
}
