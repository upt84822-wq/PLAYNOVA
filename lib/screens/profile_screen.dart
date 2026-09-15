import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  bool sound = StorageService.sound;
  @override Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Profile', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
    const SizedBox(height: 18),
    const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 44)),
    const SizedBox(height: 10),
    Center(child: Text(StorageService.username, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
    const SizedBox(height: 22),
    Card(child: Column(children: [
      ListTile(title: const Text('Virtual Coins'), trailing: Text('${StorageService.coins}')),
      ListTile(title: const Text('Games Played'), trailing: Text('${StorageService.gamesPlayed}')),
      ListTile(title: const Text('Wins'), trailing: Text('${StorageService.wins}')),
      ListTile(title: const Text('Best Score'), trailing: Text('${StorageService.bestScore}')),
    ])),
    Card(child: SwitchListTile(title: const Text('Sound'), value: sound, onChanged: (v) async { await StorageService.setSound(v); setState(() => sound = v); })),
  ]));
}
