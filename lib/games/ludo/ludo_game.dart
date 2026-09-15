import 'dart:math';
import 'package:flutter/material.dart';

class LudoGame extends StatefulWidget {
  const LudoGame({super.key});

  @override
  State<LudoGame> createState() => _LudoGameState();
}

class _LudoGameState extends State<LudoGame> {
  final Random random = Random();

  int dice = 1;
  int playerPosition = 0;
  int computerPosition = 0;
  String message = 'Roll the dice to start!';

  void rollDice() {
    setState(() {
      dice = random.nextInt(6) + 1;
      playerPosition += dice;

      if (playerPosition >= 30) {
        playerPosition = 30;
        message = '🎉 You reached the finish!';
      } else {
        message = 'You rolled $dice';
        _computerTurn();
      }
    });
  }

  void _computerTurn() {
    final computerDice = random.nextInt(6) + 1;
    computerPosition += computerDice;

    if (computerPosition >= 30) {
      computerPosition = 30;
      message = 'Computer reached the finish!';
    }
  }

  void resetGame() {
    setState(() {
      dice = 1;
      playerPosition = 0;
      computerPosition = 0;
      message = 'Roll the dice to start!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ludo'),
        actions: [
          IconButton(
            onPressed: resetGame,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 36,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                  ),
                  itemBuilder: (context, index) {
                    final playerCell = playerPosition == index;
                    final computerCell = computerPosition == index;

                    return Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: playerCell
                            ? Colors.blue
                            : computerCell
                                ? Colors.red
                                : Colors.grey.shade200,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: playerCell
                            ? const Text(
                                '🔵',
                                style: TextStyle(fontSize: 22),
                              )
                            : computerCell
                                ? const Text(
                                    '🔴',
                                    style: TextStyle(fontSize: 22),
                                  )
                                : Text(
                                    index == 0
                                        ? 'START'
                                        : index == 35
                                            ? '🏆'
                                            : '',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Text(
            'Dice: $dice',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: rollDice,
            icon: const Icon(Icons.casino),
            label: const Text('ROLL DICE'),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
