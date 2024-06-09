import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:rive/rive.dart';
import 'package:tower_war/CommonUsed/Enums.dart';
import 'package:tower_war/GameScreen/Board.dart';

class CustomTile extends StatelessWidget {
  const CustomTile(
      {super.key, required this.CellData, required this.CellPosition});

  final RxString CellData;
  final Point CellPosition;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      TileStatus cellStatus =
          Convertions.GetCellStatusFromCellData(CellData.value);
      TeamColors teamColor =
          Convertions.GetTeamColorFromCellData(CellData.value);
      if (cellStatus == TileStatus.TowerTile) {
        int numberOfTroopsInTower =
            int.parse(CellData.value.replaceAll(new RegExp(r'[^0-9]'), ''));

        return TowerTile(
            teamColor: teamColor,
            numOfTroopsInTower: numberOfTroopsInTower.obs,
            cellPosition: CellPosition);
      } else if (cellStatus == TileStatus.TroopsTile) {
        int numberOfTroopsInCell =
            int.parse(CellData.value.replaceAll(new RegExp(r'[^0-9]'), ''));
        return TroopsTile(
          teamColor: teamColor,
          numberOfTroops: numberOfTroopsInCell.obs,
          cellPosition: CellPosition,
        );
      } else if (cellStatus == TileStatus.deadTroopsTile) {
        int numberOfDeadTroopsInCell =
            int.parse(CellData.value.replaceAll(new RegExp(r'[^0-9]'), ''));
        return DeadTroopsTile(
            numberOfTroops: numberOfDeadTroopsInCell.obs,
            cellPosition: CellPosition);
      } else {
        return BlankTile(cellPosition: CellPosition);
      }
    });
  }
}

class TowerTile extends StatelessWidget {
  const TowerTile(
      {super.key,
      required this.teamColor,
      required this.numOfTroopsInTower,
      required this.cellPosition});
  final TeamColors teamColor;
  final Point cellPosition;

  final RxInt numOfTroopsInTower;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /* *SECTION - Check if the cell belongs to a specified line */
        List<Point> pointsOfLine =
            Convertions.getLinePostionAccordingToTheCurrentTurnOfATeam();
        if (!Board.isThisPointNearTheLine(cellPosition, pointsOfLine)) {
          Get.rawSnackbar(
              messageText: Text(
            'Put The Warrior near the line',
            style: TextStyle(color: Colors.white),
          ));
          return;
        }

        /* *!SECTION */
        /* *SECTION - Check if there is enough warriors */
        if (GameVariables.turnRemainingTroops.value == 0) {
          Get.rawSnackbar(
              messageText: Text(
            'There is no warriors left',
            style: TextStyle(color: Colors.white),
          ));
          return;
        }
        /* *!SECTION */
        String cellData = GameVariables
            .grid[cellPosition.rowIndex][cellPosition.colIndex].string;
        cellData = cellData.replaceAll(new RegExp(r"[0-9]+"), "");
        if (teamColor != GameVariables.currentTurn.value) {
          GameVariables.grid[cellPosition.rowIndex][cellPosition.colIndex](
              cellData + '${(numOfTroopsInTower.value - 2)}');
          GameVariables.turnRemainingTroops(
              GameVariables.turnRemainingTroops.value - 1);
          Board.addCurrentGridToHistory();
        }
      },
      child: Container(
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.center,
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Stack(
            children: [
              RiveAnimation.asset(
                  'assets/animations/towers/${teamColor.name}tower.riv'),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                    ),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Text(
                    numOfTroopsInTower.string,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class TroopsTile extends StatelessWidget {
  const TroopsTile(
      {super.key,
      required this.teamColor,
      this.numberOfTroops,
      required this.cellPosition});
  final TeamColors teamColor;
  final Point cellPosition;
  final RxInt? numberOfTroops;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /* *SECTION - Check if the cell belongs to a specified line */
        List<Point> pointsOfLine =
            Convertions.getLinePostionAccordingToTheCurrentTurnOfATeam();
        ;
        if (!Board.isThisPointNearTheLine(cellPosition, pointsOfLine)) {
          Get.rawSnackbar(
              messageText: Text(
            'Put The Warrior near the line',
            style: TextStyle(color: Colors.white),
          ));
          return;
        }
        /* *!SECTION */
        /* *SECTION - Check if there is enough warriors */
        if (GameVariables.turnRemainingTroops.value == 0) {
          Get.rawSnackbar(
              messageText: Text(
            'There is no warriors left',
            style: TextStyle(color: Colors.white),
          ));
          return;
        }
        /* *!SECTION */
        String cellData = GameVariables
            .grid[cellPosition.rowIndex][cellPosition.colIndex].string;

        if (teamColor == GameVariables.currentTurn.value) {
          GameVariables.grid[cellPosition.rowIndex][cellPosition.colIndex](
              cellData + '${(numberOfTroops!.value + 1)}');
        } else {
          GameVariables.grid[cellPosition.rowIndex][cellPosition.colIndex](
              cellData + '${(numberOfTroops!.value - 1)}');
          if (numberOfTroops!.value == 1) {
            GameVariables.grid[cellPosition.rowIndex]
                [cellPosition.colIndex]("_");
          }
        }
        GameVariables.turnRemainingTroops(
            GameVariables.turnRemainingTroops.value - 1);
        Board.addCurrentGridToHistory();
        Board.updateTeamsLine();
      },
      child: Container(
          alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Stack(
            children: [
              RiveAnimation.asset(
                  'assets/animations/warriors/${teamColor.name}warrior.riv'),
              numberOfTroops!.value == 1
                  ? SizedBox()
                  : Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                            )),
                        child: Text(
                          numberOfTroops!.string,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
            ],
          )),
    );
  }
}

