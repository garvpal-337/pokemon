
import 'package:flutter/material.dart';
import 'package:pokemon/providers/theme_provider.dart';
import 'package:pokemon/themes/app_theme.dart';
import 'package:pokemon/utils/dummy_data.dart';
import 'package:pokemon/widgets/search_bar.dart';
import 'package:pokemon/widgets/show_image.dart';
import 'package:pokemon/widgets/tab_bar.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
       color: AppTheme.scaffoldBackgroundColor(context),
       borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20))
      ),
       child: SafeArea(
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Container(
             padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                const ShowImage(
                 imagelink: 'assets/icons/pokemon.png',
                 height: 50,
                ),
                 const Spacer(),
                 viewOptionButton()
               ],
             ),
           ),
           const MySearchBar(),
           TabBarWidget(tabs: pokemonTypes, onTap: (value){})
         ],),
       ),
     );
  }
}

Widget viewOptionButton (){
  return Consumer<ThemeProvider>(builder: (context, theme, child) {
                 return   PopupMenuButton(
                            onSelected: (value) {
                               theme.gridCount = int.parse(value.toString());
                            },
                            itemBuilder: (ctx) {
                              return viewOptions.map((op){
                                return  PopupMenuItem(
                                    value: op['value'],
                                    child: Row(
                                      children:  [
                                        Icon(op['icon']),
                                       const  SizedBox(
                                          width: 10,
                                        ),
                                        Text(op['type'])
                                      ],
                                    ));
                              }).toList();
                              
                              
                            },
                            child:  Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                      children:  [
                                        Icon(viewOptions[theme.gridCount - 1]['icon']),
                                       const  SizedBox(
                                          width: 10,
                                        ),
                                        Text(viewOptions[theme.gridCount - 1]['type'])
                                      ],
                            ),)
                          ); 
                
               },);
}
