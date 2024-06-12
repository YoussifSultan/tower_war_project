import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:tower_war/CommonUsed/page_options.dart';
import 'package:tower_war/GameScreen/game_options_dialog.dart';
import 'package:tower_war/GameScreen/game_screen.dart';
import 'package:tower_war/Main%20Menu%20Screen/home_screen.dart';
import 'package:tower_war/Settings_screen/settings_screen.dart';

void main() {
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
          name: PageNames.settingsPage,
          page: () => const SettingsScreen(),
          transition: Transition.cupertino),
      GetPage(
          name: PageNames.gamePage,
          page: () => const GameScreen(),
          transition: Transition.cupertino),
    ],
    debugShowCheckedModeBanner: false,
  ));
}
