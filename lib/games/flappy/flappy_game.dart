import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class FlappyGame extends StatefulWidget {
  const FlappyGame({super.key});

  @override
  State<FlappyGame> createState() => _FlappyGameState();
}

class _FlappyGameState extends State<FlappyGame> {
  double birdY = 0.5;
  double velocity = 0.0;
  double pipeX = 1.1;
  double gapY = 0.5;
  int score = 0;
  bool gameOver = false;

  Timer? timer;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(milliseconds: 30),
      (_) => updateGame(),
    );
  }

  void flap() {
    if (gameOver) {
      resetGame();
      return;
    }

    setState(() {
      velocity = -0.012;
    });
  }

  void updateGame() {
    if (!mounted || gameOver) return;

    setState(() {
      velocity += 0.0007;
      birdY += velocity;
      pipeX -= 0.006;

      if (pipeX < -0.2) {
        pipeX = 1.1;
        gapY = 0.25 + random.nextDouble() * 0.5;
        score++;
      }

      final bool outsideScreen = birdY < 0.03 || birdY > 0.97;

      final bool nearPipe = pipeX < 0.25 && pipeX > -0.05;
      final bool hitsPipe =
          nearPipe && (birdY < gapY - 0.18 || birdY > gapY + 0.18);

      if (outsideScreen || hitsPipe) {
        gameOver = true;
        timer?.cancel();
      }
    });
  }

  void resetGame() {
    timer?.cancel();

    setState(() {
      birdY = 0.5;
      velocity = 0.0;
      pipeX = 1.1;
      gapY = 0.5;
      score = 0;
      gameOver = false;
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
      backgroundColor: Colors.lightBlue.shade200,
      appBar: AppBar(
        title: const Text('Flappy'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: flap,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: FlappyPainter(
                  birdY: birdY,
                  pipeX: pipeX,
                  gapY: gapY,
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Score: $score',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Score: $score',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: resetGame,
                        child: const Text('PLAY AGAIN'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FlappyPainter extends CustomPainter {
  final double birdY;
  final double pipeX;
  final double gapY;

  FlappyPainter({
    required this.birdY,
    required this.pipeX,
    required this.gapY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint birdPaint = Paint()..color = Colors.orange;
    final Paint pipePaint = Paint()..color = Colors.green;
    final Paint groundPaint = Paint()..color = Colors.brown;

    final double birdX = size.width * 0.25;
    final double birdPosY = size.height * birdY;

    canvas.drawCircle(
      Offset(birdX, birdPosY),
      18,
      birdPaint,
    );

    final double pipePosition = size.width * pipeX;
    final double gapCenter = size.height * gapY;
    final double gapHeight = size.height * 0.36;

    final double topPipeHeight = gapCenter - gapHeight / 2;
    final double bottomPipeTop = gapCenter + gapHeight / 2;

    canvas.drawRect(
      Rect.fromLTWH(
        pipePosition,
        0,
        55,
        topPipeHeight,
      ),
      pipePaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        pipePosition,
        bottomPipeTop,
        55,
        size.height - bottomPipeTop,
      ),
      pipePaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        size.height - 30,
        size.width,
        30,
      ),
      groundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant FlappyPainter oldDelegate) {
    return true;
  }
}
