import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CarRacingGame extends StatefulWidget {
  const CarRacingGame({super.key});

  @override
  State<CarRacingGame> createState() => _CarRacingGameState();
}

class _CarRacingGameState extends State<CarRacingGame> {
  Timer? timer;
  final Random random = Random();

  double carX = 0.5;
  double roadOffset = 0;
  int score = 0;
  bool gameOver = false;

  final List<double> obstacles = [];

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    timer?.cancel();
    obstacles.clear();
    carX = 0.5;
    roadOffset = 0;
    score = 0;
    gameOver = false;

    timer = Timer.periodic(
      const Duration(milliseconds: 30),
      (_) => _updateGame(),
    );
  }

  void _updateGame() {
    if (!mounted || gameOver) return;

    setState(() {
      roadOffset += 0.01;

      if (roadOffset > 1) {
        roadOffset = 0;
      }

      if (random.nextInt(45) == 0) {
        obstacles.add(-0.1);
      }

      for (int i = 0; i < obstacles.length; i++) {
        obstacles[i] += 0.012;
      }

      obstacles.removeWhere((value) => value > 1.1);

      score++;

      for (final obstacleY in obstacles) {
        if (obstacleY > 0.72 &&
            obstacleY < 0.88 &&
            (carX - 0.5).abs() < 0.16) {
          gameOver = true;
          timer?.cancel();
          break;
        }
      }
    });
  }

  void _moveCar(double direction) {
    if (gameOver) return;

    setState(() {
      carX += direction * 0.08;

      if (carX < 0.2) {
        carX = 0.2;
      }

      if (carX > 0.8) {
        carX = 0.8;
      }
    });
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
        title: const Text('Car Racing'),
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
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: RacingPainter(
                          carX: carX,
                          obstacles: obstacles,
                          roadOffset: roadOffset,
                        ),
                      ),
                    ),
                    if (gameOver)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'GAME OVER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Score: $score',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _startGame,
                                child: const Text('PLAY AGAIN'),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _moveCar(-1),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('LEFT'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _moveCar(1),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('RIGHT'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RacingPainter extends CustomPainter {
  final double carX;
  final List<double> obstacles;
  final double roadOffset;

  RacingPainter({
    required this.carX,
    required this.obstacles,
    required this.roadOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint grassPaint = Paint()..color = Colors.green;
    final Paint roadPaint = Paint()..color = Colors.grey.shade800;
    final Paint linePaint = Paint()..color = Colors.white;
    final Paint carPaint = Paint()..color = Colors.red;
    final Paint obstaclePaint = Paint()..color = Colors.blue;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      grassPaint,
    );

    final double roadLeft = size.width * 0.15;
    final double roadWidth = size.width * 0.7;

    canvas.drawRect(
      Rect.fromLTWH(
        roadLeft,
        0,
        roadWidth,
        size.height,
      ),
      roadPaint,
    );

    for (int i = -1; i < 12; i++) {
      final double y =
          ((i * 90) + roadOffset * 90) % (size.height + 90) - 90;

      canvas.drawRect(
        Rect.fromLTWH(
          size.width * 0.49,
          y,
          8,
          50,
        ),
        linePaint,
      );
    }

    for (final obstacleY in obstacles) {
      final double x = size.width * (0.28 + (obstacleY * 0.1));

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, size.height * obstacleY),
            width: 45,
            height: 70,
          ),
          const Radius.circular(8),
        ),
        obstaclePaint,
      );
    }

    final double carCenterX = size.width * carX;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(
            carCenterX,
            size.height * 0.82,
          ),
          width: 48,
          height: 80,
        ),
        const Radius.circular(10),
      ),
      carPaint,
    );
  }

  @override
  bool shouldRepaint(covariant RacingPainter oldDelegate) {
    return true;
  }
}
