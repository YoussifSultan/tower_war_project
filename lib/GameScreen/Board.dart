import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:tower_war/Classes/color_data.dart';
import 'package:tower_war/Classes/player.dart';
import 'package:tower_war/Classes/point.dart';
import 'package:tower_war/CommonUsed/page_options.dart';
import 'package:tower_war/GameScreen/game_variables.dart';

class Board {
  late int numOfRows, numOfColumns;
  Board() {
    numOfRows = GameVariables.grid.length;
    numOfColumns = GameVariables.grid[0].length;
  }

  bool isValid(Point p) {
    //Check geometrically if the point is within the board
    return p.rowIndex >= 0 &&
        p.rowIndex < numOfRows &&
        p.colIndex >= 0 &&
        p.colIndex < numOfColumns;
  }

  List<Point> getNeighboringCellsPositionIdenticalToCellType(
      Point point, String cellType) {
    List<Point> neighbors = [];
    List<List<int>> directions = [
      [-1, -1], // top left
      [-1, 0], // top
      [-1, 1], //top right
      [0, 1], //right
      [1, 1], //bottom right
      [1, 0], //bottom
      [1, -1], //bottom left
      [0, -1], //left
    ];

    for (var direction in directions) {
      Point newPoint = Point(
          rowIndex: point.rowIndex + direction[0],
          colIndex: point.colIndex + direction[1]);
      if (isValid(newPoint)) {
        if (GameVariables.grid[newPoint.rowIndex][newPoint.colIndex]
            .contains(cellType)) {
          neighbors.add(newPoint);
        }
      }
    }

    return neighbors;
  }

  List<Point> getNeighboringCellsPosition(Point point) {
    List<Point> neighbors = [];
    List<List<int>> directions = [
      [-1, -1], // top left
      [-1, 0], // top
      [-1, 1], //top right
      [0, 1], //right
      [1, 1], //bottom right
      [1, 0], //bottom
      [1, -1], //bottom left
      [0, -1], //left
    ];

    for (var direction in directions) {
      Point newPoint = Point(
          rowIndex: point.rowIndex + direction[0],
          colIndex: point.colIndex + direction[1]);
      if (isValid(newPoint)) {
        neighbors.add(newPoint);
      }
    }

    return neighbors;
  }

  List<Point> checkConnections(
      {required Point towerPosition, required String cellType}) {
    // Take the tower position as a starting point for the loop
    // Take the cell Type which is another name for the team color we are looking for its connections
    List<Point> sameColorCellsLinePosition =
        []; //it is a list of the points determined connected to the specified tower
    List<Point> endCellsInSameColorLinePosition =
        []; // its the طرف الخط or in other words the ending points where the loop will refetch again

    endCellsInSameColorLinePosition.add(towerPosition);
    // we add the tower position as a cell containing troops to begin the loop with
    sameColorCellsLinePosition.add(towerPosition);
    // we also add it only to report it in end
    while (endCellsInSameColorLinePosition.isNotEmpty) {
      // this is a while loop if there is end cells we will search for other connections else we would complete the code
      List<Point> newEndingCells = [];
      //temporary list of ending cells because we are looping with the main one
      for (var cellPoint in endCellsInSameColorLinePosition) {
        //the ending cells could be more than one so we loop with each ending cell
        List<Point> neighbouringPointsIdenticalToSameColorCellType =
            getNeighboringCellsPositionIdenticalToCellType(cellPoint, cellType)
                .toList();
        //This is a variable of all cells around the ending cell and has the same cell type

        for (var point in sameColorCellsLinePosition) {
          //this loop deletes all cell that was previously recorded
          neighbouringPointsIdenticalToSameColorCellType.removeWhere(
              (neighbouringpoint) =>
                  neighbouringpoint.rowIndex == point.rowIndex &&
                  neighbouringpoint.colIndex == point.colIndex);
        }
        if (neighbouringPointsIdenticalToSameColorCellType.isNotEmpty) {
          //If the neighbouring point is not empty
          sameColorCellsLinePosition
              .addAll(neighbouringPointsIdenticalToSameColorCellType);
          //we add them to the line of points
          newEndingCells.addAll(neighbouringPointsIdenticalToSameColorCellType);
          //they eventually become the ending points that we will start with again the loop
        }
      }
      endCellsInSameColorLinePosition = newEndingCells;
      //assign the new ending cells and start again
    }
    return sameColorCellsLinePosition;
  }

