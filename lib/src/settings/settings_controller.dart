import 'package:flutter/material.dart';
import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);
  final SettingsService _settingsService;

  late bool _backgroundMusicOn;
  bool get backgroundMusicOn => _backgroundMusicOn;

  late bool _soundEffectOn;
  bool get soundEffectOn => _soundEffectOn;

  Future<void> loadSettings() async {
    _backgroundMusicOn = await _settingsService.backgroundMusicOn();
    _soundEffectOn = await _settingsService.soundEffectOn();

    notifyListeners();
  }

  Future<void> updateBackgroundMusicSetting(bool? value) async {
    if (value == null) return;
    if (value == _backgroundMusicOn) return;

    _backgroundMusicOn = value;
    notifyListeners();
    await _settingsService.updateBackgroundMusicSetting(value);
  }

  Future<void> updateSoundEffectSetting(bool? value) async {
    if (value == null) return;
    if (value == _soundEffectOn) return;

    _soundEffectOn = value;
    notifyListeners();
    await _settingsService.updateSoundEffectSetting(value);
  }
}
