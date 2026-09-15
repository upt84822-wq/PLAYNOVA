import 'dart:async';
import 'package:flutter/material.dart';

class PongGame extends StatefulWidget {
  const PongGame({super.key});

  @override
  State<PongGame> createState() => _PongGameState();
}

class _PongGameState extends State<PongGame> {
  double playerY = 0.5;
  double ballX = 0.5;
  double ballY = 0.5;
  double dx = 0.008;
  double dy = 0.006;
  int score = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) => updateGame(),
    );
  }

  void updateGame() {
    if (!mounted) return;

    setState(() {
      ballX += dx;
      ballY += dy;

      if (ballY <= 0 || ballY >= 1) {
        dy = -dy;
      }

      if (ballX <= 0.06 &&
          ballY >= playerY - 0.12 &&
          ballY <= playerY + 0.12) {
        dx = dx.abs();
        score++;
      }

      if (ballX < 0 || ballX > 1) {
        ballX = 0.5;
        ballY = 0.5;
        dx = ballX < 0 ? 0.008 : -0.008;
        dy = 0.006;
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
        title: Text('Pong • Score $score'),
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            playerY = (playerY + details.delta.dy / 400).clamp(0.1, 0.9);
          });
        },
        child: CustomPaint(
          painter: PongPainter(playerY, ballX, ballY),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class PongPainter extends CustomPainter {
  final double playerY;
  final double ballX;
  final double ballY;

  PongPainter(this.playerY, this.ballX, this.ballY);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    canvas.drawRect(
      Rect.fromLTWH(12, playerY * size.height - 45, 12, 90),
      paint,
    );

    canvas.drawRect(
      Rect.fromLTWH(size.width - 24, ballY * size.height - 45, 12, 90),
      paint,
    );

    canvas.drawCircle(
      Offset(ballX * size.width, ballY * size.height),
      9,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant PongPainter oldDelegate) => true;
}
