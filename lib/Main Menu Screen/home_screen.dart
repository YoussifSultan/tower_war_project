import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/dialog/dialog_route.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get/route_manager.dart';
import 'package:rive/rive.dart';
import 'package:tower_war/CommonUsed/Button_Tile.dart';
import 'package:tower_war/CommonUsed/Constants.dart';
import 'package:tower_war/CommonUsed/PageOptions.dart';
import 'package:tower_war/GameScreen/game_options_dialog.dart';
import 'package:tower_war/GameScreen/game_screen.dart';
import 'package:tower_war/Settings_screen/settingsScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    FlameAudio.bgm.initialize();
    /* *TODO - Uncomment when releasing */
    // FlameAudio.bgm.play('backgroundmusicForHomeScreen.mp3', volume: .25);
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
      backgroundColor: Color.fromRGBO(76, 179, 212, 1),
      body: Stack(
        children: [
          Container(
              width: Constants.screenWidth,
              height: Constants.screenHeight,
              child: RiveAnimation.asset(
                'assets/animations/pagetransition.riv',
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: Constants.screenWidth * 0.5,
              height: Constants.screenHeight * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ButtonTile(
                    text: 'Play',
                    onTap: () {
                      Get.dialog(
                        GameOptionsDialog(),
                      );
                    },
                  ),
                  ButtonTile(
                    text: 'Settings',
                    onTap: () {
                      Get.toNamed(PageNames.SettingsPage);
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
