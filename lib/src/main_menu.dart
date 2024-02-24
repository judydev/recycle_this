import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recycle_this/src/game/my_game.dart';
import 'package:recycle_this/src/settings/settings_view.dart';

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
        backgroundColor: backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 210,
          backgroundColor: backgroundColor,
          title: Image.asset('assets/images/background/banner.png'),
        ),
        body: Center(
            child: Column(
                mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
          children: [            
              const Text('Ready to play?',
                  style: TextStyle(fontSize: 48, fontFamily: 'Silkscreen')),
              TextButton(
                  onPressed: () {
                    SystemSound.play(SystemSoundType.click);
                    Navigator.pushNamed(context, MyGame.routeName);
                  },
                  child: const Text('Start',
                      style:
                          TextStyle(fontSize: 36, fontFamily: 'Silkscreen'))),
              TextButton(
                  onPressed: () {
                  SystemSound.play(SystemSoundType.click);
              Navigator.pushNamed(context, SettingsView.routeName);
                  },
                child: const Text('Settings',
                    style: TextStyle(fontSize: 36, fontFamily: 'Silkscreen')),
          )
        ])));
  }
}

const backgroundColor = Color.fromARGB(255, 243, 184, 145);
