import 'package:flutter/material.dart';

typedef GameBuilder = Widget Function(BuildContext context);

class GameModel {
  final String id;
  final String name;
  final String category;
  final IconData icon;
  final GameBuilder builder;

  const GameModel({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    required this.builder,
  });
}
