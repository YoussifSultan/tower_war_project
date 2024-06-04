import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:tower_war/CommonUsed/Constants.dart';

class GameOptionsDialog extends StatefulWidget {
  const GameOptionsDialog({super.key});

  @override
  State<GameOptionsDialog> createState() => _GameOptionsDialogState();
}

class _GameOptionsDialogState extends State<GameOptionsDialog> {
  SMINumber? SelectedNumberOfPlayersRiveAnimation;
  RxInt selectedNumberOfPlayers = 0.obs;
  void _onNumOfPlayersSelectorRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'StateManager');
    artboard.addController(controller!);
    SelectedNumberOfPlayersRiveAnimation =
        controller.findInput<double>('NumOfPlayers') as SMINumber;
    controller.onInputValueChange = (InputID, ValueOfInput) {
      if (InputID == 1689)
        selectedNumberOfPlayers(int.tryParse(ValueOfInput.toString()));
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: Container(
          width: Constants.screenWidth * 0.8,
          height: Constants.screenHeight * 0.5,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Choose The Number Of Players :',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'PixelText',
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: Constants.screenWidth,
                height: 50,
                child: RiveAnimation.asset(
                  'assets/animations/NumOfPlayersSelector.riv',
                  fit: BoxFit.fill,
                  onInit: _onNumOfPlayersSelectorRiveInit,
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
