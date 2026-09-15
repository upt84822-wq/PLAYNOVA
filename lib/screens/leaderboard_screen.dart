import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});
  @override Widget build(BuildContext context) => SafeArea(child: Padding(
    padding: const EdgeInsets.all(18),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Leaderboard', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
      const SizedBox(height: 14),
      Card(child: ListTile(leading: const CircleAvatar(child: Text('1')), title: const Text('Demo Champion'), trailing: Text('${StorageService.bestScore}'))),
      Card(child: ListTile(leading: const CircleAvatar(child: Text('2')), title: const Text('Demo Player'), trailing: const Text('750'))),
      Card(child: ListTile(leading: const CircleAvatar(child: Text('3')), title: const Text('Demo Gamer'), trailing: const Text('500'))),
      const SizedBox(height: 12),
      const Text('Demo entries are not real online users.', style: TextStyle(fontSize: 12)),
    ]),
  ));
}
