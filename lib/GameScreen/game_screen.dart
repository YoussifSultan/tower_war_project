import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:tower_war/CommonUsed/Button_Tile.dart';
import 'package:tower_war/CommonUsed/Constants.dart';
import 'package:tower_war/CommonUsed/Enums.dart';
import 'package:tower_war/GameScreen/Board.dart';
import 'package:tower_war/GameScreen/Tiles.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    GameVariables.currentTurn(TeamColors.values[Random().nextInt(3)]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int rowCount = -1;

    return Scaffold(
      backgroundColor: Color.fromRGBO(76, 179, 212, 1),
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
                    onTap: () {
                      GameVariables.selectedMode(SelectedMode.AddTroops);
                    },
                    child: Obx(
                      () => Container(
                        width: 100,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        clipBehavior: Clip.hardEdge,
                        height: 50,
                        decoration: BoxDecoration(
                          boxShadow: GameVariables.selectedMode.value ==
                                  SelectedMode.AddTroops
                              ? []
                              : [
                                  BoxShadow(
                                    blurRadius: 10,
                                    offset: Offset(7, 7),
                                  )
                                ],
                          borderRadius: BorderRadius.circular(50),
                          color: GameVariables.selectedMode.value ==
                                  SelectedMode.AddTroops
                              ? Color.fromRGBO(2, 209, 33, 1)
                              : Colors.white,
                        ),
                        child: Stack(children: [
                          RiveAnimation.asset(
                              'assets/animations/warriors/greenwarrior.riv'),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.black.withOpacity(0.5)),
                              child: Icon(
                                Icons.add,
                                size: 30,
                                color: GameVariables.selectedMode.value ==
                                        SelectedMode.AddTroops
                                    ? Colors.white
                                    : Color.fromRGBO(2, 209, 33, 1),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      GameVariables.selectedMode(SelectedMode.ReduceTroops);
                    },
                    child: Obx(
                      () => Container(
                        width: 100,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        clipBehavior: Clip.hardEdge,
                        height: 50,
                        decoration: BoxDecoration(
                          boxShadow: GameVariables.selectedMode.value ==
                                  SelectedMode.ReduceTroops
                              ? []
                              : [
                                  BoxShadow(
                                    blurRadius: 10,
                                    offset: Offset(7, 7),
                                  )
                                ],
                          borderRadius: BorderRadius.circular(50),
                          color: GameVariables.selectedMode.value ==
                                  SelectedMode.ReduceTroops
                              ? Color.fromRGBO(215, 5, 5, 1)
                              : Colors.white,
                        ),
                        child: Stack(children: [
                          RiveAnimation.asset(
                              'assets/animations/warriors/redwarrior.riv'),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.black.withOpacity(0.5)),
                              child: Icon(
                                Icons.remove,
                                size: 30,
                                color: GameVariables.selectedMode.value ==
                                        SelectedMode.ReduceTroops
                                    ? Colors.white
                                    : Color.fromRGBO(215, 5, 5, 1),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
                  IconTile(
                      onTap: () {}, ForegroundIcon: Icons.done_all_outlined),
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
