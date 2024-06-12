import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tower_war/Classes/colorData.dart';
import 'package:tower_war/Classes/player.dart';

import 'package:undo/undo.dart';

class Point {
  int rowIndex, colIndex;
  Point({
    required this.rowIndex,
    required this.colIndex,
  });
  String toString() {
    return 'rowIndex : ${rowIndex + 1} colIndex : ${colIndex + 1} \n';
  }
}

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
      {required Point towerPosition, required String CellType}) {
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
            getNeighboringCellsPositionIdenticalToCellType(cellPoint, CellType)
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
                int.parse(cell.replaceAll(new RegExp(r'[^0-9]'), ''));
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
    for (var player in GameVariables.activePlayers) {
      String currentTurnColorCode = player.colorData.colorCode;
      Point currentTurnTowerPosition = player.towerPosition;
      Board board = Board();
      List<Point> Line = board.checkConnections(
          towerPosition: currentTurnTowerPosition,
          CellType: currentTurnColorCode);
      player.linePositions = Line;
    }
  }

  static Future<void> checkBoard() async {
    updateTeamsLine();
    for (var player in GameVariables.activePlayers) {
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
    List<Point> pointsOfLine = GameVariables
        .activePlayers[GameVariables.currentPlayerIndex.value].linePositions;
    if (!Board.isThisPointNearTheLine(cellPosition, pointsOfLine)) {
      Get.rawSnackbar(
          messageText: Text(
        'Put The Warrior near the line',
        style: TextStyle(color: Colors.white),
      ));
      return false;
    }

    /* *!SECTION */
    /* *SECTION - Check if there is enough warriors */
    // if (GameVariables.turnRemainingTroops.value == 0) {
    //   Get.rawSnackbar(
    //       messageText: Text(
    //     'There is no warriors left',
    //     style: TextStyle(color: Colors.white),
    //   ));
    //   return false;
    // }
    /* *!SECTION */
    return true;
  }
}

class GameVariables {
  static List<Colordata> availableColors = [
    Colordata(
        color: Color.fromRGBO(240, 73, 79, 1), colorCode: 'R', name: 'red'),
    Colordata(
        color: Color.fromRGBO(76, 179, 212, 1), colorCode: 'B', name: 'blue'),
    Colordata(
        color: Color.fromRGBO(211, 183, 120, 1),
        colorCode: 'Y',
        name: 'yellow'),
    Colordata(
        color: Color.fromRGBO(37, 68, 65, 1), colorCode: 'G', name: 'green'),
  ];
  static Rx<int> currentPlayerIndex = 0.obs;
  static List<Player> activePlayers = [
    Player(
        name: 'Youssif',
        linePositions: [Point(rowIndex: 0, colIndex: 0)],
        colorData: GameVariables.availableColors
            .firstWhere((color) => color.colorCode == 'R'),
        towerPosition: Point(rowIndex: 0, colIndex: 0)),
    Player(
      name: 'Osama',
      linePositions: [Point(rowIndex: 0, colIndex: 7)],
      colorData: GameVariables.availableColors
          .firstWhere((color) => color.colorCode == 'B'),
      towerPosition: Point(rowIndex: 0, colIndex: 7),
    ),
    Player(
        name: 'Khalil',
        linePositions: [Point(rowIndex: 12, colIndex: 7)],
        colorData: GameVariables.availableColors
            .firstWhere((color) => color.colorCode == 'Y'),
        towerPosition: Point(rowIndex: 12, colIndex: 7)),
  ];

  static late SimpleStack<List<List<String>>> historyController;
  static RxInt turnRemainingTroops = 0.obs;

  static List<List<RxString>> grid = [];
}

/* Operation In Action
void main() {
 
    List<List<String>> grid = [
   ['_', '_', '_', '_', '_', '_', '_', '_'],
   ['_', '_', '_', '_', '_', '_', '_', '_'],
   ['_', '_', '_', '_', '_', '_', '_', '_'],
   ['_', '_', '_', '_', '_', '_', '_', '_'],
   ['_', '_', '_', '_', '_', '_', '_', '_'],
   ['_', '_', '_', '_', '_', '_', '_', '_'],
   ['_', '_', '_', '_', '_', '_', '_', '_'],
   ['_', '_', '_', '_', '_', '_', '_', '_'],
   ['_', '_', '_', '_', '_', '_', '_', '_'],
   ['_', '_', '_', '_', '_', '_', '_', '_'],
   ['_', '_', '_', '_', '_', '_', '_', '_'],
   ['_', '_', '_', '_', '_', '_', '_', '_'],
   ['_', '_', '_', '_', '_', '_', '_', '_'],
  
  ];

   Board board = Board(grid);
     List<Point> greenLine = board.checkConnections(
    towerPosition: Point(rowIndex: 4, colIndex: 0), CellType: 'Y');
    print(greenLine);
    board.eraseAllCellTypeOutsideTheLineOfPoints(greenLine, 'Y');
    print(board.board);
  
}
*/
