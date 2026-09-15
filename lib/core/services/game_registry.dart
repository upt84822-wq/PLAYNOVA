import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../../games/ludo/ludo_game.dart';
import '../../games/chess/chess_game.dart';
import '../../games/snake/snake_game.dart';
import '../../games/tic_tac_toe/tic_tac_toe_game.dart';
import '../../games/pong/pong_game.dart';
import '../../games/breakout/breakout_game.dart';
import '../../games/game_2048/game_2048.dart';
import '../../games/memory_match/memory_match_game.dart';
import '../../games/bubble_shooter/bubble_shooter_game.dart';
import '../../games/car_racing/car_racing_game.dart';
import '../../games/endless_runner/endless_runner_game.dart';
import '../../games/flappy/flappy_game.dart';
import '../../games/block_puzzle/block_puzzle_game.dart';
import '../../games/number_puzzle/number_puzzle_game.dart';
import '../../games/target_shooter/target_shooter_game.dart';
import '../../games/basketball/basketball_game.dart';
import '../../games/penalty_shootout/penalty_shootout_game.dart';

class GameRegistry {
  static final List<GameModel> allGames = [
    GameModel(id:'ludo', name:'Ludo', category:'Board', icon:Icons.casino, builder: (_) => const LudoGame()),
    GameModel(id:'chess', name:'Chess', category:'Board', icon:Icons.grid_4x4, builder: (_) => const ChessGame()),
    GameModel(id:'snake', name:'Snake', category:'Arcade', icon:Icons.pets, builder: (_) => const SnakeGame()),
    GameModel(id:'ttt', name:'Tic-Tac-Toe', category:'Board', icon:Icons.close, builder: (_) => const TicTacToeGame()),
    GameModel(id:'pong', name:'Pong', category:'Arcade', icon:Icons.sports_tennis, builder: (_) => const PongGame()),
    GameModel(id:'breakout', name:'Breakout', category:'Arcade', icon:Icons.view_module, builder: (_) => const BreakoutGame()),
    GameModel(id:'2048', name:'2048', category:'Puzzle', icon:Icons.looks_4, builder: (_) => const Game2048()),
    GameModel(id:'memory', name:'Memory Match', category:'Puzzle', icon:Icons.style, builder: (_) => const MemoryMatchGame()),
    GameModel(id:'bubble', name:'Bubble Shooter', category:'Arcade', icon:Icons.circle, builder: (_) => const BubbleShooterGame()),
    GameModel(id:'racing', name:'Car Racing', category:'Racing', icon:Icons.directions_car, builder: (_) => const CarRacingGame()),
    GameModel(id:'runner', name:'Endless Runner', category:'Arcade', icon:Icons.directions_run, builder: (_) => const EndlessRunnerGame()),
    GameModel(id:'flappy', name:'Flappy Arcade', category:'Arcade', icon:Icons.flight, builder: (_) => const FlappyGame()),
    GameModel(id:'blocks', name:'Block Puzzle', category:'Puzzle', icon:Icons.dashboard, builder: (_) => const BlockPuzzleGame()),
    GameModel(id:'numbers', name:'Number Puzzle', category:'Puzzle', icon:Icons.pin, builder: (_) => const NumberPuzzleGame()),
    GameModel(id:'target', name:'Target Shooter', category:'Arcade', icon:Icons.gps_fixed, builder: (_) => const TargetShooterGame()),
    GameModel(id:'basketball', name:'Basketball', category:'Sports', icon:Icons.sports_basketball, builder: (_) => const BasketballGame()),
    GameModel(id:'football', name:'Penalty Shootout', category:'Sports', icon:Icons.sports_soccer, builder: (_) => const PenaltyShootoutGame()),
  ];
}
