import 'package:flutter/material.dart';
import '../core/services/game_registry.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});
  @override Widget build(BuildContext context) => SafeArea(child: Padding(
    padding: const EdgeInsets.all(18),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('All Games', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
      const SizedBox(height: 16),
      Expanded(child: GridView.builder(
        itemCount: GameRegistry.allGames.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.1),
        itemBuilder: (_, i) {
          final g = GameRegistry.allGames[i];
          return Card(child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: g.builder)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(g.icon, size: 44), const SizedBox(height: 10), Text(g.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))]),
          ));
        },
      ))
    ]),
  ));
}
