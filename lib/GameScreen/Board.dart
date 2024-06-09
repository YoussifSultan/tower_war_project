import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:tower_war/CommonUsed/Enums.dart';
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

  void eraseAllCellTypeOutsideTheLineOfPoints(
      List<Point> line, String cellType) {
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

  static Future<void> checkBoard() async {
    for (var teamcolor in TeamColors.values) {
      String currentTurnColorCode = teamcolor == TeamColors.red
          ? 'R'
          : teamcolor == TeamColors.blue
              ? 'B'
              : teamcolor == TeamColors.yellow
                  ? 'Y'
                  : teamcolor == TeamColors.green
                      ? "G"
                      : "ufjf";
      Point currentTurnTowerPosition = teamcolor == TeamColors.red
          ? Point(rowIndex: 0, colIndex: 0)
          : teamcolor == TeamColors.blue
              ? Point(rowIndex: 0, colIndex: 8)
              : teamcolor == TeamColors.yellow
                  ? Point(rowIndex: 12, colIndex: 8)
                  : teamcolor == TeamColors.green
                      ? Point(rowIndex: 12, colIndex: 0)
                      : Point(rowIndex: 0, colIndex: 0);
      Board board = Board();
      List<Point> Line = board.checkConnections(
          towerPosition: currentTurnTowerPosition,
          CellType: currentTurnColorCode);
      board.eraseAllCellTypeOutsideTheLineOfPoints(Line, currentTurnColorCode);
      Board.addCurrentGridToHistory();
    }
  }

  static void addCurrentGridToHistory() {
    List<List<String>> currentStringGrid =
        Board.convertListRxStringToListString(GameVariables.grid);
    GameVariables.historyController.modify(currentStringGrid);
  }
}

class GameVariables {
  static Rx<TeamColors> currentTurn = TeamColors.red.obs;
  static String redPlayerName = 'Youssif';
  static String bluePlayerName = 'Osama';
  static String yellowPlayerName = 'Mohammed';
  static String greenPlayerName = 'Khalil';
  static late SimpleStack<List<List<String>>> historyController;

  static List<List<RxString>> grid = [
    [
      'TR100'.obs,
      '_'.obs,
      '_'.obs,
      '_'.obs,
      '_'.obs,
      '_'.obs,
      '_'.obs,
      'TB100'.obs
    ],
    ['_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs],
    ['_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs],
    ['_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs],
    ['_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs],
    ['_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs],
    ['_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs],
    ['_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs],
    ['_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs],
    ['_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs],
    ['_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs],
    ['_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs, '_'.obs],
    [
      'TG100'.obs,
      '_'.obs,
      '_'.obs,
      '_'.obs,
      '_'.obs,
      '_'.obs,
      '_'.obs,
      'TY100'.obs
    ],
  ];
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