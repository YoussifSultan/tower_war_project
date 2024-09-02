import 'package:tower_war/Classes/color_data.dart';
import 'package:tower_war/Classes/point.dart';

class TileData {
  final String tiletypecode;
  final Colordata colordata;
  final Point tilePosition;
  final int numberOfTroops;

  TileData(
      {required this.tilePosition,
      required this.tiletypecode,
      required this.colordata,
      required this.numberOfTroops});

  static List<String> availableTileTypes = [
    'T', // Tower
    'D', //Broken Tower
    'S', // Soldiers
    '.', // Dead Soldiers
    '_', // blank Tile
  ];
}
