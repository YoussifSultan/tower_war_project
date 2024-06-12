import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:tower_war/Classes/colorData.dart';
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
      Colordata teamColor = GameVariables.availableColors.firstWhere(
          (color) => CellData.value.contains(color.colorCode),
          orElse: () => GameVariables.availableColors[0]);
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
      } else if (cellStatus == TileStatus.BrokenTowerTile) {
        return BrokenTowerTile(
            teamColor: teamColor, cellPosition: CellPosition);
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
  final Colordata teamColor;
  final Point cellPosition;

  final RxInt numOfTroopsInTower;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!Board.isCellValidToAddWarriors(cellPosition)) {
          return;
        }
        String cellData = GameVariables
            .grid[cellPosition.rowIndex][cellPosition.colIndex].string;
        cellData = cellData.replaceAll(new RegExp(r"[0-9]+"), "");
        if (teamColor !=
            GameVariables.activePlayers[GameVariables.currentPlayerIndex.value]
                .colorData) {
          GameVariables.grid[cellPosition.rowIndex][cellPosition.colIndex](
              cellData + '${(numOfTroopsInTower.value - 2)}');
          GameVariables.turnRemainingTroops(
              GameVariables.turnRemainingTroops.value - 1);
          if (numOfTroopsInTower.value < 1) {
            GameVariables.activePlayers[GameVariables.currentPlayerIndex.value]
                .linePositions = [];
            GameVariables.grid[cellPosition.rowIndex]
                [cellPosition.colIndex]('TC${teamColor.colorCode}');
            GameVariables.activePlayers.remove(GameVariables
                .activePlayers[GameVariables.currentPlayerIndex.value]);
          }
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
                'assets/animations/towers/${teamColor.name}tower.riv',
              ),
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

class BrokenTowerTile extends StatelessWidget {
  const BrokenTowerTile(
      {super.key, required this.teamColor, required this.cellPosition});
  final Colordata teamColor;
  final Point cellPosition;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      margin: EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: RiveAnimation.asset(
        'assets/animations/broken_towers/${teamColor.name}brokentower.riv',
        stateMachines: ['State Machine 1'],
      ),
    );
  }
}

class TroopsTile extends StatelessWidget {
  const TroopsTile(
      {super.key,
      required this.teamColor,
      this.numberOfTroops,
      required this.cellPosition});
  final Colordata teamColor;
  final Point cellPosition;
  final RxInt? numberOfTroops;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!Board.isCellValidToAddWarriors(cellPosition)) {
          return;
        }
        String cellData = GameVariables
            .grid[cellPosition.rowIndex][cellPosition.colIndex].string
            .replaceAll(new RegExp(r"[0-9]+"), "");

        if (teamColor ==
            GameVariables.activePlayers[GameVariables.currentPlayerIndex.value]
                .colorData) {
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
          if (!Board.isCellValidToAddWarriors(cellPosition)) {
            return;
          }
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
          if (!Board.isCellValidToAddWarriors(cellPosition)) {
            return;
          }
          String currentTurnColorCode = GameVariables
              .activePlayers[GameVariables.currentPlayerIndex.value]
              .colorData
              .colorCode;

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
