import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ColorsGenerator {
  // it will generate card color according to the image of the opemon
  Future<Color?> generateCardColor(
      String pokemonImageUrl, bool isDarkTheme) async {
    
    Color? cardColor;
    try {
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
          NetworkImage(pokemonImageUrl));
      // it will get the domain color from the pokemon image
      if (paletteGenerator.dominantColor != null) {
        if (isDarkTheme) {
       
          cardColor = paletteGenerator.dominantColor!.color.withAlpha(40);
        } else {
          
          cardColor = paletteGenerator.dominantColor!.color.withOpacity(0.25);
        }
      }
    } catch (error) {
      rethrow;
    }
    return cardColor;
  }
}