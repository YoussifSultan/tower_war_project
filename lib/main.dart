import 'package:flutter/material.dart';
import 'package:flame/game.dart';

void main() {
  final FlameGame game = FlameGame();
  runApp(GameWidget(game: game));
}
