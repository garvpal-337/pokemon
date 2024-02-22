import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor:const  Color(0xFF3F51B5),
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 30.0, color: Colors.black),
    bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
  ),
 
  appBarTheme:  const AppBarTheme(
    color:  Color(0xFF3F51B5),
    foregroundColor:  Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.white,
    unselectedLabelColor: Colors.grey,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor:const Color(0xFF3F51B5).withOpacity(0.4),
 
  scaffoldBackgroundColor:  Colors.blueGrey[900],
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 30.0, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16.0, color: Colors.white70),
  ),

  appBarTheme:    AppBarTheme(
    color: Colors.blueGrey[600],
    foregroundColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.tealAccent,
    unselectedLabelColor: Colors.white54,
  ),
);
