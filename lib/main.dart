import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:tower_war/CommonUsed/PageOptions.dart';
import 'package:tower_war/GameScreen/game_options_dialog.dart';
import 'package:tower_war/GameScreen/game_screen.dart';
import 'package:tower_war/Main%20Menu%20Screen/home_screen.dart';
import 'package:tower_war/Settings_screen/settingsScreen.dart';

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
  List<List<String>> board;
  late int numOfRows, numOfColumns;
  Board(this.board) {
    numOfRows = board.length;
    numOfColumns = board[0].length;
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
        if (board[newPoint.rowIndex][newPoint.colIndex] == cellType) {
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
      List<String> row = board[indexOfRow];
      for (var indexOfCol = 0; indexOfCol < numOfColumns; indexOfCol++) {
        String cell = row[indexOfCol];
        if (cell == cellType) {
          board[indexOfRow][indexOfCol] = '.';
        }
      }
    }
    for (var point in line) {
      board[point.rowIndex][point.colIndex] = cellType;
    }
    board[line[0].rowIndex][line[0].colIndex] = "T$cellType";
  }
}

void main() {
  runApp(Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
          onTap: () {
            List<List<String>> grid = [
              ['_', 'TG', 'Y', 'Y', 'Y', 'TR'],
              ['G', 'G', '_', 'R', 'R', 'R'],
              ['G', 'Y', 'Y', '_', 'G', '_'],
              ['Y', 'G', 'G', '_', 'G', 'Y'],
              ['TY', 'Y', 'G', '_', 'G', 'R']
            ];

            Board board = Board(grid);
            List<Point> greenLine = board.checkConnections(
                towerPosition: Point(rowIndex: 4, colIndex: 0), CellType: 'Y');
            print(greenLine);
            board.eraseAllCellTypeOutsideTheLineOfPoints(greenLine, 'Y');
            print(board.board);
          },
          child: Text('data'))));
}

/*void main() {
  runApp(GetMaterialApp(
    initialRoute: PageNames.GamePage,
    getPages: [
      GetPage(
          name: PageNames.GameOptionsDialog,
          page: () => GameOptionsDialog(),
          transition: Transition.cupertino),
      GetPage(
          name: PageNames.HomePage,
          page: () => HomeScreen(),
          transition: Transition.cupertino),
      GetPage(
          name: PageNames.SettingsPage,
          page: () => SettingsScreen(),
          transition: Transition.cupertino),
      GetPage(
          name: PageNames.GamePage,
          page: () => GameScreen(),
          transition: Transition.cupertino),
    ],
    debugShowCheckedModeBanner: false,
  ));
}*/
