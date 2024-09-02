import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tower_war/Main%20Menu%20Screen/page_options.dart';
import 'package:tower_war/GameScreen/game_options_dialog.dart';
import 'package:tower_war/GameScreen/game_screen.dart';
import 'package:tower_war/HowToPlayScreen/howToPlay.dart';
import 'package:tower_war/Main%20Menu%20Screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // MobileAds.instance.initialize();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(GetMaterialApp(
    initialRoute: PageNames.homePage,
    getPages: [
      GetPage(
          name: PageNames.gameOptionsDialog,
          page: () => const GameOptionsDialog(),
          transition: Transition.cupertino),
      GetPage(
          name: PageNames.homePage,
          page: () => const HomeScreen(),
          transition: Transition.cupertino),
      GetPage(
          name: PageNames.tutorialPage,
          page: () => ShowCaseWidget(
              blurValue: 1,
              autoPlayDelay: const Duration(seconds: 3),
              builder: (context) {
                return const TutorialScreen();
              }),
          transition: Transition.cupertino),
      GetPage(
          name: PageNames.gamePage,
          page: () => const GameScreen(),
          transition: Transition.cupertino),
    ],
    debugShowCheckedModeBanner: false,
  ));
}
