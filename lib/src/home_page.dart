import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recycle_this/src/game/my_game.dart';
import 'package:recycle_this/src/settings/settings_controller.dart';
import 'package:recycle_this/src/settings/settings_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.settingsController});
  static const routeName = '/';

  final SettingsController settingsController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final settingsController = widget.settingsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: MediaQuery.sizeOf(context).height * 0.8,
          backgroundColor: backgroundColor,
          title:
              Center(child: Image.asset('assets/images/background/banner.png')),
        ),
        body: Center(
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              button('Play', () async {
                await showCategoryPopup(
                    context, settingsController.soundEffectOn);
              }),
              const SizedBox(width: 50),
              button('Settings', () {
                Navigator.pushNamed(context, SettingsView.routeName);
              })
            ])));
  }

  Widget button(String text, onPressed) {
    return TextButton(
        style: const ButtonStyle(
          padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
        ),
        onPressed: () {
          if (settingsController.soundEffectOn) {
            SystemSound.play(SystemSoundType.click);
          }

          onPressed();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(text,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  fontFamily: 'Silkscreen')),
        ));
  }
}

const backgroundColor = Color.fromARGB(255, 243, 184, 145);
