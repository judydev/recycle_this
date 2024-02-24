import 'package:flutter/material.dart';
import 'package:recycle_this/src/main_menu.dart';
import 'package:recycle_this/src/settings/settings_controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key, required this.settingsController});
  static const routeName = '/settings';

  final SettingsController settingsController;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final SettingsController settingsController = widget.settingsController;

  late bool backgroundMusicOn;
  late bool soundEffectOn;

  @override
  void initState() {
    super.initState();
    backgroundMusicOn = settingsController.backgroundMusicOn;
    soundEffectOn = settingsController.soundEffectOn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Settings',
              style: TextStyle(fontFamily: 'Silkscreen'))),
      body: Padding(
        padding: const EdgeInsets.only(left: 50),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Row(children: [
              const Text('Background Music',
                  style: TextStyle(fontSize: 18, fontFamily: 'Silkscreen')),
              const SizedBox(width: 50),
              Switch(
                  value: backgroundMusicOn,
                  activeColor: Colors.amber,
                  trackColor: const MaterialStatePropertyAll(Colors.brown),
                  inactiveThumbColor: Colors.brown[300],
                  onChanged: (bool value) {
                    setState(() {
                      backgroundMusicOn = value;
                    });
                    settingsController.updateBackgroundMusicSetting(value);
                  }),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              const Text('Sound Effect',
                  style: TextStyle(fontSize: 18, fontFamily: 'Silkscreen')),
              const SizedBox(width: 112),
              Switch(
                  value: soundEffectOn,
                  activeColor: Colors.amber,
                  trackColor: const MaterialStatePropertyAll(Colors.brown),
                  inactiveThumbColor: Colors.brown[300],
                  onChanged: (bool value) {
                    setState(() {
                      soundEffectOn = value;
                    });
                    settingsController.updateSoundEffectSetting(value);
                  }),
              const SizedBox.shrink(),
              const SizedBox.shrink()
            ]),
          ],
        ),
      ),
    );
  }
}
