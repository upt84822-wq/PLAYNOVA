import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';
import '../core/widgets/coin_badge.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});
  @override State<RewardsScreen> createState() => _RewardsScreenState();
}
class _RewardsScreenState extends State<RewardsScreen> {
  Future<void> claim() async {
    final ok = await StorageService.claimDaily();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? '500 free virtual coins claimed!' : 'Daily reward already claimed.')));
    setState(() {});
  }
  @override Widget build(BuildContext context) => SafeArea(child: Padding(
    padding: const EdgeInsets.all(18),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [const Expanded(child: Text('Daily Rewards', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900))), const CoinBadge()]),
      const SizedBox(height: 24),
      Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        const Icon(Icons.card_giftcard, size: 65),
        const SizedBox(height: 15),
        const Text('Day 1 Reward', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('+500 FREE virtual coins'),
        const SizedBox(height: 18),
        FilledButton(onPressed: StorageService.dailyClaimed ? null : claim, child: Text(StorageService.dailyClaimed ? 'Claimed Today' : 'Claim Reward')),
      ])))
    ]),
  ));
}
