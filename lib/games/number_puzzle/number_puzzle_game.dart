import 'dart:math';
import 'package:flutter/material.dart';

class NumberPuzzleGame extends StatefulWidget {
  const NumberPuzzleGame({super.key});

  @override
  State<NumberPuzzleGame> createState() => _NumberPuzzleGameState();
}

class _NumberPuzzleGameState extends State<NumberPuzzleGame> {
  final Random random = Random();
  late List<int> numbers;
  int nextNumber = 1;
  int score = 0;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    numbers = List.generate(16, (index) => index + 1)..shuffle(random);
    nextNumber = 1;
    score = 0;
  }

  void tapNumber(int number) {
    if (number != nextNumber) return;

    setState(() {
      score += 10;
      numbers.remove(number);
      nextNumber++;

      if (numbers.isEmpty) {
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Puzzle Complete!'),
            content: Text('Your score: $score'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(resetGame);
                },
                child: const Text('PLAY AGAIN'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Puzzle • $score'),
        actions: [
          IconButton(
            onPressed: () {
              setState(resetGame);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Tap number: $nextNumber',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: numbers.length,
                itemBuilder: (context, index) {
                  final number = numbers[index];

                  return ElevatedButton(
                    onPressed: () => tapNumber(number),
                    child: Text(
                      '$number',
                      style: const TextStyle(fontSize: 24),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
