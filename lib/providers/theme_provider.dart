import 'package:flutter/material.dart';
import 'package:pokemon/themes/themes.dart';

class ThemeProvider extends ChangeNotifier{

  // theme data will notify the app which theme is selected.
  ThemeData _themeData = lightTheme;
  
  ThemeData get themeData => _themeData;
  
  // if we change the theme in the app it will set the themedata
  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }


  void themeToggle(){
    if(_themeData == lightTheme){
      themeData = darkTheme;
    }else{
      themeData = lightTheme;
    }
  }
  
  // this is grid count it is for crossAxisCount in grid view..
  // I am using it to change the UI according to the users prefference..
  // count = 1; to show list 
  // count = 2; to show grid 2x2
  // count = 3; tos show grid 3x3
  int _gridCount = 1;

  int get gridCount => _gridCount;
 
 // If user change the type it will change the count according to that type...
  set gridCount(int count){
    _gridCount = count;
    notifyListeners();
  }



  // I am using this for notification toggle only   
  bool _allowNotification = true;

  bool get allowNotification => _allowNotification;

  set allowNotification(bool value){
    _allowNotification = value;
    notifyListeners();
  }
  
}