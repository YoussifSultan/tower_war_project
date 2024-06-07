import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:tower_war/CommonUsed/Button_Tile.dart';
import 'package:tower_war/CommonUsed/Constants.dart';
import 'package:tower_war/CommonUsed/PageOptions.dart';

class GameOptionsDialog extends StatefulWidget {
  const GameOptionsDialog({super.key});

  @override
  State<GameOptionsDialog> createState() => _GameOptionsDialogState();
}

class _GameOptionsDialogState extends State<GameOptionsDialog> {
  RxInt selectedNumberOfPlayers = 0.obs;
  RxString redTowerPlayerName = 'red Tower'.obs;
  RxString blueTowerPlayerName = 'blue Tower'.obs;
  RxString yellowTowerPlayerName = 'yellow Tower'.obs;
  RxString greenTowerPlayerName = 'green Tower'.obs;
  /* *SECTION - Num of Players Selector Rive */
  SMINumber? SelectedNumberOfPlayersRiveAnimation;
  void _onNumOfPlayersSelectorRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'StateManager');
    artboard.addController(controller!);
    SelectedNumberOfPlayersRiveAnimation =
        controller.findInput<double>('NumOfPlayers') as SMINumber;
    controller.onInputValueChange = (InputID, ValueOfInput) {
      if (InputID == 1689)
        selectedNumberOfPlayers(double.parse(ValueOfInput.toString()).round());
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
          padding: EdgeInsets.only(top: 30, left: 20),
          child: ListView(
            children: [
              /* *SECTION - Number Of Players Selector */
              Obx(
                () => Text(
                  'Number Of Players : ${selectedNumberOfPlayers.value == 0 ? '' : selectedNumberOfPlayers.value}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: Constants.screenWidth,
                height: 75,
                child: RiveAnimation.asset(
                  'assets/animations/NumOfPlayersSelector.riv',
                  fit: BoxFit.fill,
                  onInit: _onNumOfPlayersSelectorRiveInit,
                ),
              ),
              /* *!SECTION */
              SizedBox(
                height: 10,
              ),
              /* *SECTION - Enter Player Names */
              Obx(
                () => Visibility(
                    visible: selectedNumberOfPlayers.value != 0,
                    child: Text(
                      'Enter Player Name :',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )),
              ),
              Obx(() => Center(
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Visibility(
                            visible: selectedNumberOfPlayers.value >= 2,
                            child: EnterPlayerNameContainer(
                                towerColor: Color.fromRGBO(240, 73, 79, 1),
                                towerColorName: 'Red',
                                playerName: redTowerPlayerName),
                          ),
                          Visibility(
                            visible: selectedNumberOfPlayers.value >= 2,
                            child: EnterPlayerNameContainer(
                                towerColor: Color.fromRGBO(76, 179, 212, 1),
                                towerColorName: 'Blue',
                                playerName: blueTowerPlayerName),
                          ),
                          Visibility(
                            visible: selectedNumberOfPlayers.value > 2,
                            child: EnterPlayerNameContainer(
                                towerColor: Color.fromRGBO(211, 183, 120, 1),
                                towerColorName: 'Yellow',
                                playerName: yellowTowerPlayerName),
                          ),
                          Visibility(
                            visible: selectedNumberOfPlayers.value == 4,
                            child: EnterPlayerNameContainer(
                                towerColor: Color.fromRGBO(37, 68, 65, 1),
                                towerColorName: 'Green',
                                playerName: greenTowerPlayerName),
                          ),
                        ],
                      ),
                    ),
                  )),
              /* *!SECTION */
              SizedBox(
                height: 50,
              ),
              /* *SECTION - Start Game Button */
              Obx(
                () => Visibility(
                  visible: selectedNumberOfPlayers.value != 0,
                  child: Container(
                      padding: EdgeInsets.only(left: 10, right: 30),
                      child: ButtonTile(
                          text: 'Start Game',
                          onTap: () {
                            Get.offAndToNamed(PageNames.GamePage);
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
                onTap: () {
                  playerName(textFieldController.text);
                  Get.back();
                })
          ],
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: towerColor),
        child: Center(
          child: Obx(
            () => Text(
              playerName.value,
              style: TextStyle(fontFamily: 'PixelText', color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
