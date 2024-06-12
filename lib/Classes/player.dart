import 'package:tower_war/Classes/colorData.dart';
import 'package:tower_war/GameScreen/Board.dart';

class Player {
  final Colordata colorData;
  final String name;
  List<Point> linePositions;
  final Point towerPosition;

  Player(
      {required this.towerPosition,
      required this.name,
      required this.linePositions,
      required this.colorData});
}
