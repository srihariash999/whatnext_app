import 'package:flutter/material.dart';

List<ThemeData> getThemes() {
  return [getLightTheme(), getDarkTheme(), getMintForestTheme()];
}

ThemeData getLightTheme() => ThemeData(
      backgroundColor: Colors.white,
      accentColor: Colors.white70,
      primaryColor: Color(0XFFfff2f2),
      dialogBackgroundColor: Colors.white70,
      cardColor: Colors.white70,
      primaryColorLight: Colors.black54,
      scaffoldBackgroundColor: Colors.white,
      primaryTextTheme: TextTheme(
        headline1: TextStyle(
          color: Color(0xFF545050),
          fontWeight: FontWeight.w600,
          fontSize: 24.0,
        ),
        headline2: TextStyle(
          color: Color(0xFF545050),
          fontWeight: FontWeight.w400,
          fontSize: 20.0,
        ),
        headline3: TextStyle(
          color: Color(0xFF545050),
          fontWeight: FontWeight.w300,
          fontSize: 18.0,
        ),
        headline4: TextStyle(
          color: Color(0xFF545050),
          fontWeight: FontWeight.w300,
          fontSize: 16.0,
        ),
        headline5: TextStyle(
          color: Color(0xFF545050),
          fontWeight: FontWeight.w300,
          fontSize: 14.0,
        ),
        bodyText1: TextStyle(
          color: Color(0xFF545050),
          fontWeight: FontWeight.w400,
          fontSize: 18.0,
        ),
        bodyText2: TextStyle(
          color: Color(0xFF545050),
          fontWeight: FontWeight.w300,
          fontSize: 16.0,
        ),
      ),
    );

ThemeData getDarkTheme() => ThemeData(
      backgroundColor: Color(0xFF1B1929),
      accentColor: Color(0xFF4a4e69),
      primaryColor: Color(0XFF22223b),
      dialogBackgroundColor: Color(0XFFbcb8b1),
      cardColor: Color(0XFF415a77),
      primaryColorLight: Color(0xFFf2e9e4),
      scaffoldBackgroundColor: Color(0xFF1B1929),
      primaryTextTheme: TextTheme(
        headline1: TextStyle(
          color: Color(0xFFf2e9e4),
          fontWeight: FontWeight.w600,
          fontSize: 24.0,
        ),
        headline2: TextStyle(
          color: Color(0xFFf2e9e4),
          fontWeight: FontWeight.w400,
          fontSize: 20.0,
        ),
        headline3: TextStyle(
          color: Color(0xFFf2e9e4),
          fontWeight: FontWeight.w300,
          fontSize: 18.0,
        ),
        headline4: TextStyle(
          color: Color(0xFFf2e9e4),
          fontWeight: FontWeight.w300,
          fontSize: 16.0,
        ),
        headline5: TextStyle(
          color: Color(0xFFf2e9e4),
          fontWeight: FontWeight.w300,
          fontSize: 14.0,
        ),
        bodyText1: TextStyle(
          color: Color(0xFFf2e9e4),
          fontWeight: FontWeight.w400,
          fontSize: 18.0,
        ),
        bodyText2: TextStyle(
          color: Color(0xFFf2e9e4),
          fontWeight: FontWeight.w300,
          fontSize: 16.0,
        ),
      ),
    );

ThemeData getMintForestTheme() => ThemeData(
      backgroundColor: Color(0xFFA3EBB1),
      accentColor: Color(0xFF38c49c),
      primaryColor: Color(0XFF38c49c),
      dialogBackgroundColor: Color(0XFFB1D8B7),
      cardColor: Color(0XFF38c49c),
      primaryColorLight: Color(0xFF293321),
      scaffoldBackgroundColor: Color(0xFFA3EBB1),
      primaryTextTheme: TextTheme(
        headline1: TextStyle(
          color: Color(0xFF293321),
          fontWeight: FontWeight.w600,
          fontSize: 24.0,
        ),
        headline2: TextStyle(
          color: Color(0xFF293321),
          fontWeight: FontWeight.w400,
          fontSize: 20.0,
        ),
        headline3: TextStyle(
          color: Color(0xFF293321),
          fontWeight: FontWeight.w300,
          fontSize: 18.0,
        ),
        headline4: TextStyle(
          color: Color(0xFF293321),
          fontWeight: FontWeight.w300,
          fontSize: 16.0,
        ),
        headline5: TextStyle(
          color: Color(0xFF293321),
          fontWeight: FontWeight.w300,
          fontSize: 14.0,
        ),
        bodyText1: TextStyle(
          color: Color(0xFF293321),
          fontWeight: FontWeight.w400,
          fontSize: 18.0,
        ),
        bodyText2: TextStyle(
          color: Color(0xFF293321),
          fontWeight: FontWeight.w300,
          fontSize: 16.0,
        ),
      ),
    );
