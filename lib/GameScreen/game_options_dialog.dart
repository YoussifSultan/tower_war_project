import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:tower_war/Classes/color_data.dart';
import 'package:tower_war/Classes/player.dart';
import 'package:tower_war/Classes/point.dart';
import 'package:tower_war/CommonUsed/button_tile.dart';
import 'package:tower_war/CommonUsed/constants.dart';
import 'package:tower_war/Main%20Menu%20Screen/page_options.dart';
import 'package:tower_war/GameScreen/game_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameOptionsDialog extends StatefulWidget {
  const GameOptionsDialog({super.key});

  @override
  State<GameOptionsDialog> createState() => _GameOptionsDialogState();
}

class _GameOptionsDialogState extends State<GameOptionsDialog> {
  RxInt selectedNumberOfPlayers = 0.obs;
  RxString redTowerPlayerName = ''.obs;
  RxString blueTowerPlayerName = ''.obs;
  RxString yellowTowerPlayerName = ''.obs;
  RxString greenTowerPlayerName = ''.obs;
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      redTowerPlayerName = prefs.getString('redTowerName')!.obs;
      blueTowerPlayerName = prefs.getString('blueTowerName')!.obs;
      yellowTowerPlayerName = prefs.getString('yellowTowerName')!.obs;
      greenTowerPlayerName = prefs.getString('greenTowerName')!.obs;
    });
    super.initState();
  }

  /* *SECTION - Num of Players Selector Rive */
  SMINumber? selectedNumberOfPlayersRiveAnimation;
  void _onNumOfPlayersSelectorRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'StateManager');
    artboard.addController(controller!);
    selectedNumberOfPlayersRiveAnimation =
        controller.findInput<double>('NumOfPlayers') as SMINumber;
    controller.onInputValueChange = (inputID, valueOfInput) {
      if (inputID == 1689) {
        selectedNumberOfPlayers(double.parse(valueOfInput.toString()).round());
      }
    };
  }

/* *!SECTION */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 30, left: 20),
          child: ListView(
            children: [
              /* *SECTION - Number Of Players Selector */
              Obx(
                () => Text(
                  'Number Of Players : ${selectedNumberOfPlayers.value == 0 ? '' : selectedNumberOfPlayers.value}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: Constants.screenWidth,
                height: 75,
                child: RiveAnimation.asset(
                  'assets/animations/NumOfPlayersSelector.riv',
                  fit: BoxFit.fill,
                  onInit: _onNumOfPlayersSelectorRiveInit,
                ),
              ),
              /* *!SECTION */
              const SizedBox(
                height: 10,
              ),
              /* *SECTION - Enter Player Names */
              Obx(
                () => Visibility(
                    visible: selectedNumberOfPlayers.value != 0,
                    child: const Text(
                      'Enter Player Name :',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )),
              ),
              Obx(() => Center(
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Visibility(
                            visible: selectedNumberOfPlayers.value >= 2,
                            child: EnterPlayerNameContainer(
                                towerColor:
                                    const Color.fromRGBO(240, 73, 79, 1),
                                towerColorName: 'red',
                                playerName: redTowerPlayerName),
                          ),
                          Visibility(
                            visible: selectedNumberOfPlayers.value >= 2,
                            child: EnterPlayerNameContainer(
                                towerColor:
                                    const Color.fromRGBO(76, 179, 212, 1),
                                towerColorName: 'blue',
                                playerName: blueTowerPlayerName),
                          ),
                          Visibility(
                            visible: selectedNumberOfPlayers.value > 2,
                            child: EnterPlayerNameContainer(
                                towerColor:
                                    const Color.fromRGBO(211, 183, 120, 1),
                                towerColorName: 'yellow',
                                playerName: yellowTowerPlayerName),
                          ),
                          Visibility(
                            visible: selectedNumberOfPlayers.value == 4,
                            child: EnterPlayerNameContainer(
                                towerColor: const Color.fromRGBO(37, 68, 65, 1),
                                towerColorName: 'green',
                                playerName: greenTowerPlayerName),
                          ),
                        ],
                      ),
                    ),
                  )),
              /* *!SECTION */
              const SizedBox(
                height: 50,
              ),
              /* *SECTION - Start Game Button */
              Obx(
                () => Visibility(
                  visible: selectedNumberOfPlayers.value != 0,
                  child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 30),
                      child: ButtonTile(
                          text: 'Start Game',
                          onTap: () async {
                            GameVariables.activePlayers = [
                              Player(
                                  isAlive: true,
                                  name: redTowerPlayerName.string,
                                  linePositions: [
                                    Point(rowIndex: 0, colIndex: 0)
                                  ],
                                  colorData: Colordata.availableColors
                                      .firstWhere(
                                          (color) => color.colorCode == 'R'),
                                  towerPosition:
                                      Point(rowIndex: 0, colIndex: 0)),
                              Player(
                                isAlive: true,
                                name: blueTowerPlayerName.string,
                                linePositions: [
                                  Point(rowIndex: 0, colIndex: 7)
                                ],
                                colorData: Colordata.availableColors.firstWhere(
                                    (color) => color.colorCode == 'B'),
                                towerPosition: Point(rowIndex: 0, colIndex: 7),
                              ),
                            ];
                            if (selectedNumberOfPlayers.value >= 3) {
                              GameVariables.activePlayers.add(Player(
                                  isAlive: true,
                                  name: yellowTowerPlayerName.value,
                                  linePositions: [
                                    Point(rowIndex: 12, colIndex: 7)
                                  ],
                                  colorData: Colordata.availableColors
                                      .firstWhere(
                                          (color) => color.colorCode == 'Y'),
                                  towerPosition:
                                      Point(rowIndex: 12, colIndex: 7)));
                            }
                            if (selectedNumberOfPlayers.value == 4) {
                              GameVariables.activePlayers.add(Player(
                                  isAlive: true,
                                  name: greenTowerPlayerName.value,
                                  linePositions: [
                                    Point(rowIndex: 0, colIndex: 7)
                                  ],
                                  colorData: Colordata.availableColors
                                      .firstWhere(
                                          (color) => color.colorCode == 'G'),
                                  towerPosition:
                                      Point(rowIndex: 12, colIndex: 0)));
                            }
                            await FirebaseAnalytics.instance
                                .logEvent(name: 'Games_Started');

                            Get.offAndToNamed(PageNames.gamePage);
                          })),
                ),
              )
              /* *!SECTION */
            ],
          ),
        ),
      ),
    );
  }
}

class EnterPlayerNameContainer extends StatelessWidget {
  const EnterPlayerNameContainer({
    super.key,
    required this.playerName,
    required this.towerColor,
    required this.towerColorName,
  });

  final RxString playerName;
  final String towerColorName;
  final Color towerColor;

  @override
  Widget build(BuildContext context) {
    TextEditingController textFieldController = TextEditingController();
    return GestureDetector(
      onTap: () {
        Get.dialog(AlertDialog(
          content: TextField(
            controller: textFieldController,
            decoration: InputDecoration(
                hintText: "Enter $towerColorName Tower Player Name"),
          ),
          actions: <Widget>[
            ButtonTile(
                text: 'ok',
                onTap: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString(
                      '${towerColorName}TowerName', textFieldController.text);
                  playerName(textFieldController.text);

                  Get.back();
                })
          ],
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: towerColor),
        child: Center(
          child: Obx(
            () => Text(
              playerName.value,
              style:
                  const TextStyle(fontFamily: 'PixelText', color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
