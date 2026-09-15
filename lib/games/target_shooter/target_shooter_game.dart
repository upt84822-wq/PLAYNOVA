import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class TargetShooterGame extends StatefulWidget {
  const TargetShooterGame({super.key});

  @override
  State<TargetShooterGame> createState() => _TargetShooterGameState();
}

class _TargetShooterGameState extends State<TargetShooterGame> {
  final Random random = Random();
  Timer? timer;
  double targetX = 0.5;
  double targetY = 0.5;
  int score = 0;
  int timeLeft = 30;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
          moveTarget();
        } else {
          timer?.cancel();
        }
      });
    });
  }

  void moveTarget() {
    targetX = 0.12 + random.nextDouble() * 0.76;
    targetY = 0.12 + random.nextDouble() * 0.70;
  }

  void shoot() {
    if (timeLeft <= 0) return;

    setState(() {
      score += 10;
      moveTarget();
    });
  }

  void resetGame() {
    setState(() {
      score = 0;
      timeLeft = 30;
      moveTarget();
    });
    startGame();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Target Shooter • $score'),
        actions: [
          IconButton(
            onPressed: resetGame,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Time: $timeLeft seconds',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTap: shoot,
                  child: Stack(
                    children: [
                      Positioned(
                        left: targetX * constraints.maxWidth - 32,
                        top: targetY * constraints.maxHeight - 32,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 5),
                          ),
                          child: const Center(
                            child: Icon(Icons.gps_fixed, size: 36),
                          ),
                        ),
                      ),
                      if (timeLeft <= 0)
                        Center(
                          child: Text(
                            'GAME OVER\nScore: $score',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
