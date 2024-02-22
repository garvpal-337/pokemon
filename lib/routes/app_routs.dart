
import 'package:flutter/material.dart';
import 'package:pokemon/bottom_nav_bar.dart';
import 'package:pokemon/screens/home/home_screen.dart';
import 'package:pokemon/screens/pokemon/pokemon_details_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getAll() => _routes;
  static final Map<String, WidgetBuilder> _routes = {
   HomeScreen.route:(context) =>  const HomeScreen(),
   PokemonDetailsScreen.route:(context) => PokemonDetailsScreen(),
   BottomNavBar.route:(context) => BottomNavBar(),
  };
}
