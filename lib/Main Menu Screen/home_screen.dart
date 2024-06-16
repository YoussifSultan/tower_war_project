import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:rive/rive.dart';
import 'package:tower_war/CommonUsed/button_tile.dart';
import 'package:tower_war/CommonUsed/constants.dart';
import 'package:tower_war/CommonUsed/page_options.dart';

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
    FlameAudio.bgm.play('backgroundmusicForHomeScreen.mp3', volume: .25);
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
          SizedBox(
              width: Constants.screenWidth,
              height: Constants.screenHeight,
              child: const RiveAnimation.asset(
                'assets/animations/pagetransition.riv',
              )),
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
                    text: 'Settings',
                    onTap: () {
                      Get.toNamed(PageNames.settingsPage);
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
