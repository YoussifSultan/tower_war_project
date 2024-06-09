import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:rive/rive.dart';
import 'package:tower_war/CommonUsed/Button_Tile.dart';
import 'package:tower_war/CommonUsed/Constants.dart';
import 'package:tower_war/CommonUsed/DataCellTile.dart';
import 'package:tower_war/CommonUsed/Enums.dart';
import 'package:tower_war/GameScreen/Board.dart';
import 'package:tower_war/GameScreen/Tiles.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:undo/undo.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  StreamController<int> fortuneWheelController = StreamController<int>();
  bool isUndoFunctionActivated = false;

  @override
  void initState() {
    GameVariables.currentTurn(TeamColors.values[Random().nextInt(3)]);
    fortuneWheelController.add(GameVariables.currentTurn.value.index);
    /* *SECTION - fortune wheel */
    ShowFortuneWheelToChooseWhichPlayerBeginsFirst();
    /* *!SECTION */
    GameVariables.historyController = SimpleStack<List<List<String>>>(
      Board.convertListRxStringToListString(GameVariables.grid),
      onUpdate: (val) {
        if (isUndoFunctionActivated) {
          Board.convertListStringToListRxString(val);
          isUndoFunctionActivated = false;
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int rowCount = -1;
    Color currentTurnColor = GameVariables.currentTurn.value == TeamColors.red
        ? Color.fromRGBO(240, 73, 79, 1)
        : GameVariables.currentTurn.value == TeamColors.blue
            ? Color.fromRGBO(76, 179, 212, 1)
            : GameVariables.currentTurn.value == TeamColors.yellow
                ? Color.fromRGBO(211, 183, 120, 1)
                : GameVariables.currentTurn.value == TeamColors.green
                    ? Color.fromRGBO(37, 68, 65, 1)
                    : Color.fromRGBO(37, 68, 65, 1);
    return Scaffold(
      backgroundColor: currentTurnColor,
      body: ListView(
        shrinkWrap: true,
        children: [
          /* *SECTION - Board */
          Container(
            margin: EdgeInsets.only(left: 5, right: 5, top: 20),
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
              itemBuilder: (_, index) {
                if (index.remainder(8) == 0) rowCount++;
                int columnCount = index - (rowCount * 8);

                return CustomTile(
                  CellData: GameVariables.grid[rowCount][columnCount],
                  CellPosition:
                      Point(rowIndex: rowCount, colIndex: columnCount),
                );
              },
              itemCount: 104,
            ),
          ),

          /* *!SECTION */
          SizedBox(
            height: 20,
          ),
          /* *SECTION - Important Data */
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  dataCardTile(
                      hintingText: 'hintingText', DataText: 'DataText'.obs),
                  dataCardTile(
                      hintingText: 'hintingText', DataText: 'DataText'.obs),
                  dataCardTile(
                      hintingText: 'hintingText', DataText: 'DataText'.obs),
                  dataCardTile(
                      hintingText: 'hintingText', DataText: 'DataText'.obs),
                ],
              ),
            ),
          ),
          /* *!SECTION */
          SizedBox(
            height: 20,
          ),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          /* *SECTION - ToolTip */
          /* *SECTION - undo Button */
          IconTile(
              onTap: () {
                isUndoFunctionActivated = true;
                GameVariables.historyController.undo();
              },
              ForegroundIcon: Icons.undo_rounded),
          /* *!SECTION */
          /* *SECTION - end Turn Button */
          IconTile(
              onTap: () async {
                await Board.checkBoard();
                switch (GameVariables.currentTurn.value) {
                  case TeamColors.red:
                    GameVariables.currentTurn(TeamColors.blue);
                  case TeamColors.blue:
                    GameVariables.currentTurn(TeamColors.yellow);
                  case TeamColors.yellow:
                    GameVariables.currentTurn(TeamColors.green);
                  case TeamColors.green:
                    GameVariables.currentTurn(TeamColors.red);
                    break;

                  default:
                }
                setState(() {});
                GameVariables.historyController.clearHistory();
              },
              ForegroundIcon: Icons.done_all_outlined),
          /* *!SECTION */
          /* *SECTION - more Data Button */
          IconTile(
              onTap: () {
                Get.bottomSheet(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  ListView(
                    children: [
                      dataCardTile(
                          hintingText: 'hintingText', DataText: 'DataText'.obs)
                    ],
                  ),
                );
              },
              ForegroundIcon: Icons.more_horiz_outlined),
          /* *!SECTION */
        ],
      ),

      /* *!SECTION */
    );
  }

  void ShowFortuneWheelToChooseWhichPlayerBeginsFirst() {
    /* *SECTION - fortune wheel */
    Future.delayed(
      Durations.long4,
      () {
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
              });
            },
            items: [
              FortuneItem(
                  style: FortuneItemStyle(
                    color: Color.fromRGBO(
                        240, 73, 79, 1), // <-- custom circle slice fill color
                  ),
                  child: Text(GameVariables.redPlayerName)),
              FortuneItem(
                  style: FortuneItemStyle(
                    color: Color.fromRGBO(
                        76, 179, 212, 1), // <-- custom circle slice fill color
                  ),
                  child: Text(GameVariables.bluePlayerName)),
              FortuneItem(
                  style: FortuneItemStyle(
                    color: Color.fromRGBO(
                        211, 183, 120, 1), // <-- custom circle slice fill color
                  ),
                  child: Text(GameVariables.yellowPlayerName)),
              FortuneItem(
                  style: FortuneItemStyle(
                    color: Color.fromRGBO(
                        37, 68, 65, 1), // <-- custom circle slice fill color
                  ),
                  child: Text(GameVariables.greenPlayerName)),
            ],
          ),
        ));
      },
    );
    /* *!SECTION */
  }
}
