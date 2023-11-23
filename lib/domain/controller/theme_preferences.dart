import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {
  static const THEME_MODE = "MODE";
  SharedPreferences? _prefs;

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setTheme(String theme) async {
    await _prefs!.setString(THEME_MODE, theme);
  }

  String getTheme() {
    if (_prefs == null || !_prefs!.containsKey(THEME_MODE)) {
      setTheme('LIGHT');
      return 'LIGHT';
    }
    return _prefs!.getString(THEME_MODE)!;
  }
}
