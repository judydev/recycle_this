import 'package:flutter/material.dart';
import 'package:recycle_this/src/home_page.dart';
import 'package:recycle_this/src/game/my_game.dart';
import 'package:recycle_this/src/settings/settings_controller.dart';
import 'package:recycle_this/src/settings/settings_view.dart';

generateRoutes(
    RouteSettings routeSettings, SettingsController settingsController) {
  return MaterialPageRoute<void>(
    settings: routeSettings,
    builder: (BuildContext context) {
      switch (routeSettings.name) {
        case MyGame.routeName:
          return MyGame(
              settingsController: settingsController,
              randomKey: routeSettings.arguments as Categories);
        case SettingsView.routeName:
          return SettingsView(settingsController: settingsController);
        case HomePage.routeName:
        default:
          return HomePage(settingsController: settingsController);
      }
    },
  );
}
