import 'dart:math';
import 'package:flutter/material.dart';

class BubbleShooterGame extends StatefulWidget {
  const BubbleShooterGame({super.key});

  @override
  State<BubbleShooterGame> createState() => _BubbleShooterGameState();
}

class _BubbleShooterGameState extends State<BubbleShooterGame> {
  final Random random = Random();

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
  ];

  late List<Color> bubbles;
  int score = 0;
  int shots = 0;

  @override
  void initState() {
    super.initState();
    newGame();
  }

  void newGame() {
    bubbles = List.generate(
      30,
      (_) => colors[random.nextInt(colors.length)],
    );
    score = 0;
    shots = 0;
  }

  void shoot(int index) {
    if (index < 0 || index >= bubbles.length) return;

    setState(() {
      final Color selected = bubbles[index];
      bubbles.removeAt(index);
      score += 10;
      shots++;

      if (bubbles.isEmpty) {
        bubbles = List.generate(
          30,
          (_) => colors[random.nextInt(colors.length)],
        );
      }

      if (selected == Colors.yellow) {
        score += 5;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bubble Shooter'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text(
                'Score: $score',
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
            'Tap a bubble to shoot!',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bubbles.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => shoot(index),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bubbles[index],
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          offset: Offset(1, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.circle_outlined,
                        color: Colors.white54,
                        size: 30,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Shots: $shots',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(newGame);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('New Game'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
