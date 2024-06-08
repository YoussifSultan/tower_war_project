import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:tower_war/CommonUsed/PageOptions.dart';
import 'package:tower_war/GameScreen/game_options_dialog.dart';
import 'package:tower_war/GameScreen/game_screen.dart';
import 'package:tower_war/Main%20Menu%20Screen/home_screen.dart';
import 'package:tower_war/Settings_screen/settingsScreen.dart';

void main() {
  runApp(GetMaterialApp(
    initialRoute: PageNames.GamePage,
    getPages: [
      GetPage(
          name: PageNames.GameOptionsDialog,
          page: () => GameOptionsDialog(),
          transition: Transition.cupertino),
      GetPage(
          name: PageNames.HomePage,
          page: () => HomeScreen(),
          transition: Transition.cupertino),
      GetPage(
          name: PageNames.SettingsPage,
          page: () => SettingsScreen(),
          transition: Transition.cupertino),
      GetPage(
          name: PageNames.GamePage,
          page: () => GameScreen(),
          transition: Transition.cupertino),
    ],
    debugShowCheckedModeBanner: false,
  ));
}
