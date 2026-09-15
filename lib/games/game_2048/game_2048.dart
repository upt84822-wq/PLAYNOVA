import 'dart:math';
import 'package:flutter/material.dart';

class Game2048 extends StatefulWidget {
  const Game2048({super.key});

  @override
  State<Game2048> createState() => _Game2048State();
}

class _Game2048State extends State<Game2048> {
  final Random random = Random();
  List<List<int>> board = [];
  int score = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    board = List.generate(4, (_) => List.filled(4, 0));
    score = 0;
    addTile();
    addTile();
  }

  void addTile() {
    final empty = <Point<int>>[];

    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        if (board[r][c] == 0) {
          empty.add(Point(r, c));
        }
      }
    }

    if (empty.isEmpty) return;

    final position = empty[random.nextInt(empty.length)];
    board[position.x][position.y] = random.nextInt(10) == 0 ? 4 : 2;
  }

  List<int> mergeLine(List<int> line) {
    final values = line.where((value) => value != 0).toList();
    final result = <int>[];
    int i = 0;

    while (i < values.length) {
      if (i + 1 < values.length && values[i] == values[i + 1]) {
        final merged = values[i] * 2;
        result.add(merged);
        score += merged;
        i += 2;
      } else {
        result.add(values[i]);
        i++;
      }
    }

    while (result.length < 4) {
      result.add(0);
    }

    return result;
  }

  void moveLeft() {
    bool changed = false;

    for (int r = 0; r < 4; r++) {
      final old = List<int>.from(board[r]);
      final next = mergeLine(old);

      if (!_same(old, next)) {
        changed = true;
      }

      board[r] = next;
    }

    if (changed) {
      addTile();
      setState(() {});
    }
  }

  void moveRight() {
    bool changed = false;

    for (int r = 0; r < 4; r++) {
      final old = List<int>.from(board[r]);
      final reversed = old.reversed.toList();
      final merged = mergeLine(reversed);
      final next = merged.reversed.toList();

      if (!_same(old, next)) {
        changed = true;
      }

      board[r] = next;
    }

    if (changed) {
      addTile();
      setState(() {});
    }
  }

  void moveUp() {
    bool changed = false;

    for (int c = 0; c < 4; c++) {
      final column = <int>[];

      for (int r = 0; r < 4; r++) {
        column.add(board[r][c]);
      }

      final next = mergeLine(column);

      for (int r = 0; r < 4; r++) {
        if (board[r][c] != next[r]) {
          changed = true;
        }
        board[r][c] = next[r];
      }
    }

    if (changed) {
      addTile();
      setState(() {});
    }
  }

  void moveDown() {
    bool changed = false;

    for (int c = 0; c < 4; c++) {
      final column = <int>[];

      for (int r = 0; r < 4; r++) {
        column.add(board[r][c]);
      }

      final reversed = column.reversed.toList();
      final merged = mergeLine(reversed);
      final next = merged.reversed.toList();

      for (int r = 0; r < 4; r++) {
        if (board[r][c] != next[r]) {
          changed = true;
        }
        board[r][c] = next[r];
      }
    }

    if (changed) {
      addTile();
      setState(() {});
    }
  }

  bool _same(List<int> a, List<int> b) {
    for (int i = 0; i < 4; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void handleSwipe(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond;

    if (velocity.dx.abs() > velocity.dy.abs()) {
      if (velocity.dx > 0) {
        moveRight();
      } else {
        moveLeft();
      }
    } else {
      if (velocity.dy > 0) {
        moveDown();
      } else {
        moveUp();
      }
    }
  }

  Color tileColor(int value) {
    if (value == 0) return Colors.black12;
    if (value == 2) return Colors.white;
    if (value == 4) return Colors.amber.shade100;
    if (value == 8) return Colors.orange.shade300;
    if (value == 16) return Colors.orange.shade500;
    if (value == 32) return Colors.deepOrange;
    if (value == 64) return Colors.red;
    return Colors.deepPurple;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2048'),
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
      body: GestureDetector(
        onHorizontalDragEnd: handleSwipe,
        onVerticalDragEnd: handleSwipe,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.brown.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 16,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final row = index ~/ 4;
                  final col = index % 4;
                  final value = board[row][col];

                  return Container(
                    decoration: BoxDecoration(
                      color: tileColor(value),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: value == 0
                          ? const SizedBox()
                          : Text(
                              '$value',
                              style: TextStyle(
                                fontSize: value >= 100 ? 24 : 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            startGame();
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
