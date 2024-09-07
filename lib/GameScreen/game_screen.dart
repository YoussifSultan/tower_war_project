import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tower_war/CommonUsed/button_tile.dart';
import 'package:tower_war/CommonUsed/constants.dart';
import 'package:tower_war/CommonUsed/data_cell_tile.dart';
import 'package:tower_war/GameScreen/game_variables.dart';
import 'package:tower_war/GameScreen/tiles.dart';
import 'package:tower_war/Classes/point.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:undo/undo.dart';
import 'package:tower_war/GameScreen/board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  StreamController<int> fortuneWheelController = StreamController<int>();
  bool isUndoFunctionActivated = false;

  @override
  void dispose() {
    GameVariables.activePlayers = [];
    GameVariables.currentPlayerIndex = 0.obs;
    GameVariables.leaderboard = {};
    super.dispose();
  }

  @override
  void initState() {
    GameVariables.currentPlayerIndex.listen((val) {
      GameVariables.currentPlayer = GameVariables.activePlayers[val];
    });
    GameVariables.grid = [
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
        GameVariables.activePlayers.length == 4 ? 'TG100'.obs : '_'.obs,
        '_'.obs,
        '_'.obs,
        '_'.obs,
        '_'.obs,
        '_'.obs,
        '_'.obs,
        GameVariables.activePlayers.length >= 3 ? 'TY100'.obs : '_'.obs
      ]
    ];

    GameVariables.historyController = SimpleStack<List<List<String>>>(
      Board.convertListRxStringToListString(GameVariables.grid),
      onUpdate: (val) {
        if (isUndoFunctionActivated) {
          Board.convertListStringToListRxString(val);
          Board.updateTeamsLine();
          GameVariables.historyOfTurnRemainingSoldiers.undo();
          Board.playPlaceSoldierSoundEffect();
        }
      },
    );
    GameVariables.historyOfTurnRemainingSoldiers =
        SimpleStack(GameVariables.turnRemainingTroops.value, onUpdate: (val) {
      if (isUndoFunctionActivated) {
        GameVariables.turnRemainingTroops(val);
        isUndoFunctionActivated = false;
      }
    });
    super.initState();

    /* *SECTION - fortune wheel */
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => showFortuneWheelToChooseWhichPlayerBeginsFirst());
    /* *!SECTION */
  }

  @override
  Widget build(BuildContext context) {
    Color currentTurnColor = GameVariables.currentPlayer.colorData.color;
    return Scaffold(
      backgroundColor: currentTurnColor,
      body: ListView(
        shrinkWrap: true,
        children: const [
          /* *SECTION - Board */
          BoardWidget(),

          /* *!SECTION */
          SizedBox(
            height: 20,
          ),
          /* *SECTION - Turn Data */
          TurnDataWidget(),
          /* *!SECTION */
          SizedBox(
            height: 20,
          ),
        ],
      ),
      bottomNavigationBar: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            /* *SECTION - ToolTip */
            /* *SECTION - undo Button */
            IconTile(
                onTap: () {
                  isUndoFunctionActivated = true;

                  GameVariables.historyController.undo();
                },
                foregroundIcon: Icons.undo_rounded),
            /* *!SECTION */
            /* *SECTION - end Turn Button */
            IconTile(
                onTap: () async {
                  await Board.endTurnMethod();
                  setState(() {});
                },
                foregroundIcon: Icons.done_all_outlined),
            /* *!SECTION */
            /* *SECTION - take all troops Button */
            IconTile(
                onTap: () {
                  GameVariables.isCellSelectionModeSelected(true);
                  Get.rawSnackbar(
                      messageText: const Text(
                    'Please Select a Tile to transfer troops',
                    style: TextStyle(color: Colors.white),
                  ));
                },
                foregroundIcon: Icons.transfer_within_a_station_sharp),
            /* *!SECTION */
          ],
        ),
      ),

      /* *!SECTION */
    );
  }

  void goNextTurn() {
    if (GameVariables.activePlayers[GameVariables.currentPlayerIndex.value] ==
        GameVariables.activePlayers.last) {
      GameVariables.currentPlayerIndex(0);
    } else {
      GameVariables.currentPlayerIndex(
          GameVariables.currentPlayerIndex.value + 1);
    }
    GameVariables.currentPlayer =
        GameVariables.activePlayers[GameVariables.currentPlayerIndex.value];
    Board.checkIfThePlayerHasEnoughSoldiersInTower(
        GameVariables.currentPlayer.towerPosition);
  }

  void showFortuneWheelToChooseWhichPlayerBeginsFirst() {
    /* *SECTION - fortune wheel */
    Future.delayed(
      Durations.long4,
      () {
        GameVariables.currentPlayerIndex(
            math.Random().nextInt(GameVariables.activePlayers.length));

        fortuneWheelController.add(GameVariables.currentPlayerIndex.value);
        Get.dialog(Container(
          width: Constants.screenWidth * 0.7,
          height: Constants.screenHeight * 0.5,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: FortuneWheel(
            curve: Curves.easeInOut,
            selected: fortuneWheelController.stream,
            onAnimationEnd: () {
              Future.delayed(Durations.long4, () {
                Get.back();
                /* *SECTION - Take 5 warriors from tower & give them to remaining warriors*/
                Point towerPosition = GameVariables.currentPlayer.towerPosition;
                String cellData = GameVariables
                    .grid[towerPosition.rowIndex][towerPosition.colIndex].string
                    .replaceAll(RegExp(r"[0-9]+"), "");

                int numberOfTroopsInTower = int.parse(GameVariables
                    .grid[towerPosition.rowIndex][towerPosition.colIndex].value
                    .replaceAll(RegExp(r'[^0-9]'), ''));
                GameVariables.grid[towerPosition.rowIndex]
                        [towerPosition.colIndex](
                    '$cellData${(numberOfTroopsInTower - 5)}');
                GameVariables.turnRemainingTroops(5);
                GameVariables.historyController.modify(
                    Board.convertListRxStringToListString(GameVariables.grid));
                /* *!SECTION */
                setState(() {});
              });
            },
            items: GameVariables.activePlayers.map((player) {
              return FortuneItem(
                  style: FortuneItemStyle(
                      color: player
                          .colorData.color // <-- custom circle slice fill color
                      ),
                  child: Text(player.name));
            }).toList(),
          ),
        ));
      },
    );
    /* *!SECTION */
  }
}

