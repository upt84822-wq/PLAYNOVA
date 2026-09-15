import 'package:flutter/material.dart';

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  final List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  String status = 'Player X turn';
  bool gameOver = false;

  void play(int index) {
    if (board[index].isNotEmpty || gameOver) return;

    setState(() {
      board[index] = currentPlayer;

      if (checkWinner(currentPlayer)) {
        status = 'Player $currentPlayer wins!';
        gameOver = true;
      } else if (!board.contains('')) {
        status = 'Draw!';
        gameOver = true;
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        status = 'Player $currentPlayer turn';
      }
    });
  }

  bool checkWinner(String player) {
    const wins = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    return wins.any(
      (line) =>
          board[line[0]] == player &&
          board[line[1]] == player &&
          board[line[2]] == player,
    );
  }

  void resetGame() {
    setState(() {
      board.fillRange(0, 9, '');
      currentPlayer = 'X';
      status = 'Player X turn';
      gameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic-Tac-Toe'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                status,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                itemCount: 9,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => play(index),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        board[index],
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: resetGame,
                child: const Text('New Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
