import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';

class GameShell extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onRestart;
  const GameShell({super.key, required this.title, required this.child, this.onRestart});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title), actions: [if (onRestart != null) IconButton(onPressed: onRestart, icon: const Icon(Icons.refresh))]),
    body: SafeArea(child: child),
  );
}

Future<void> finishGame(BuildContext context, int score, bool win) async {
  await StorageService.recordGame(score: score, win: win);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Result saved • +${win ? 100 : 25} virtual coins')));
  }
}