  static void eraseAllCellTypeOutsideTheLineOfPoints(
      List<Point> line, String cellType) {
    int numOfRows = GameVariables.grid.length;
    int numOfColumns = GameVariables.grid[0].length;
    for (var indexOfRow = 0; indexOfRow < numOfRows; indexOfRow++) {
      List<RxString> row = GameVariables.grid[indexOfRow];
      for (var indexOfCol = 0; indexOfCol < numOfColumns; indexOfCol++) {
        String cell = row[indexOfCol].string;
        if (cell.contains('W') && cell.contains(cellType)) {
          if (line
              .where((point) =>
                  point.rowIndex == indexOfRow && point.colIndex == indexOfCol)
              .isEmpty) {
            int numberOfTroopsInCell =
                int.parse(cell.replaceAll(RegExp(r'[^0-9]'), ''));
            GameVariables.grid[indexOfRow]
                [indexOfCol]('.$numberOfTroopsInCell');
          }
        }
      }
    }
  }

  static List<List<String>> convertListRxStringToListString(
      List<List<RxString>> grid) {
    List<List<String>> gridString = [];
    for (var row in grid) {
      List<String> rowString = [];
      for (var cell in row) {
        rowString.add(cell.value);
      }
      gridString.add(rowString);
    }
    return gridString;
  }

  static void convertListStringToListRxString(List<List<String>> grid) {
    for (var rowIndex = 0;
        rowIndex < GameVariables.grid.length /* num of rows */;
        rowIndex++) {
      for (var colIndex = 0;
          colIndex < GameVariables.grid[0].length /* num of columns */;
          colIndex++) {
        GameVariables.grid[rowIndex][colIndex](grid[rowIndex][colIndex]);
      }
    }
  }

  static void updateTeamsLine() {
    for (var player
        in GameVariables.activePlayers.where((player) => player.isAlive)) {
      String currentTurnColorCode = player.colorData.colorCode;
      Point currentTurnTowerPosition = player.towerPosition;
      Board board = Board();
      List<Point> line = board.checkConnections(
          towerPosition: currentTurnTowerPosition,
          cellType: currentTurnColorCode);
      player.linePositions = line;
    }
  }

  static Future<void> checkBoard() async {
    updateTeamsLine();
    for (var player
        in GameVariables.activePlayers.where((player) => player.isAlive)) {
      String currentTurnColorCode = player.colorData.colorCode;
      Board.eraseAllCellTypeOutsideTheLineOfPoints(
          player.linePositions, currentTurnColorCode);
    }
    Board.addCurrentGridToHistory();
  }

  static void addCurrentGridToHistory() {
    List<List<String>> currentStringGrid =
        Board.convertListRxStringToListString(GameVariables.grid);
    GameVariables.historyController.modify(currentStringGrid);
  }

