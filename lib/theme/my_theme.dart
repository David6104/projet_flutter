import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData light() =>
      ThemeData(brightness: Brightness.light, primarySwatch: Colors.blue);

  static ThemeData dark() => ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(primary: Colors.deepPurple),
  );
}
