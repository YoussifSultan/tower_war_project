import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:tower_war/Classes/tile_data.dart';
import 'package:tower_war/Classes/color_data.dart';
import 'package:tower_war/GameScreen/board.dart';
import 'package:tower_war/Classes/point.dart';
import 'package:tower_war/GameScreen/game_variables.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({super.key, required this.cellData, required this.position});

  final RxString cellData;
  final Point position;
  @override
  Widget build(BuildContext context) {
    int numberOfTroops = 0;
    return Obx(() {
      if (int.tryParse(cellData.value.replaceAll(RegExp(r'[^0-9]'), '')) !=
          null) {
        numberOfTroops =
            int.parse(cellData.value.replaceAll(RegExp(r'[^0-9]'), ''));
      }
      TileData tileData = TileData(
          tilePosition: position,
          tiletypecode: TileData.availableTileTypes.firstWhere((code) {
            return cellData.value.contains(code);
          }),
          colordata: Colordata.availableColors.firstWhere(
              (color) => cellData.value.contains(color.colorCode),
              orElse: () => Colordata.availableColors[0]),
          numberOfTroops: numberOfTroops);
      if (tileData.tiletypecode == "T") {
        return TowerTile(
          tileData: tileData,
        );
      } else if (tileData.tiletypecode == "W") {
        return TroopsTile(tileData: tileData);
      } else if (tileData.tiletypecode == ".") {
        return DeadTroopsTile(tileData: tileData);
      } else if (tileData.tiletypecode == "D") {
        return BrokenTowerTile(tileData: tileData);
      } else {
        return BlankTile(tileData: tileData);
      }
    });
  }
}

class TowerTile extends StatelessWidget {
  const TowerTile({
    super.key,
    required this.tileData,
  });
  final TileData tileData;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!Board.isCellValidToAddWarriors(tileData.tilePosition)) {
          return;
        }

        if (tileData.colordata != GameVariables.currentPlayer.colorData) {
          GameVariables.grid[tileData.tilePosition.rowIndex]
                  [tileData.tilePosition.colIndex](
              '${tileData.tiletypecode + tileData.colordata.colorCode}${(tileData.numberOfTroops - 2)}');
          GameVariables.turnRemainingTroops(
              GameVariables.turnRemainingTroops.value - 1);
          Board.checkIfThePlayerHasEnoughTroopsInTower(tileData.tilePosition);
          Board.isTheGameEnded();
          Board.addCurrentGridToHistory();
        }
      },
      child: Container(
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Stack(
            children: [
              RiveAnimation.asset(
                'assets/animations/towers/${tileData.colordata.name}tower.riv',
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                    ),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Text(
                    tileData.numberOfTroops.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class BrokenTowerTile extends StatelessWidget {
  const BrokenTowerTile({super.key, required this.tileData});
  final TileData tileData;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: RiveAnimation.asset(
        'assets/animations/broken_towers/${tileData.colordata.name}brokentower.riv',
        stateMachines: const ['State Machine 1'],
      ),
    );
  }
}

class TroopsTile extends StatelessWidget {
  const TroopsTile({
    super.key,
    required this.tileData,
  });
  final TileData tileData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!Board.isCellValidToAddWarriors(tileData.tilePosition)) {
          return;
        }
        /* *SECTION - taking all troops from a the tile */
        if (GameVariables.isCellSelectionModeSelected.value) {
          GameVariables.turnRemainingTroops(
              GameVariables.turnRemainingTroops.value +
                  (tileData.numberOfTroops - 1));
          GameVariables.grid[tileData.tilePosition.rowIndex]
                  [tileData.tilePosition.colIndex](
              '${tileData.tiletypecode + tileData.colordata.colorCode}1');
          GameVariables.isCellSelectionModeSelected(false);
          return;
        }
        /* *!SECTION */
        if (tileData.colordata == GameVariables.currentPlayer.colorData) {
          GameVariables.grid[tileData.tilePosition.rowIndex]
                  [tileData.tilePosition.colIndex](
              '${tileData.tiletypecode + tileData.colordata.colorCode}${(tileData.numberOfTroops + 1)}');
        } else {
          GameVariables.grid[tileData.tilePosition.rowIndex]
                  [tileData.tilePosition.colIndex](
              '${tileData.tiletypecode + tileData.colordata.colorCode}${(tileData.numberOfTroops - 1)}');
          if (tileData.numberOfTroops == 1) {
            GameVariables.grid[tileData.tilePosition.rowIndex]
                [tileData.tilePosition.colIndex]("_");
          }
        }
        GameVariables.turnRemainingTroops--;
        Board.addCurrentGridToHistory();
        Board.updateTeamsLine();
      },
      child: Container(
          alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Stack(
            children: [
              RiveAnimation.asset(
                  'assets/animations/warriors/${tileData.colordata.name}warrior.riv'),
              tileData.numberOfTroops == 1
                  ? const SizedBox()
                  : Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                            )),
                        child: Text(
                          tileData.numberOfTroops.toString(),
                          style: const TextStyle(color: Colors.white),
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
    required this.tileData,
  });
  final TileData tileData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (!Board.isCellValidToAddWarriors(tileData.tilePosition)) {
            return;
          }

          GameVariables.grid[tileData.tilePosition.rowIndex]
                  [tileData.tilePosition.colIndex](
              '${tileData.tiletypecode + tileData.colordata.colorCode}${(tileData.numberOfTroops - 1)}');
          if (tileData.numberOfTroops == 1) {
            GameVariables.grid[tileData.tilePosition.rowIndex]
                [tileData.tilePosition.colIndex]("_");
          }
          GameVariables.turnRemainingTroops--;
          Board.addCurrentGridToHistory();
          Board.updateTeamsLine();
        },
        child: Container(
            alignment: Alignment.center,
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Stack(children: [
              const RiveAnimation.asset(
                  'assets/animations/warriors/deadwarrior.riv'),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                      )),
                  child: Text(
                    tileData.numberOfTroops.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
            ])));
  }
}

class BlankTile extends StatelessWidget {
  const BlankTile({
    super.key,
    required this.tileData,
  });
  final TileData tileData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (!Board.isCellValidToAddWarriors(tileData.tilePosition)) {
            return;
          }
          String currentTurnColorCode =
              GameVariables.currentPlayer.colorData.colorCode;

          GameVariables.grid[tileData.tilePosition.rowIndex]
              [tileData.tilePosition.colIndex]('W${currentTurnColorCode}1');
          GameVariables.turnRemainingTroops(
              GameVariables.turnRemainingTroops.value - 1);

          Board.addCurrentGridToHistory();
          Board.updateTeamsLine();
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(1),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
        ));
  }
}
