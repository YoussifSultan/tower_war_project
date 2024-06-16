import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:tower_war/Classes/color_data.dart';
import 'package:tower_war/Classes/player.dart';
import 'package:tower_war/Classes/point.dart';
import 'package:undo/undo.dart';

class GameVariables {
  static Rx<int> currentPlayerIndex = 0.obs;

  static List<Player> activePlayers = [
    Player(
        isAlive: true,
        name: 'yeoo',
        linePositions: [Point(rowIndex: 0, colIndex: 0)],
        colorData: Colordata.availableColors
            .firstWhere((color) => color.colorCode == 'R'),
        towerPosition: Point(rowIndex: 0, colIndex: 0)),
    Player(
      isAlive: true,
      name: 'osama',
      linePositions: [Point(rowIndex: 0, colIndex: 7)],
      colorData: Colordata.availableColors
          .firstWhere((color) => color.colorCode == 'B'),
      towerPosition: Point(rowIndex: 0, colIndex: 7),
    ),
  ];
  static Player currentPlayer =
      GameVariables.activePlayers[GameVariables.currentPlayerIndex.value];
  static Map<int, Player> leaderboard = {};

  static late SimpleStack<List<List<String>>> historyController;
  static RxBool isCellSelectionModeSelected = false.obs;
  static RxInt turnRemainingTroops = 5.obs;

  static List<List<RxString>> grid = [];
}
