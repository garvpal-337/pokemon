import 'package:flutter/material.dart';
import 'package:pokemon/providers/pokemon_provider.dart';
import 'package:pokemon/providers/theme_provider.dart';
import 'package:pokemon/themes/app_theme.dart';
import 'package:pokemon/themes/themes.dart';
import 'package:provider/provider.dart';

class TabBarWidget extends StatelessWidget {
  const  TabBarWidget({
    required this.tabs,
    required this.onTap,
    Key? key}) : super(key: key);
  final List tabs;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context,listen: true);
    final pokemonProv = Provider.of<PokemonProvider>(context,listen: true);
    bool isDark = themeProv.themeData == darkTheme;
    int initilIndex = tabs.indexOf(pokemonProv.selectedType);
    return DefaultTabController(
        initialIndex: initilIndex,
        length: tabs.length,
        child:  TabBar(
        isScrollable: true,
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0), 
        indicator: BoxDecoration( 
        color: AppTheme.appBarTheme(context).backgroundColor, 
        borderRadius: BorderRadius.circular(10), 
        ),  
        
        dividerColor: Colors.transparent,
        unselectedLabelColor: isDark ? Colors.grey : AppTheme.appBarTheme(context).backgroundColor,
        labelColor: AppTheme.appBarTheme(context).foregroundColor,
        onTap: (value) {
         
            pokemonProv.getPokemonByType(tabs[value]);
        },        
        physics: const BouncingScrollPhysics(),   
        tabAlignment: TabAlignment.start,
        tabs: tabs.map((tabText) {
        return Container(
        
         width:  100,
         alignment: Alignment.center,
         padding: const EdgeInsets.symmetric(vertical: 10),
         child: Text(
           tabText,
           // style: myTitleTextStyle.copyWith(
           //   color: isSelected
           //       ? myWhiteColor 
           //       : myPrimaryColor,
           // ),
         ),
                );
               }).toList(),),);
     
    
  }
}