import 'dart:async';
import 'package:flutter/material.dart';

class BreakoutGame extends StatefulWidget {
  const BreakoutGame({super.key});

  @override
  State<BreakoutGame> createState() => _BreakoutGameState();
}

class _BreakoutGameState extends State<BreakoutGame> {
  Timer? timer;

  double ballX = 0.5;
  double ballY = 0.75;
  double dx = 0.012;
  double dy = -0.015;
  double paddleX = 0.5;

  int score = 0;
  bool gameOver = false;

  final List<bool> bricks = List.filled(30, true);

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(milliseconds: 30),
      (_) => updateGame(),
    );
  }

  void updateGame() {
    if (!mounted || gameOver) return;

    setState(() {
      ballX += dx;
      ballY += dy;

      if (ballX <= 0.02 || ballX >= 0.98) {
        dx = -dx;
      }

      if (ballY <= 0.02) {
        dy = -dy;
      }

      if (ballY > 0.84 &&
          ballY < 0.91 &&
          (ballX - paddleX).abs() < 0.16) {
        dy = -dy.abs();
      }

      final int column = (ballX * 6).floor();
      final int row = (ballY * 10).floor();

      if (row >= 1 && row <= 5 && column >= 0 && column < 6) {
        final int index = (row - 1) * 6 + column;

        if (bricks[index]) {
          bricks[index] = false;
          score += 10;
          dy = -dy;
        }
      }

      if (ballY >= 1.0) {
        gameOver = true;
        timer?.cancel();
      }

      if (!bricks.contains(true)) {
        gameOver = true;
        timer?.cancel();
      }
    });
  }

  void movePaddle(DragUpdateDetails details, double width) {
    setState(() {
      paddleX += details.delta.dx / width;

      if (paddleX < 0.12) {
        paddleX = 0.12;
      }

      if (paddleX > 0.88) {
        paddleX = 0.88;
      }
    });
  }

  void restart() {
    timer?.cancel();

    setState(() {
      ballX = 0.5;
      ballY = 0.75;
      dx = 0.012;
      dy = -0.015;
      paddleX = 0.5;
      score = 0;
      gameOver = false;

      for (int i = 0; i < bricks.length; i++) {
        bricks[i] = true;
      }
    });

    timer = Timer.periodic(
      const Duration(milliseconds: 30),
      (_) => updateGame(),
    );
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
        title: const Text('Breakout'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                'Score: $score',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onHorizontalDragUpdate: (details) {
              movePaddle(details, constraints.maxWidth);
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: BreakoutPainter(
                      ballX: ballX,
                      ballY: ballY,
                      paddleX: paddleX,
                      bricks: bricks,
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
                          Text(
                            bricks.contains(true) ? 'GAME OVER' : 'YOU WIN!',
                            style: const TextStyle(
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
                            onPressed: restart,
                            child: const Text('PLAY AGAIN'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BreakoutPainter extends CustomPainter {
  final double ballX;
  final double ballY;
  final double paddleX;
  final List<bool> bricks;

  BreakoutPainter({
    required this.ballX,
    required this.ballY,
    required this.paddleX,
    required this.bricks,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint ballPaint = Paint()..color = Colors.orange;
    final Paint paddlePaint = Paint()..color = Colors.blue;
    final Paint brickPaint = Paint()..color = Colors.red;

    canvas.drawCircle(
      Offset(size.width * ballX, size.height * ballY),
      9,
      ballPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * paddleX, size.height * 0.9),
          width: size.width * 0.25,
          height: 14,
        ),
        const Radius.circular(8),
      ),
      paddlePaint,
    );

    for (int i = 0; i < bricks.length; i++) {
      if (!bricks[i]) continue;

      final int row = i ~/ 6;
      final int column = i % 6;

      final double x = column * size.width / 6;
      final double y = row * size.height * 0.06 + size.height * 0.05;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x + 3,
            y + 3,
            size.width / 6 - 6,
            size.height * 0.05,
          ),
          const Radius.circular(4),
        ),
        brickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BreakoutPainter oldDelegate) {
    return true;
  }
}
