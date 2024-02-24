import 'package:flutter/material.dart';
import 'package:recycle_this/src/main_menu.dart';
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
          return MyGame(settingsController: settingsController);
        case SettingsView.routeName:
          return SettingsView(settingsController: settingsController);
        case MainMenu.routeName:
        default:
          return const MainMenu();
      }
    },
  );
}
