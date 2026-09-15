import 'dart:math';
import 'package:flutter/material.dart';

class MemoryMatchGame extends StatefulWidget {
  const MemoryMatchGame({super.key});

  @override
  State<MemoryMatchGame> createState() => _MemoryMatchGameState();
}

class _MemoryMatchGameState extends State<MemoryMatchGame> {
  final Random random = Random();

  late List<String> cards;
  late List<bool> revealed;
  int firstIndex = -1;
  int moves = 0;
  int matches = 0;
  bool busy = false;

  final List<String> symbols = [
    '🍎',
    '🍌',
    '🍇',
    '🍉',
    '🍒',
    '🥝',
    '⭐',
    '❤️',
  ];

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    cards = [...symbols, ...symbols];
    cards.shuffle(random);
    revealed = List.filled(cards.length, false);
    firstIndex = -1;
    moves = 0;
    matches = 0;
    busy = false;
  }

  Future<void> tapCard(int index) async {
    if (busy || revealed[index]) return;

    setState(() {
      revealed[index] = true;
    });

    if (firstIndex == -1) {
      firstIndex = index;
      return;
    }

    moves++;

    if (cards[firstIndex] == cards[index]) {
      setState(() {
        matches++;
        firstIndex = -1;
      });

      if (matches == symbols.length) {
        _showWinDialog();
      }
    } else {
      final previous = firstIndex;
      busy = true;

      await Future.delayed(const Duration(milliseconds: 700));

      if (!mounted) return;

      setState(() {
        revealed[previous] = false;
        revealed[index] = false;
        firstIndex = -1;
        busy = false;
      });
    }
  }

  void _showWinDialog() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('🎉 You Win!'),
            content: Text('All pairs matched in $moves moves.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(startGame);
                },
                child: const Text('PLAY AGAIN'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Match'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Moves: $moves',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'Matches: $matches / ${symbols.length}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cards.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final isOpen = revealed[index];

                return GestureDetector(
                  onTap: () => tapCard(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isOpen
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1.5,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        isOpen ? cards[index] : '?',
                        style: TextStyle(
                          fontSize: isOpen ? 34 : 30,
                          fontWeight: FontWeight.bold,
                          color: isOpen ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton.icon(
              onPressed: () {
                setState(startGame);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('New Game'),
            ),
          ),
        ],
      ),
    );
  }
}
