import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tower_war/Classes/color_data.dart';
import 'package:tower_war/Classes/player.dart';
import 'package:tower_war/Classes/point.dart';
import 'package:tower_war/CommonUsed/button_tile.dart';
import 'package:tower_war/CommonUsed/constants.dart';
import 'package:tower_war/Main%20Menu%20Screen/page_options.dart';
import 'package:tower_war/GameScreen/game_variables.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    FlameAudio.bgm.initialize();
    // FlameAudio.bgm.play('backgroundmusicForHomeScreen.mp3', volume: .25);
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool('firstOpen') == null) {
        prefs.setBool('firstOpen', true);
        prefs.setString('redTowerName', 'Red Tower');
        prefs.setString('blueTowerName', 'Blue Tower');
        prefs.setString('yellowTowerName', 'Yellow Tower');
        prefs.setString('greenTowerName', 'Green Tower');
        FirebaseAnalytics.instance.logEvent(name: 'firstOpen');
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    FlameAudio.bgm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Constants.screenWidth = MediaQuery.of(context).size.width;
    Constants.screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(76, 179, 212, 1),
      body: Stack(
        children: [
          const RiveAnimation.asset(
            'assets/animations/pagetransition.riv',
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: Constants.screenWidth * 0.5,
              height: Constants.screenHeight * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ButtonTile(
                    text: 'Play',
                    onTap: () {
                      FlameAudio.bgm.stop();
                      Get.toNamed(PageNames.gameOptionsDialog);
                    },
                  ),
                  ButtonTile(
                    text: 'Tutorial',
                    onTap: () {
                      GameVariables.activePlayers = [
                        Player(
                            isAlive: true,
                            name: 'Player',
                            linePositions: [Point(rowIndex: 0, colIndex: 0)],
                            colorData: Colordata.availableColors
                                .firstWhere((color) => color.colorCode == 'R'),
                            towerPosition: Point(rowIndex: 0, colIndex: 0)),
                        Player(
                          isAlive: true,
                          name: "Opponent",
                          linePositions: [Point(rowIndex: 0, colIndex: 7)],
                          colorData: Colordata.availableColors
                              .firstWhere((color) => color.colorCode == 'B'),
                          towerPosition: Point(rowIndex: 0, colIndex: 7),
                        ),
                      ];
                      Get.toNamed(PageNames.tutorialPage);
                    },
                  ),
                  ButtonTile(
                    text: 'Share',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