  static bool isThisPointNearTheLine(Point point, List<Point> pointsOfLine) {
    List<Point> validPoints = [];
    Board board = Board();
    for (var point in pointsOfLine) {
      validPoints.addAll(board.getNeighboringCellsPosition(point));
    }
    if (validPoints
        .where(
            (p) => p.rowIndex == point.rowIndex && p.colIndex == point.colIndex)
        .isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static bool isCellValidToAddWarriors(Point cellPosition) {
    /* *SECTION - Check if the cell belongs to a specified line */
    List<Point> pointsOfLine = GameVariables.currentPlayer.linePositions;
    if (!Board.isThisPointNearTheLine(cellPosition, pointsOfLine)) {
      Get.closeAllSnackbars();
      Get.rawSnackbar(
          messageText: const Text(
        'Put The Warrior near the line',
        style: TextStyle(color: Colors.white),
      ));
      return false;
    }

    /* *!SECTION */
    /* *SECTION - Check if there is enough warriors */
    if (GameVariables.turnRemainingTroops.value == 0) {
      Get.closeAllSnackbars();
      Get.rawSnackbar(
          messageText: const Text(
        'There is no warriors left',
        style: TextStyle(color: Colors.white),
      ));
      return false;
    }
    /* *!SECTION */
    return true;
  }

  static Future<void> checkIfThePlayerHasEnoughTroopsInTower(
      Point towerPosition) async {
    String cellData = GameVariables
        .grid[towerPosition.rowIndex][towerPosition.colIndex].string
        .replaceAll(RegExp(r"[0-9]+"), "");

    int numberOfTroopsInTower = int.parse(GameVariables
        .grid[towerPosition.rowIndex][towerPosition.colIndex].value
        .replaceAll(RegExp(r'[^0-9]'), ''));
    Player player = GameVariables.activePlayers.firstWhere((player) =>
        player.towerPosition.rowIndex == towerPosition.rowIndex &&
        player.towerPosition.colIndex == towerPosition.colIndex);
    /* *SECTION - if the tower doesn't have enough troops & doesn't already exist*/
    if (numberOfTroopsInTower - 5 < 1 &&
        GameVariables.leaderboard.values
            .where((addedplayer) => addedplayer == player)
            .isEmpty) {
      player.linePositions = [];
      Board.eraseAllCellTypeOutsideTheLineOfPoints(
          [], player.colorData.colorCode);
      GameVariables.grid[towerPosition.rowIndex][towerPosition.colIndex](
          'D${Colordata.availableColors.firstWhere((colorData) => cellData.contains(colorData.colorCode)).colorCode}0');
      int placeOfTheDeadPlayer =
          GameVariables.activePlayers.length - GameVariables.leaderboard.length;
      GameVariables.leaderboard.addAll({placeOfTheDeadPlayer: player});
      player.isAlive = false;
    }
  }

  static Future<bool> isTheGameEnded() async {
    int placeOfTheDeadPlayer =
        GameVariables.activePlayers.length - GameVariables.leaderboard.length;

    /* *SECTION - Check if there is only one player */
    if (placeOfTheDeadPlayer == 1) {
      GameVariables.leaderboard.addAll({
        1: GameVariables.activePlayers.firstWhere((player) => player.isAlive)
      });
      for (var player in GameVariables.leaderboard.entries) {
        FlameAudio.play('victory/${player.key}_place.mp3');
        await Get.generalDialog(pageBuilder: (BuildContext context,
            Animation<double> animation, Animation<double> secondaryAnimation) {
          return GestureDetector(
            onTap: () {
              Get.back();
            },
            child: RiveAnimation.asset(
              'assets/animations/victory.riv',
              stateMachines: const ['victory'],
              onInit: (Artboard artboard) {
                final controller =
                    StateMachineController.fromArtboard(artboard, 'victory');
                SMINumber redblueyellowgreenTowerIndex =
                    controller!.findInput<double>('numOfTower') as SMINumber;
                int towerIndex = player.value.colorData.colorCode == "R"
                    ? 1
                    : player.value.colorData.colorCode == "B"
                        ? 2
                        : player.value.colorData.colorCode == "Y"
                            ? 3
                            : player.value.colorData.colorCode == "G"
                                ? 4
                                : 4;
                redblueyellowgreenTowerIndex.change(towerIndex.toDouble());
                final playerNameField =
                    artboard.component<TextValueRun>('playerName');
                playerNameField!.text = player.value.name;
                final placeField = artboard.component<TextValueRun>('order');
                String place = player.key == 1
                    ? 'st'
                    : player.key == 2
                        ? 'nd'
                        : player.key == 3
                            ? 'rd'
                            : player.key == 4
                                ? 'th'
                                : 'th';
                placeField!.text = '${player.key}$place';
                artboard.addController(controller);
              },
            ),
          );
        });
      }
      Get.offAllNamed(PageNames.homePage);
      return true;
    }
    return false;
    /* *!SECTION */
  }

  static void goNextTurn() {
    if (GameVariables.activePlayers[GameVariables.currentPlayerIndex.value] ==
        GameVariables.activePlayers.last) {
      GameVariables.currentPlayerIndex(0);
    } else {
      GameVariables.currentPlayerIndex(
          GameVariables.currentPlayerIndex.value + 1);
    }
    GameVariables.currentPlayer =
        GameVariables.activePlayers[GameVariables.currentPlayerIndex.value];
    Board.checkIfThePlayerHasEnoughTroopsInTower(
        GameVariables.currentPlayer.towerPosition);
  }

  static Future<void> endTurnMethod() async {
    await Board.checkBoard();
    goNextTurn();
    while (!GameVariables.currentPlayer.isAlive) {
      goNextTurn();
    }

    if (!await Board.isTheGameEnded()) {
      Point towerPosition = GameVariables.currentPlayer.towerPosition;
      String cellData = GameVariables
          .grid[towerPosition.rowIndex][towerPosition.colIndex].string
          .replaceAll(RegExp(r"[0-9]+"), "");

      int numberOfTroopsInTower = int.parse(GameVariables
          .grid[towerPosition.rowIndex][towerPosition.colIndex].value
          .replaceAll(RegExp(r'[^0-9]'), ''));
      /* *SECTION - Take 5 warriors from tower & give them to remaining warriors*/

      GameVariables.grid[towerPosition.rowIndex]
          [towerPosition.colIndex]('$cellData${(numberOfTroopsInTower - 5)}');
      GameVariables.turnRemainingTroops(5);
      /* *!SECTION */
      GameVariables.historyController
          .modify(Board.convertListRxStringToListString(GameVariables.grid));
      GameVariables.historyController.clearHistory();
    }
  }
}
