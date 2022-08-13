import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatnext/ui/themes/themes.dart';
import 'package:whatnext/providers/base_provider.dart';

class ThemesProvider extends BaseProvider {
  ThemeData _td;

  ThemeData get theme => _td;

  int _themeIndex = 0;
  int get themeIndex => _themeIndex;

  onInit() async {
    setBusy(true);
    await getSavedTheme();
    // print(_td);
    // print(" something");
    setBusy(false);
  }

  getSavedTheme() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _themeIndex = _prefs.getInt('theme');
    setState();

    // Get Saved theme. Defaults to `1` (Dark Theme)
    _td = getThemes().elementAt(_prefs.getInt('theme') ?? 1);
    // print(" this is td : $_td");
    setState();
  }

  setTheme(int index, BuildContext context) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    _prefs.setInt('theme', index);
    _td = getThemes().elementAt(_prefs.getInt('theme') ?? 0);

    setState();
    Phoenix.rebirth(context);
  }
}