class DeadTroopsTile extends StatelessWidget {
  const DeadTroopsTile({
    super.key,
    this.numberOfTroops,
    required this.cellPosition,
  });
  final RxInt? numberOfTroops;
  final Point cellPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          /* *SECTION - Check if the cell belongs to a specified line */
          List<Point> pointsOfLine =
              Convertions.getLinePostionAccordingToTheCurrentTurnOfATeam();
          ;
          if (!Board.isThisPointNearTheLine(cellPosition, pointsOfLine)) {
            Get.rawSnackbar(
                messageText: Text(
              'Put The Warrior near the line',
              style: TextStyle(color: Colors.white),
            ));
            return;
          }

          /* *!SECTION */
          /* *SECTION - Check if there is enough warriors */
          if (GameVariables.turnRemainingTroops.value == 0) {
            Get.rawSnackbar(
                messageText: Text(
              'There is no warriors left',
              style: TextStyle(color: Colors.white),
            ));
            return;
          }
          /* *!SECTION */
          String cellData = GameVariables
              .grid[cellPosition.rowIndex][cellPosition.colIndex].string;
          String celltype = cellData.replaceAll(new RegExp(r"[0-9]+"), "");
          GameVariables.grid[cellPosition.rowIndex][cellPosition.colIndex](
              celltype + '${(numberOfTroops!.value - 1)}');
          if (numberOfTroops!.value == 1) {
            GameVariables.grid[cellPosition.rowIndex]
                [cellPosition.colIndex]("_");
          }
          GameVariables.turnRemainingTroops(
              GameVariables.turnRemainingTroops.value - 1);
          Board.addCurrentGridToHistory();
          Board.updateTeamsLine();
        },
        child: Container(
            alignment: Alignment.center,
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Stack(children: [
              RiveAnimation.asset('assets/animations/warriors/deadwarrior.riv'),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                      )),
                  child: Text(
                    numberOfTroops!.string,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ])));
  }
}

class BlankTile extends StatelessWidget {
  const BlankTile({
    super.key,
    required this.cellPosition,
  });
  final Point cellPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          /* *SECTION - Check if the cell belongs to a specified line */
          List<Point> pointsOfLine =
              Convertions.getLinePostionAccordingToTheCurrentTurnOfATeam();

          if (!Board.isThisPointNearTheLine(cellPosition, pointsOfLine)) {
            Get.rawSnackbar(
                messageText: Text(
              'Put The Warrior near the line',
              style: TextStyle(color: Colors.white),
            ));
            return;
          }

          /* *!SECTION */
          /* *SECTION - Check if there is enough warriors */
          if (GameVariables.turnRemainingTroops.value == 0) {
            Get.rawSnackbar(
                messageText: Text(
              'There is no warriors left',
              style: TextStyle(color: Colors.white),
            ));
            return;
          }
          /* *!SECTION */
          String currentTurnColorCode =
              Convertions.getColorCodeFromTeamColorEnum(
                  GameVariables.currentTurn.value);

          GameVariables.grid[cellPosition.rowIndex]
              [cellPosition.colIndex]('W${currentTurnColorCode}1');
          GameVariables.turnRemainingTroops(
              GameVariables.turnRemainingTroops.value - 1);

          Board.addCurrentGridToHistory();
          Board.updateTeamsLine();
        },
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(1),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
        ));
  }
}
