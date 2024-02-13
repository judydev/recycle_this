import 'package:flutter/material.dart';
import 'package:recycle_this/src/main_menu.dart';
import 'package:recycle_this/src/game/my_game.dart';
import 'package:recycle_this/src/settings_view.dart';

generateRoutes(RouteSettings routeSettings) {
  return MaterialPageRoute<void>(
    settings: routeSettings,
    builder: (BuildContext context) {
      switch (routeSettings.name) {
        case MyGame.routeName:
          return const MyGame();
        case SettingsView.routeName:
          return const SettingsView();
        case MainMenu.routeName:
        default:
          return const MainMenu();
      }
    },
  );
}
