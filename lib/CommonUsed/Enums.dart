import 'dart:ui';

import 'package:tower_war/GameScreen/Board.dart';

enum TileStatus {
  blankTile,
  deadTroopsTile,
  TroopsTile,
  TowerTile,
}

enum SelectedMode {
  AddTroops,
  ReduceTroops,
}

enum TeamColors { red, blue, yellow, green }

class Convertions {
  static Color getColorOfCurrentTurn() {
    return GameVariables.currentTurn.value == TeamColors.red
        ? Color.fromRGBO(240, 73, 79, 1)
        : GameVariables.currentTurn.value == TeamColors.blue
            ? Color.fromRGBO(76, 179, 212, 1)
            : GameVariables.currentTurn.value == TeamColors.yellow
                ? Color.fromRGBO(211, 183, 120, 1)
                : GameVariables.currentTurn.value == TeamColors.green
                    ? Color.fromRGBO(37, 68, 65, 1)
                    : Color.fromRGBO(37, 68, 65, 1);
  }

  static Point getTowerPositionFromTeamColorEnum(TeamColors teamcolor) {
    return teamcolor == TeamColors.red
        ? Point(rowIndex: 0, colIndex: 0)
        : teamcolor == TeamColors.blue
            ? Point(rowIndex: 0, colIndex: 7)
            : teamcolor == TeamColors.yellow
                ? Point(rowIndex: 12, colIndex: 7)
                : teamcolor == TeamColors.green
                    ? Point(rowIndex: 12, colIndex: 0)
                    : Point(rowIndex: 0, colIndex: 0);
  }

  static String getColorCodeFromTeamColorEnum(TeamColors teamcolor) {
    return teamcolor == TeamColors.red
        ? 'R'
        : teamcolor == TeamColors.blue
            ? 'B'
            : teamcolor == TeamColors.yellow
                ? 'Y'
                : teamcolor == TeamColors.green
                    ? "G"
                    : "ufjf";
  }

  static List<Point> getLinePostionAccordingToTheCurrentTurnOfATeam() {
    return GameVariables.currentTurn.value == TeamColors.red
        ? GameVariables.redLinePositions
        : GameVariables.currentTurn.value == TeamColors.blue
            ? GameVariables.blueLinePositions
            : GameVariables.currentTurn.value == TeamColors.yellow
                ? GameVariables.yellowLinePosition
                : GameVariables.currentTurn.value == TeamColors.green
                    ? GameVariables.greenLinePosition
                    : GameVariables.redLinePositions;
  }

  static TeamColors GetTeamColorFromCellData(String CellData) {
    return CellData.contains('R')
        ? TeamColors.red
        : CellData.contains('B')
            ? TeamColors.blue
            : CellData.contains('Y')
                ? TeamColors.yellow
                : CellData.contains('G')
                    ? TeamColors.green
                    : TeamColors.green;
  }

  static TileStatus GetCellStatusFromCellData(String CellData) {
    return CellData.contains('T')
        ? TileStatus.TowerTile
        : CellData.contains('W')
            ? TileStatus.TroopsTile
            : CellData.contains('.')
                ? TileStatus.deadTroopsTile
                : CellData == '_'
                    ? TileStatus.blankTile
                    : TileStatus.blankTile;
  }
}
