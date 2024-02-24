import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  Future<ThemeMode> themeMode() async => ThemeMode.system;

  Future<bool> backgroundMusicOn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool = prefs.getBool('backgroundMusicOn');
    if (bool == null) return true;
    return bool;
  }

  Future<bool> soundEffectOn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool = prefs.getBool('soundEffectOn');
    if (bool == null) return true;
    return bool;
  }

  Future<void> updateBackgroundMusicSetting(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('backgroundMusicOn', value);
  }

  Future<void> updateSoundEffectSetting(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('backgroundMusicOn', value);
  }
}
