import 'package:flutter/material.dart';

abstract class CustomColors {
  static const statusBar = Color.fromRGBO(225, 170, 15, 1);

  static const primary = MaterialColor(0xFFf1e4e8, {
    0: Color.fromRGBO(241, 228, 232, .0),
    50: Color.fromRGBO(241, 228, 232, .05),
    100: Color.fromRGBO(241, 228, 232, .2),
    200: Color.fromRGBO(241, 228, 232, .3),
    300: Color.fromRGBO(241, 228, 232, .4),
    400: Color.fromRGBO(241, 228, 232, .5),
    500: Color.fromRGBO(241, 228, 232, .6),
    600: Color.fromRGBO(241, 228, 232, .7),
    700: Color.fromRGBO(241, 228, 232, .8),
    800: Color.fromRGBO(241, 228, 232, .9),
    900: Color.fromRGBO(241, 228, 232, 1),
  });

  static const secondary = MaterialColor(0xFFb97375, {
    0: Color.fromRGBO(185, 115, 117, .0),
    50: Color.fromRGBO(185, 115, 117, .05),
    100: Color.fromRGBO(185, 115, 117, .2),
    200: Color.fromRGBO(185, 115, 117, .3),
    300: Color.fromRGBO(185, 115, 117, .4),
    400: Color.fromRGBO(185, 115, 117, .5),
    500: Color.fromRGBO(185, 115, 117, .6),
    600: Color.fromRGBO(185, 115, 117, .7),
    700: Color.fromRGBO(185, 115, 117, .8),
    800: Color.fromRGBO(185, 115, 117, .9),
    900: Color.fromRGBO(185, 115, 117, 1),
  });

  static const primarySingle = Color.fromRGBO(241, 228, 232, 1);

  static const secondarySingle = Color.fromRGBO(185, 115, 117, 1);
}
