
import 'package:flutter/material.dart';
import 'package:pokemon/themes/app_theme.dart';

Widget myIconButton({
  required dynamic icon,
  color,
  onTap,
  double size = 50,
  double radius = 5,
  double margin = 0,
  borderColor = Colors.transparent,
}) {
  return GestureDetector(
    
    
    onTap: onTap,
    child: Container(
      height: size,
      width: size,
      margin: EdgeInsets.all(margin),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(radius),
        color: color,
      ),
      child: icon,
    ),
  );
}



mySnackBar(context, message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      clipBehavior: Clip.antiAlias,
      duration: const Duration(seconds: 1),
      backgroundColor: AppTheme.appBarTheme(context).backgroundColor,
      content: Text(message,style: TextStyle(color: AppTheme.appBarTheme(context).foregroundColor),)));
}
