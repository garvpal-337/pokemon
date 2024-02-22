

import 'package:flutter/material.dart';
import 'package:pokemon/providers/user_provider.dart';
import 'package:pokemon/screens/account/account_screen.dart';
import 'package:pokemon/screens/collection/my_collections_screen.dart';
import 'package:pokemon/screens/home/home_screen.dart';
import 'package:pokemon/services/fmc_services.dart';
import 'package:pokemon/widgets/my_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});
  static const route = '/bottomnavbar';

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List navBaricons = [
    {
      'icon': 'assets/icons/PokeHeart.svg',
      'iconfilled': 'assets/icons/PokeHeart-filled.svg',
      'iconwhite': 'assets/icons/PokeHeart.svg',
      'label': 'Collection',
    },
    {
      'icon': 'assets/icons/pokeball.svg',
      'iconfilled': 'assets/icons/pokeball-filled.svg',
      'iconwhite': 'assets/icons/Group 53.svg',
      'label': 'Pokemons',
    },
    {
      'icon': 'assets/icons/acc.svg',
      'iconfilled': 'assets/icons/acc-filled.svg',
      'iconwhite': 'assets/icons/Group 55.svg',
      'label': 'Setting',
    },
   
  ];


  Future<void> fetchData(context) async {
   final userProv = Provider.of<UserProv>(context,listen: false);
  // sorry for the extra code. I did this to store token user token 
  // for sending the notification from backend trigger...
   await userProv.initializeUser();
  //  await userProv.getuserDetails();

  // fetching captured pokemons Ids, 
  // so that i can figure out which pokemon is  and which is not.. 
    await userProv.getmyPokemonsIds();
    
  // initializing firebase messaging to handle notification events  
   FMCService.initializeMessaging(context); 
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
     
      fetchData(context).then((value) {});
    });

    super.initState();
  }

  List tabs = [
    const MyCollectionScreen(),
    const HomeScreen(),
   const  AccountScreen(),
  ];

  int selectedIndex = 1;
  String selectedTab = 'Pokemons';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: tabs[selectedIndex],
       
        
        bottomNavigationBar: WillPopScope(
          onWillPop: () async {
            if (selectedIndex > 0) {
              setState(() {
                selectedIndex = 0;
              });
              return false;
            } else {
              return true;
            }
          },
          child: MyBottomNavBar(
          
            currentIndex: selectedIndex,
           
          
            onTap: (index) async {
              
             
              setState(() {
                selectedIndex = index;
              });
            },
           
            bottomNavBarItems: navBaricons.map((item) {
              return BottomNavBarItem(
                label: item['label'],
                icon: item['icon'],
                activeIcon: item['iconfilled']
              );
            }).toList(),
          ),
        ));
  }
}
