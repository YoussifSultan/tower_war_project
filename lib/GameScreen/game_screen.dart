import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:rive/rive.dart';
import 'package:tower_war/CommonUsed/Button_Tile.dart';
import 'package:tower_war/CommonUsed/Constants.dart';
import 'package:tower_war/CommonUsed/Enums.dart';
import 'package:tower_war/GameScreen/Board.dart';
import 'package:tower_war/GameScreen/Tiles.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  StreamController<int> fortuneWheelController = StreamController<int>();
  RxBool isAddTroopsButtonClicked = false.obs;
  RxBool isUndoButtonClicked = false.obs;

  @override
  void initState() {
    GameVariables.currentTurn(TeamColors.values[Random().nextInt(3)]);
    fortuneWheelController.add(GameVariables.currentTurn.value.index);
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
          Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: GridView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                children: [
                  GestureDetector(
                    onTapUp: (details) {
                      isAddTroopsButtonClicked(false);
                    },
                    onTapDown: (details) {
                      isAddTroopsButtonClicked(true);
                    },
                    child: Obx(() {
                      return Container(
                        width: 100,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        clipBehavior: Clip.hardEdge,
                        height: 50,
                        decoration: BoxDecoration(
                          boxShadow: isAddTroopsButtonClicked.value
                              ? []
                              : [
                                  BoxShadow(
                                    blurRadius: 10,
                                    offset: Offset(7, 7),
                                  )
                                ],
                          borderRadius: BorderRadius.circular(50),
                          color: isAddTroopsButtonClicked.value
                              ? Color.fromRGBO(2, 209, 33, 1)
                              : Colors.white,
                        ),
                        child: Stack(children: [
                          RiveAnimation.asset(
                              'assets/animations/warriors/${GameVariables.currentTurn.value.name}warrior.riv'),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.black.withOpacity(0.5)),
                              child: Icon(
                                Icons.add,
                                size: 30,
                                color: isAddTroopsButtonClicked.value
                                    ? Colors.white
                                    : Color.fromRGBO(2, 209, 33, 1),
                              ),
                            ),
                          )
                        ]),
                      );
                    }),
                  ),
                  GestureDetector(
                    onTapUp: (details) {
                      isUndoButtonClicked(false);
                    },
                    onTapDown: (details) {
                      isUndoButtonClicked(true);
                    },
                    child: Obx(() {
                      return Container(
                        width: 100,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        clipBehavior: Clip.hardEdge,
                        height: 50,
                        decoration: BoxDecoration(
                          boxShadow: isUndoButtonClicked.value
                              ? []
                              : [
                                  BoxShadow(
                                    blurRadius: 10,
                                    offset: Offset(7, 7),
                                  )
                                ],
                          borderRadius: BorderRadius.circular(50),
                          color: isUndoButtonClicked.value
                              ? Colors.lightBlue
                              : Colors.white,
                        ),
                        child: Stack(children: [
                          RiveAnimation.asset(
                              'assets/animations/warriors/${GameVariables.currentTurn.value.name}warrior.riv'),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.black.withOpacity(0.5)),
                              child: Icon(
                                Icons.undo,
                                size: 30,
                                color: isUndoButtonClicked.value
                                    ? Colors.white
                                    : Colors.lightBlue,
                              ),
                            ),
                          )
                        ]),
                      );
                    }),
                  ),
                  IconTile(
                      onTap: () {
                        checkBoard();
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
                      },
                      ForegroundIcon: Icons.done_all_outlined),
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
                                  hintingText: 'hintingText',
                                  DataText: 'DataText'.obs)
                            ],
                          ),
                        );
                      },
                      ForegroundIcon: Icons.more_horiz_outlined)
                ],
              ))
        ],
      ),
    );
  }

  void checkBoard() {
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
    }
  }
}

class dataCardTile extends StatelessWidget {
  const dataCardTile({
    super.key,
    required this.hintingText,
    required this.DataText,
  });
  final String hintingText;
  final RxString DataText;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'data',
              style: TextStyle(
                  fontFamily: 'PixelText', fontSize: 20, color: Colors.black),
            ),
            Text(
              'placeholder',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade400),
            )
          ],
        ),
      ),
    );
  }
}
