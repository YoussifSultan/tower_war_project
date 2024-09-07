import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tower_war/CommonUsed/button_tile.dart';
import 'package:tower_war/CommonUsed/constants.dart';
import 'package:tower_war/CommonUsed/dialog.dart';
import 'package:tower_war/Main%20Menu%20Screen/page_options.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
    SharedPreferences.getInstance().then((prefs) async {
      if (prefs.getBool('firstOpen') == null) {
        prefs.setString('redTowerName', 'Red Tower');
        prefs.setString('blueTowerName', 'Blue Tower');
        prefs.setString('yellowTowerName', 'Yellow Tower');
        prefs.setString('greenTowerName', 'Green Tower');
        showPrivacyPolicyDialog(prefs);
      }
    });

    super.initState();
  }

  void showPrivacyPolicyDialog(SharedPreferences prefs) {
    DialogTile.showDialogWidget(context,
        title: 'Privacy Policy',
        content: 'Please Read the Privacy Policy On the web Page',
        buttonText: 'Read', onTap: () async {
      launchUrlString('https://youssifsultan.github.io/').then((val) async {
        DialogTile.showDialogWidget(context,
            title: 'Privacy Policy',
            content:
                'By clicking this button, you confirm that you have read and accepted the privacy policy',
            buttonText: 'Accept', onTap: () async {
          await FirebaseAnalytics.instance.logEvent(name: 'firstOpen');
          prefs.setBool('firstOpen', true);
          Get.back();
        });
      });
    });
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 70,
              child: IconTile(
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationIcon: Image.asset(
                        'assets/images/icon.jpg',
                        height: 50,
                        width: 50,
                      ),
                      applicationName: 'Tower War',
                      applicationVersion: '1.0.0',
                      applicationLegalese:
                          '© 2024 Developer_Experts. All rights reserved.',
                    );
                  },
                  foregroundIcon: Icons.help_outline),
            ),
            SizedBox(
                width: 70,
                child: IconTile(
                    onTap: () async {
                      await shareGameLink(context);
                    },
                    foregroundIcon: Icons.share_sharp)),
          ],
        ),
      ),
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
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (details) {
                      final offset = details.globalPosition;
                      showTutorialMenu(context, offset);
                    },
                    child: Container(
                      width: 200,
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(7, 7),
                          )
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromRGBO(37, 68, 65, 1),
                      ),
                      child: const Center(
                        child: Text(
                          'Tutorial',
                          style: TextStyle(
                              fontFamily: 'PixelText',
                              fontSize: 20,
                              color: Color.fromRGBO(240, 73, 79, 1)),
                        ),
                      ),
                    ),
                  ),
                  ButtonTile(
                      text: 'Share',
                      onTap: () async {
                        await shareGameLink(context);
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showTutorialMenu(BuildContext context, Offset offset) {
    return showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          offset.dx,
          offset.dy,
          MediaQuery.of(context).size.width - offset.dx,
          MediaQuery.of(context).size.height - offset.dy,
        ),
        items: [
          PopupMenuItem(
              child: ButtonTile(
                  text: 'Arabic',
                  onTap: () async {
                    launchUrlString(
                      'https://youtu.be/kTnX7KWRinA',
                    ).then((val) async {
                      await FirebaseAnalytics.instance
                          .logEvent(name: 'Arabic_Tutorial_Watched');
                    });
                  })),
          PopupMenuItem(
              child: ButtonTile(
                  text: 'English',
                  onTap: () async {
                    launchUrlString('https://youtu.be/-AXcXs0D8nI')
                        .then((val) async {
                      await FirebaseAnalytics.instance
                          .logEvent(name: 'English_Tutorial_Watched');
                    });
                  }))
        ]);
  }

  Future<void> shareGameLink(BuildContext context) async {
    final result = await Share.share('''
Check Out Tower War Game 
✨ Why You'll Love It:
Strategic Fun: Use your skills to outsmart your opponents. 🧠
Family-Friendly: Great for up to four players, perfect for game nights. 🕹️
New and Exciting: A fresh board game idea that's fun and different! 🚀

https://play.google.com/store/apps/details?id=com.developerExperts.towerWar
''');

    if (result.status == ShareResultStatus.success) {
      DialogTile.showDialogWidget(context,
          title: 'Thanks',
          content:
              'Thank you for sharing the joy and excitement of Tower War!');
      await FirebaseAnalytics.instance.logEvent(name: 'shareEvent');
    }
  }
}
