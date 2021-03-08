import 'package:flutter/material.dart';

// Box Decorations

BoxDecoration fieldDecortaion = BoxDecoration(
    borderRadius: BorderRadius.circular(5), color: Colors.grey[200]);

BoxDecoration disabledFieldDecortaion = BoxDecoration(
    borderRadius: BorderRadius.circular(5), color: Colors.grey[100]);

// Field Variables

const double fieldHeight = 55;
const double smallFieldHeight = 40;
const double inputFieldBottomMargin = 30;
const double inputFieldSmallBottomMargin = 0;
const EdgeInsets fieldPadding = const EdgeInsets.symmetric(horizontal: 15);
const EdgeInsets largeFieldPadding =
    const EdgeInsets.symmetric(horizontal: 15, vertical: 15);

// Text Variables
const TextStyle buttonTitleTextStyle =
    const TextStyle(fontWeight: FontWeight.w700, color: Colors.white);

const TextStyle sideHeadingTextStyle = const TextStyle(
  fontWeight: FontWeight.w300,
  fontSize: 24.0,
  color: Colors.black,
  textBaseline: TextBaseline.alphabetic,
);

const TextStyle namesTextStyle = const TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 16.0,
  color: Colors.black,
  textBaseline: TextBaseline.ideographic,
);
