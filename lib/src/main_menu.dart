import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:recycle_this/src/game/my_game.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});
  static const routeName = '/';

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const Text('Ready to play?'),
          TextButton(
            onPressed: () {
              String chosenCategory = Categories.values.random().name;
              Navigator.pushNamed(context, MyGame.routeName,
                  arguments: chosenCategory);
            },
            child: const Text('Start'),
          )
        ],
      ),
    ));
  }
}
