import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class CoinBadge extends StatelessWidget {
  const CoinBadge({super.key});

  @override
  Widget build(BuildContext context) => Chip(
    avatar: const Icon(Icons.monetization_on, size: 18),
    label: Text('${StorageService.coins}'),
  );
}
