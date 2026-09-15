import 'dart:math';
import 'package:flutter/material.dart';

class BlockPuzzleGame extends StatefulWidget {
  const BlockPuzzleGame({super.key});

  @override
  State<BlockPuzzleGame> createState() => _BlockPuzzleGameState();
}

class _BlockPuzzleGameState extends State<BlockPuzzleGame> {
  final Random random = Random();
  final List<List<bool>> board =
      List.generate(8, (_) => List.filled(8, false));
  int score = 0;

  void addBlock() {
    setState(() {
      final x = random.nextInt(8);
      final y = random.nextInt(8);
      board[y][x] = true;
      score += 10;
    });
  }

  void clearBoard() {
    setState(() {
      for (final row in board) {
        row.fillRange(0, row.length, false);
      }
      score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Block Puzzle • $score'),
        actions: [
          IconButton(
            onPressed: clearBoard,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                  ),
                  itemCount: 64,
                  itemBuilder: (context, index) {
                    final y = index ~/ 8;
                    final x = index % 8;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          board[y][x] = !board[y][x];
                          if (board[y][x]) score += 10;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: board[y][x]
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: addBlock,
              icon: const Icon(Icons.add),
              label: const Text('ADD BLOCK'),
            ),
          ),
        ],
      ),
    );
  }
}
