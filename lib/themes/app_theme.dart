import 'package:flutter/material.dart';

class AppTheme {
  static Brightness brightness(BuildContext context) {
    return Theme.of(context).brightness;
  }

  static Color primaryColor(BuildContext context) {
    return Theme.of(context).primaryColor;
  }

  static Color scaffoldBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  static TextTheme textTheme(BuildContext context) {
    return Theme.of(context).textTheme;
  }



  static AppBarTheme appBarTheme(BuildContext context) {
    return Theme.of(context).appBarTheme;
  }

  static TabBarTheme tabBarTheme(BuildContext context) {
    return Theme.of(context).tabBarTheme;
  }

  // Add more methods as needed for other theme properties
}
