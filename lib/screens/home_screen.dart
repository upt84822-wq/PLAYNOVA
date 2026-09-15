import 'package:flutter/material.dart';
import '../core/services/game_registry.dart';
import '../core/widgets/coin_badge.dart';
import '../core/models/game_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  String q = '';
  String cat = 'All';
  @override Widget build(BuildContext context) {
    final games = GameRegistry.allGames.where((g) =>
      (cat == 'All' || g.category == cat) && g.name.toLowerCase().contains(q.toLowerCase())).toList();
    return SafeArea(child: CustomScrollView(slivers: [
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
        child: Row(children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('PLAYNOVA', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
            Text('Your World of Games.')
          ])),
          const CoinBadge()
        ]),
      )),
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.all(18),
        child: TextField(
          onChanged: (v) => setState(() => q = v),
          decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'Search games', filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
        ),
      )),
      SliverToBoxAdapter(child: SizedBox(height: 44, child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        children: ['All','Board','Arcade','Puzzle','Racing','Sports'].map((c) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(label: Text(c), selected: cat == c, onSelected: (_) => setState(() => cat = c)),
        )).toList(),
      ))),
      SliverPadding(
        padding: const EdgeInsets.all(18),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate((_, i) => _GameCard(game: games[i]), childCount: games.length),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.12),
        ),
      )
    ]));
  }
}

class _GameCard extends StatelessWidget {
  final GameModel game;
  const _GameCard({required this.game});
  @override Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: game.builder)),
    child: Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(game.icon, size: 46),
        const SizedBox(height: 12),
        Text(game.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(game.category, style: const TextStyle(fontSize: 12)),
      ],
    ))),
  );
}
