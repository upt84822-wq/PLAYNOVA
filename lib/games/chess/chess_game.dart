import 'package:flutter/material.dart';

class ChessGame extends StatefulWidget {
  const ChessGame({super.key});

  @override
  State<ChessGame> createState() => _ChessGameState();
}

class _ChessGameState extends State<ChessGame> {
  final List<String> pieces = [
    '♜','♞','♝','♛','♚','♝','♞','♜',
    '♟','♟','♟','♟','♟','♟','♟','♟',
    '','','','','','','','',
    '','','','','','','','',
    '','','','','','','','',
    '','','','','','','','',
    '♙','♙','♙','♙','♙','♙','♙','♙',
    '♖','♘','♗','♕','♔','♗','♘','♖',
  ];

  int? selected;
  bool whiteTurn = true;

  void tapSquare(int index) {
    setState(() {
      if (selected == null) {
        if (pieces[index].isNotEmpty) {
          selected = index;
        }
        return;
      }

      if (selected == index) {
        selected = null;
        return;
      }

      pieces[index] = pieces[selected!];
      pieces[selected!] = '';
      selected = null;
      whiteTurn = !whiteTurn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chess • ${whiteTurn ? "White" : "Black"} turn'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
            ),
            itemCount: 64,
            itemBuilder: (context, index) {
              final row = index ~/ 8;
              final col = index % 8;
              final dark = (row + col).isOdd;

              return GestureDetector(
                onTap: () => tapSquare(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: dark
                        ? Colors.brown.shade400
                        : Colors.orange.shade100,
                    border: selected == index
                        ? Border.all(width: 3)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      pieces[index],
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
