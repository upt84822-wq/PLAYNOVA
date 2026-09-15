import 'dart:async';
import 'package:flutter/material.dart';
import 'main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1300), () {
      if (mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainNavigationScreen()));
    });
  }
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.sports_esports, size: 82),
      SizedBox(height: 18),
      Text('PLAYNOVA', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
      SizedBox(height: 6),
      Text('Your World of Games.')
    ])),
  );
}
