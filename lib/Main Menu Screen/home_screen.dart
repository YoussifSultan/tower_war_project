import 'package:entry/entry.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:rive/rive.dart';
import 'package:tower_war/CommonUsed/Button_Tile.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      theme: ThemeData(fontFamily: 'PixelText'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(76, 179, 212, 1),
        body: Stack(
          children: [
            Container(
                width: screenWidth,
                height: screenHeight,
                child: RiveAnimation.asset(
                  'assets/animations/mainmenuscreen.riv',
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: screenWidth * 0.5,
                height: screenHeight * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ButtonTile(
                      text: 'Play',
                      onTap: () {},
                    ),
                    ButtonTile(
                      text: 'Settings',
                      onTap: () {},
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
      ),
    );
  }
}
