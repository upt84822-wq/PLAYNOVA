import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  final Random random = Random();
  Timer? timer;
  List<Point<int>> snake = [const Point(5, 5), const Point(4, 5)];
  Point<int> food = const Point(10, 10);
  int dx = 1;
  int dy = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(milliseconds: 180), (_) => tick());
  }

  void resetGame() {
    setState(() {
      snake = [const Point(5, 5), const Point(4, 5)];
      food = const Point(10, 10);
      score = 0;
      dx = 1;
      dy = 0;
    });
    startGame();
  }

  void dir(int x, int y) {
    if (x == -dx && y == -dy) return;
    dx = x;
    dy = y;
  }

  void tick() {
    if (!mounted) return;

    final head = snake.first;
    final next = Point(head.x + dx, head.y + dy);

    if (next.x < 0 ||
        next.x >= 15 ||
        next.y < 0 ||
        next.y >= 20 ||
        snake.contains(next)) {
      timer?.cancel();
      return;
    }

    setState(() {
      snake.insert(0, next);

      if (next == food) {
        score++;
        food = Point(random.nextInt(15), random.nextInt(20));
      } else {
        snake.removeLast();
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
        title: Text('Snake • Score $score'),
        actions: [
          IconButton(
            onPressed: resetGame,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 15 / 20,
                child: CustomPaint(
                  painter: SnakePainter(snake, food),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => dir(0, -1),
                icon: const Icon(Icons.arrow_upward),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => dir(-1, 0),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 40),
              IconButton(
                onPressed: () => dir(1, 0),
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => dir(0, 1),
                icon: const Icon(Icons.arrow_downward),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class SnakePainter extends CustomPainter {
  final List<Point<int>> snake;
  final Point<int> food;

  SnakePainter(this.snake, this.food);

  @override
  void paint(Canvas canvas, Size size) {
    final cellW = size.width / 15;
    final cellH = size.height / 20;

    final snakePaint = Paint()..style = PaintingStyle.fill;
    final foodPaint = Paint()..style = PaintingStyle.fill;

    for (final p in snake) {
      canvas.drawRect(
        Rect.fromLTWH(
          p.x * cellW,
          p.y * cellH,
          cellW - 1,
          cellH - 1,
        ),
        snakePaint,
      );
    }

    canvas.drawCircle(
      Offset(
        (food.x + 0.5) * cellW,
        (food.y + 0.5) * cellH,
      ),
      min(cellW, cellH) * 0.4,
      foodPaint,
    );
  }

  @override
  bool shouldRepaint(covariant SnakePainter oldDelegate) => true;
}
