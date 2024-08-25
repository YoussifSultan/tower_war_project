import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tower_war/Classes/color_data.dart';
import 'package:tower_war/Classes/point.dart';
import 'package:tower_war/Classes/tile_data.dart';
import 'package:tower_war/CommonUsed/button_tile.dart';
import 'package:tower_war/CommonUsed/constants.dart';
import 'package:tower_war/CommonUsed/data_cell_tile.dart';
import 'package:tower_war/CommonUsed/dialog.dart';
import 'package:tower_war/GameScreen/board.dart';
import 'package:tower_war/GameScreen/game_variables.dart';
import 'package:tower_war/GameScreen/tiles.dart';
import 'package:tower_war/HowToPlayScreen/ListOfInstruction.dart';
import 'package:undo/undo.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  StreamController<int> fortuneWheelController =
      StreamController<int>.broadcast();
  bool isUndoFunctionActivated = false;
  /* *SECTION - Instructions */
  RxString redTowerInstructionText = 'You have to protect your Tower'.obs;
  RxString blueTowerInstructionText = ''.obs;
  Function blueTowerOnEndInstrucion = () {};
  RxString stackingCellInstructionText = ''.obs;
  Function stackingCellInstructionOnEnd = () {};
  List<InstructionStages> shownInstruction = [];
  final GlobalKey one = GlobalKey();
  final GlobalKey two = GlobalKey();
  final GlobalKey three = GlobalKey();
  final GlobalKey four = GlobalKey();
  final GlobalKey five = GlobalKey();
  final GlobalKey six = GlobalKey();
  final GlobalKey seven = GlobalKey();
  final GlobalKey eight = GlobalKey();
  final GlobalKey nine = GlobalKey();
  final GlobalKey ten = GlobalKey();
  /* *!SECTION */
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
        'TR30'.obs,
        '_'.obs,
        '_'.obs,
        '_'.obs,
        '_'.obs,
        '_'.obs,
        '_'.obs,
        'TB30'.obs
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
        GameVariables.activePlayers.length == 4 ? 'TG16'.obs : '_'.obs,
        '_'.obs,
        '_'.obs,
        '_'.obs,
        '_'.obs,
        '_'.obs,
        '_'.obs,
        GameVariables.activePlayers.length >= 3 ? 'TY10'.obs : '_'.obs
      ]
    ];

    GameVariables.historyController = SimpleStack<List<List<String>>>(
      Board.convertListRxStringToListString(GameVariables.grid),
      onUpdate: (val) {
        if (isUndoFunctionActivated) {
          Board.convertListStringToListRxString(val);
          isUndoFunctionActivated = false;
          Board.updateTeamsLine();
          GameVariables.turnRemainingTroops(
              GameVariables.turnRemainingTroops.value + 1);
        }
      },
    );

    super.initState();
    /* *SECTION - fortune wheel */
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => showFortuneWheelToChooseWhichPlayerBeginsFirstRun());
    /* *!SECTION */
  }

  @override
  Widget build(BuildContext context) {
    int rowCount = -1;

    Color currentTurnColor = GameVariables.currentPlayer.colorData.color;
    return Scaffold(
      backgroundColor: currentTurnColor,
      body: ListView(
        shrinkWrap: true,
        children: [
          /* *SECTION - Board */
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5, top: 20),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (_, index) {
                if (index.remainder(8) == 0) rowCount++;
                int columnCount = index - (rowCount * 8);
                Point cellPoint =
                    Point(rowIndex: rowCount, colIndex: columnCount);
                return returnCellWithShowCase(
                    cellPoint, context, rowCount, columnCount);
              },
              itemCount: 104,
            ),
          ),
          /* *!SECTION */
          const SizedBox(
            height: 20,
          ),
          /* *SECTION - Turn Data */
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(() {
                  return DataCardTile(
                      width: 200,
                      hintingText:
                          'Remaining Warriors For ${GameVariables.currentPlayer.colorData.name} Turn',
                      dataText:
                          '${GameVariables.turnRemainingTroops.value}'.obs);
                }),
                Obx(() {
                  Point towerPosition =
                      GameVariables.currentPlayer.towerPosition;
                  int numberOfTroopsInTower = int.parse(GameVariables
                      .grid[towerPosition.rowIndex][towerPosition.colIndex]
                      .value
                      .replaceAll(RegExp(r'[^0-9]'), ''));
                  return DataCardTile(
                      width: 200,
                      hintingText:
                          'Warriors in ${GameVariables.currentPlayer.colorData.name} Tower ',
                      dataText: '$numberOfTroopsInTower'.obs);
                })
              ],
            ),
          ),
          /* *!SECTION */
          const SizedBox(
            height: 20,
          ),
        ],
      ),
      bottomNavigationBar: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            /* *SECTION - ToolTip */
            /* *SECTION - undo Button */
            SizedBox(
              width: 70,
              child: Showcase(
                key: seven,
                description: 'click here to undo your last move',
                onTargetClick: () {
                  isUndoFunctionActivated = true;
                  GameVariables.historyController.undo();
                  ShowCaseWidget.of(context).startShowCase([eight]);
                },
                disposeOnTap: true,
                child: IconTile(
                    onTap: () {
                      isUndoFunctionActivated = true;

                      GameVariables.historyController.undo();
                    },
                    foregroundIcon: Icons.undo_rounded),
              ),
            ),
            /* *!SECTION */
            /* *SECTION - end Turn Button */
            SizedBox(
              width: 70,
              child: Showcase(
                key: four,
                disposeOnTap: true,
                onTargetClick: () async {
                  await Board.endTurnMethod();
                  setState(() {});
                  if (shownInstruction
                      .contains(InstructionStages.transferingTroops)) {
                    DialogTile.showDialogWidget(context,
                        title: 'Tutorial',
                        content: 'Now it\'s blue\'s turn', onEnd: () async {
                      for (var i = 1; i <= 5; i++) {
                        await Future.delayed(const Duration(milliseconds: 400));
                        GameVariables.grid[1][7](
                            'W${GameVariables.currentPlayer.colorData.colorCode}$i');
                        GameVariables.turnRemainingTroops--;
                      }
                      await Board.endTurnMethod();
                      setState(() {});
                      ShowCaseWidget.of(context).startShowCase([ten]);
                    });
                  } else if (shownInstruction.contains(
                      InstructionStages.stackingTroopsForLaterTransfer)) {
                    DialogTile.showDialogWidget(context,
                        title: 'Tutorial',
                        content: 'Now it\'s blue\'s turn', onEnd: () async {
                      for (var i = 1; i <= 5; i++) {
                        await Future.delayed(const Duration(milliseconds: 400));
                        GameVariables.grid[1][7](
                            'W${GameVariables.currentPlayer.colorData.colorCode}$i');
                        GameVariables.turnRemainingTroops--;
                      }
                      await Board.endTurnMethod();
                      setState(() {});
                      DialogTile.showDialogWidget(context,
                          title: 'Strategy',
                          content:
                              'You can stack troops in a single tile and later transfer them, Here is How',
                          onEnd: () {
                        stackingCellInstructionOnEnd = () {
                          GameVariables.grid[0][2]('WR${(1 + 1)}');
                          GameVariables.turnRemainingTroops--;
                          Board.addCurrentGridToHistory();
                          Board.updateTeamsLine();
                        };
                        stackingCellInstructionText(
                            'Stack all 5 troops in this cell');
                        ShowCaseWidget.of(context).startShowCase([nine]);
                      });
                    });
                  } else if (shownInstruction
                      .contains(InstructionStages.numberOfTroopsLimit)) {
                    DialogTile.showDialogWidget(context,
                        title: 'Tutorial',
                        content: 'Now it\'s blue\'s turn', onEnd: () async {
                      for (var i = 0; i < 3; i++) {
                        await Future.delayed(const Duration(milliseconds: 400));
                        GameVariables.grid[1][6 - i](
                            'W${GameVariables.currentPlayer.colorData.colorCode}1');
                        GameVariables.turnRemainingTroops--;
                      }
                      await Future.delayed(const Duration(milliseconds: 400));
                      GameVariables.grid[1][5](
                          'W${GameVariables.currentPlayer.colorData.colorCode}2');
                      GameVariables.turnRemainingTroops--;
                      await Future.delayed(const Duration(milliseconds: 400));
                      GameVariables.grid[1][4](
                          'W${GameVariables.currentPlayer.colorData.colorCode}2');
                      GameVariables.turnRemainingTroops--;
                      await Board.endTurnMethod();
                      setState(() {
                        ShowCaseWidget.of(context).startShowCase([five]);
                      });
                    });
                  }
                },
                description: 'click here to end your turn',
                child: IconTile(
                    onTap: () async {
                      await Board.endTurnMethod();
                      setState(() {});
                    },
                    foregroundIcon: Icons.done_all_outlined),
              ),
            ),
            /* *!SECTION */
            /* *SECTION - take all troops Button */
            SizedBox(
              width: 70,
              child: Showcase(
                disposeOnTap: true,
                onTargetClick: () {
                  GameVariables.isCellSelectionModeSelected(true);
                  Get.rawSnackbar(
                      messageText: const Text(
                    'Please Select a Tile to transfer troops',
                    style: TextStyle(color: Colors.white),
                  ));
                  stackingCellInstructionOnEnd = () {
                    /* *SECTION - taking all troops from a the tile */
                    if (GameVariables.isCellSelectionModeSelected.value) {
                      GameVariables.turnRemainingTroops(
                          GameVariables.turnRemainingTroops.value + 5);
                      GameVariables.grid[0][2]('WR1');
                      GameVariables.isCellSelectionModeSelected(false);
                    }
                    /* *!SECTION */
                    blueTowerOnEndInstrucion = () {};
                    blueTowerInstructionText(
                        'Attack the enemy with the troops transferred And Win the game');
                    ShowCaseWidget.of(context).startShowCase([two]);
                  };
                  stackingCellInstructionText(
                      'Select This tile to transfer it\'s troops into another place');
                  ShowCaseWidget.of(context).startShowCase([nine]);
                },
                key: ten,
                description: 'Click here to Activate Transfer Mode',
                child: IconTile(
                    onTap: () {
                      GameVariables.isCellSelectionModeSelected(true);
                      Get.rawSnackbar(
                          messageText: const Text(
                        'Please Select a Tile to transfer troops',
                        style: TextStyle(color: Colors.white),
                      ));
                    },
                    foregroundIcon: Icons.pivot_table_chart_outlined),
              ),
            ),
            /* *!SECTION */
          ],
        ),
      ),

      /* *!SECTION */
    );
  }

  Widget returnCellWithShowCase(
      Point cellPoint, BuildContext context, int rowCount, int columnCount) {
    if (cellPoint.colIndex == 7 && cellPoint.rowIndex == 0) {
      return Obx(() => Showcase(
          key: two,
          description: blueTowerInstructionText.value,
          onBarrierClick: () {
            blueTowerOnEndInstrucion();
          },
          child: CustomTile(
              cellData: GameVariables.grid[rowCount][columnCount],
              position: cellPoint)));
    } else if (cellPoint.colIndex == 0 && cellPoint.rowIndex == 0) {
      return Obx(() => Showcase(
          key: one,
          onBarrierClick: () {},
          description: redTowerInstructionText.value,
          child: CustomTile(
              cellData: GameVariables.grid[rowCount][columnCount],
              position: cellPoint)));
    } else if (cellPoint.colIndex == 4 && cellPoint.rowIndex == 1) {
      return Showcase(
          key: five,
          onBarrierClick: () {
            DialogTile.showDialogWidget(context,
                title: 'Tips',
                content:
                    'That can be used for a specific skill OR for more powerful defence',
                onEnd: () {
              ShowCaseWidget.of(context).startShowCase([six]);
            });
          },
          description:
              'As you see the opponent stacked 2 warriors in a single tile',
          child: CustomTile(
              cellData: GameVariables.grid[rowCount][columnCount],
              position: cellPoint));
    } else if (cellPoint.colIndex == 5 && cellPoint.rowIndex == 1) {
      return Showcase(
          key: six,
          onTargetClick: () {
            GameVariables.grid[1][5]('WB1');
            GameVariables.turnRemainingTroops--;
            Board.addCurrentGridToHistory();
            Board.updateTeamsLine();
            DialogTile.showDialogWidget(context,
                title: 'Tutorial',
                content:
                    'This move only decreased the number of troops in the tile',
                onEnd: () {
              ShowCaseWidget.of(context).startShowCase([seven]);
            });
          },
          disposeOnTap: true,
          description: 'click here to attack the opponent\'s warriors',
          child: CustomTile(
              cellData: GameVariables.grid[rowCount][columnCount],
              position: cellPoint));
    } else if (cellPoint.colIndex == 6 && cellPoint.rowIndex == 1) {
      return Showcase(
          key: eight,
          disposeOnTap: true,
          onTargetClick: () {
            GameVariables.grid[1][6]('_');
            GameVariables.turnRemainingTroops--;
            Board.addCurrentGridToHistory();
            Board.updateTeamsLine();
            DialogTile.showDialogWidget(context,
                title: 'Tutorial',
                content:
                    'As a result, When you end your turn the enemy would lose all troops out of contact with the tower',
                onEnd: () {
              blueTowerOnEndInstrucion = () {
                DialogTile.showDialogWidget(context,
                    title: 'Tutorial',
                    content:
                        'Then attack it since the warrior causes damage x2 to the tower',
                    onEnd: () {});
              };
              blueTowerInstructionText(
                  'Complete the line to the enemy\'s tower');
              ShowCaseWidget.of(context).startShowCase([two]);
            });
          },
          description: 'click here to attack the opponent\'s warriors',
          child: CustomTile(
              cellData: GameVariables.grid[rowCount][columnCount],
              position: cellPoint));
    } else if (cellPoint.colIndex == 2 && cellPoint.rowIndex == 0) {
      return Obx(() => Showcase(
          key: nine,
          disposeOnTap: true,
          onTargetClick: () => stackingCellInstructionOnEnd(),
          description: stackingCellInstructionText.value,
          child: CustomTile(
              cellData: GameVariables.grid[rowCount][columnCount],
              position: cellPoint)));
    } else if (cellPoint.colIndex == 1 && cellPoint.rowIndex == 0) {
      return Showcase(
          key: three,
          description: 'click here to put your troops',
          disposeOnTap: true,
          onTargetClick: () {
            /* *SECTION - putting warrior */
            TileData tileData = TileData(
                tilePosition: Point(colIndex: 1, rowIndex: 0),
                tiletypecode: '_',
                colordata: Colordata.availableColors[0],
                numberOfTroops: 0);
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
            /* *!SECTION */

            DialogTile.showDialogWidget(
              context,
              title: 'Tutorial',
              content: 'Make a line of troops to the Opponent',
            );
            GameVariables.turnRemainingTroops.listen((value) {
              if (GameVariables.turnRemainingTroops.value == 0 &&
                  !shownInstruction
                      .contains(InstructionStages.numberOfTroopsLimit)) {
                DialogTile.showDialogWidget(context,
                    title: 'Tutorial',
                    content:
                        'Each turn, You have 5 troops taken from the troops in tower',
                    onEnd: () {
                  redTowerInstructionText(
                      'The number beside the tower indicates the number of troops left');
                  shownInstruction.add(InstructionStages.numberOfTroopsLimit);
                  ShowCaseWidget.of(context).startShowCase([one, four]);
                });
              } else if (GameVariables.turnRemainingTroops.value == 0 &&
                  GameVariables.currentPlayer.colorData.colorCode == 'R' &&
                  shownInstruction
                      .contains(InstructionStages.numberOfTroopsLimit) &&
                  !shownInstruction.contains(
                      InstructionStages.stackingTroopsForLaterTransfer)) {
                shownInstruction
                    .add(InstructionStages.stackingTroopsForLaterTransfer);
                ShowCaseWidget.of(context).startShowCase([four]);
              } else if (GameVariables.turnRemainingTroops.value == 0 &&
                  GameVariables.currentPlayer.colorData.colorCode == 'R' &&
                  shownInstruction
                      .contains(InstructionStages.numberOfTroopsLimit) &&
                  shownInstruction.contains(
                      InstructionStages.stackingTroopsForLaterTransfer) &&
                  !shownInstruction
                      .contains(InstructionStages.transferingTroops)) {
                shownInstruction.add(InstructionStages.transferingTroops);
                ShowCaseWidget.of(context).startShowCase([four]);
              }
            });
          },
          child: CustomTile(
              cellData: GameVariables.grid[rowCount][columnCount],
              position: cellPoint));
    } else {
      return CustomTile(
          cellData: GameVariables.grid[rowCount][columnCount],
          position: cellPoint);
    }
  }

  void showFortuneWheelToChooseWhichPlayerBeginsFirstRun() {
    /* *SECTION - fortune wheel */
    Future.delayed(
      Durations.long4,
      () {
        GameVariables.currentPlayerIndex(0);

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
                /* *LINK - show instruction 1*/

                DialogTile.showDialogWidget(context,
                    title: 'Tutorial',
                    content:
                        'The game always starts with a wheel which determines who will begin first',
                    onEnd: () {
                  blueTowerOnEndInstrucion = () {
                    /* *LINK - show instruction 4*/

                    DialogTile.showDialogWidget(context,
                        title: 'Tutorial',
                        content:
                            'Achieve your goal by putting troops to your opponents\' tower',
                        onEnd: () {
                      ShowCaseWidget.of(context).startShowCase([three]);
                    });
                  };
                  blueTowerInstructionText(
                      'Your goal is to attack the opponents\' tower');
                  /* *LINK - show intruction 2 & 3*/
                  ShowCaseWidget.of(context).startShowCase([one, two]);
                });
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