class TurnDataWidget extends StatelessWidget {
  const TurnDataWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Obx(() {
            return DataCardTile(
                width: 200,
                hintingText:
                    'Remaining Warriors For ${GameVariables.currentPlayer.colorData.name} Turn',
                dataText: '${GameVariables.turnRemainingTroops.value}'.obs);
          }),
          Obx(() {
            Point towerPosition = GameVariables.currentPlayer.towerPosition;
            int numberOfTroopsInTower = int.parse(GameVariables
                .grid[towerPosition.rowIndex][towerPosition.colIndex].value
                .replaceAll(RegExp(r'[^0-9]'), ''));
            return DataCardTile(
                width: 200,
                hintingText:
                    'Warriors in ${GameVariables.currentPlayer.colorData.name} Tower ',
                dataText: '$numberOfTroopsInTower'.obs);
          })
        ],
      ),
    );
  }
}

class BoardWidget extends StatelessWidget {
  const BoardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int rowCount = -1;
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, top: 20),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemBuilder: (_, index) {
          if (index.remainder(8) == 0) rowCount++;
          int columnCount = index - (rowCount * 8);

          return CustomTile(
              cellData: GameVariables.grid[rowCount][columnCount],
              position: Point(rowIndex: rowCount, colIndex: columnCount));
        },
        itemCount: 104,
      ),
    );
  }
}
