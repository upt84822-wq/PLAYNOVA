import 'package:flutter/material.dart';

class PenaltyShootoutGame extends StatefulWidget {
  const PenaltyShootoutGame({super.key});

  @override
  State<PenaltyShootoutGame> createState() => _PenaltyShootoutGameState();
}

class _PenaltyShootoutGameState extends State<PenaltyShootoutGame> {
  int score = 0;
  int shots = 0;
  int misses = 0;

  void shoot(String direction) {
    if (shots >= 5) return;

    setState(() {
      shots++;
      if (direction != 'center') {
        score++;
      } else {
        misses++;
      }
    });
  }

  void reset() {
    setState(() {
      score = 0;
      shots = 0;
      misses = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final remaining = 5 - shots;

    return Scaffold(
      appBar: AppBar(
        title: Text('Penalty Shootout • $score/5'),
        actions: [
          IconButton(
            onPressed: reset,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            shots >= 5
                ? 'Game Over! Score: $score/5'
                : 'Shots remaining: $remaining',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Center(
              child: Icon(
                Icons.sports_soccer,
                size: 120,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const Text(
            'Choose your shot',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => shoot('left'),
                child: const Text('LEFT'),
              ),
              ElevatedButton(
                onPressed: () => shoot('center'),
                child: const Text('CENTER'),
              ),
              ElevatedButton(
                onPressed: () => shoot('right'),
                child: const Text('RIGHT'),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
