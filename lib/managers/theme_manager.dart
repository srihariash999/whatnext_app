import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatnext/ui/themes/themes.dart';

Future<ThemeData> getSavedTheme() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();

  return getThemes().elementAt(_prefs.getInt('theme') ?? 0);
}
