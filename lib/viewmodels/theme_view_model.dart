import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatnext/ui/themes/themes.dart';
import 'package:whatnext/viewmodels/base_model.dart';

class ThemesViewModel extends BaseModel {
  ThemeData _td;

  ThemeData get theme => _td;

  int _themeIndex = 0;
  int get themeIndex => _themeIndex;

  onInit() async {
    setBusy(true);
    await getSavedTheme();
    print(_td);
    print(" something");
    setBusy(false);
  }

  getSavedTheme() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _themeIndex = _prefs.getInt('theme');
    setState();
    print(" this is theme indexz: $_themeIndex");
    _td = getThemes().elementAt(_prefs.getInt('theme') ?? 0);
    print(" this is td : $_td");
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
