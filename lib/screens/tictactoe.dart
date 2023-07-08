import 'package:flutter/material.dart';

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late List<List<String>> _board;
  late String _currentPlayer;
  late bool _gameOver;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _board = List<List<String>>.generate(3, (_) => List<String>.filled(3, ''));
      _currentPlayer = 'X';
      _gameOver = false;
    });
  }

  void _makeMove(int row, int col) {
    if (!_gameOver && _board[row][col].isEmpty) {
      setState(() {
        _board[row][col] = _currentPlayer;

        if (_checkWinner(row, col)) {
          _gameOver = true;
        } else if (_checkDraw()) {
          _gameOver = true;
          _currentPlayer = '';
        } else {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  bool _checkWinner(int row, int col) {
    final String player = _board[row][col];

    // Check row
    if (_board[row][0] == player && _board[row][1] == player && _board[row][2] == player) {
      return true;
    }

    // Check column
    if (_board[0][col] == player && _board[1][col] == player && _board[2][col] == player) {
      return true;
    }

    // Check diagonals
    if (row == col && _board[0][0] == player && _board[1][1] == player && _board[2][2] == player) {
      return true;
    }

    if (row + col == 2 && _board[0][2] == player && _board[1][1] == player && _board[2][0] == player) {
      return true;
    }

    return false;
  }

  bool _checkDraw() {
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (_board[row][col].isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  Widget _buildCell(int row, int col) {
    return GestureDetector(
      onTap: () => _makeMove(row, col),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            _board[row][col],
            style: TextStyle(fontSize: 48),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              _gameOver ? 'Game Over' : 'Current Player: $_currentPlayer',
              style: TextStyle(fontSize: 20),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: [
              for (int row = 0; row < 3; row++)
                for (int col = 0; col < 3; col++) _buildCell(row, col),
            ],
          ),
          SizedBox(height: 16),
          if (_gameOver)
            ElevatedButton(
              onPressed: () => _startNewGame(),
              child: Text('Play Again'),
            ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TicTacToeGame(),
  ));
}
