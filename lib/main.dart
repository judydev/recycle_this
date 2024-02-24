import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:recycle_this/src/routes.dart';
import 'package:recycle_this/src/settings/settings_controller.dart';
import 'package:recycle_this/src/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlameAudio.audioCache.loadAll(
      ['correct.m4a', 'game_over.m4a', 'game_pass.m4a', 'wrong.m4a', ...bgms]);

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  runApp(MyApp(settingsController: settingsController));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.settingsController});
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings routeSettings) =>
          generateRoutes(routeSettings, settingsController),
      initialRoute: '/',
    );
  }
}

List<String> bgms = [
  'Acoustic_BPM105.wav',
  'Comedy_BPM130.wav',
  'Lofi_Hip_Hop_BPM85.wav',
  'Pop_BPM105.wav',
  'Pop_BPM136.wav',
  'Rnb_BPM130.wav',
  'Rock_BPM100.wav'
];
