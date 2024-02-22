import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokemon/providers/theme_provider.dart';
import 'package:pokemon/themes/app_theme.dart';
import 'package:pokemon/themes/themes.dart';
import 'package:provider/provider.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({
    super.key,
    this.height = 65,
    this.elevation = 0,
    required this.bottomNavBarItems,
    required this.currentIndex,
    this.onTap,
  });

  final double height;
  
  final double elevation;
  final List<BottomNavBarItem> bottomNavBarItems;
  final int currentIndex;
  final void Function(int index)? onTap;
  

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;


  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400))
      ..forward();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final themeProv = Provider.of<ThemeProvider>(context,listen: true);
    bool isdark = themeProv.themeData == darkTheme;
    return Container(
      height: widget.height,
      width: size.width * 0.9,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      decoration: 
          BoxDecoration(
            color: AppTheme.scaffoldBackgroundColor(context),
           
          ),
      child: Row(
        children: widget.bottomNavBarItems.map((item) {
          var itemIndex = widget.bottomNavBarItems.indexOf(item);
          bool isSelected = widget.currentIndex == itemIndex;
          return Expanded(
            child:GestureDetector(
                onTap: () {
                  widget.onTap!(itemIndex);
                  // if(isSelected){
                    _controller.reset();
                    _controller.forward();
                  // }
               
                },
                child: !isSelected
                    ? Container(
                        width: size.width / 4 - 60 > 130
                            ? 130
                            : size.width / 4 - 60,
                        height:
                            size.height * 0.05 < 35 ? 35 : size.height * 0.05,
    
                       
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.012, 
                        ),
                        child: SvgPicture.asset(
                                 item.icon ?? '',
                                 colorFilter: isdark ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null,
                                 height: 25,
                                ),)
                    : FadeTransition(
                        opacity: _animation,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Container(
                            alignment: Alignment.center,
                            width: size.width / 3.5 > 130
                                ? 130
                                : size.width / 3.5,
                            height: size.height * 0.05 < 35
                                ? 35
                                : size.height * 0.05,
                            decoration: isSelected
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        size.width * 0.1),
                                       
                                  )
                                : null,
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.004,
                                horizontal: size.width * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.005),
                                  child: SvgPicture.asset(
                                 item.activeIcon ?? '',
                                 height: 25,
                                ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                               if(item.label != null) Text(
                                  item.label??'',
                                  style:  TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: isdark ? Colors.yellow : Colors.red),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
              )
          );
        }).toList(),
      ),
    );
  }
}

class BottomNavBarItem {
  String? icon;
  String? activeIcon;
  String? label;

  BottomNavBarItem({this.icon, this.activeIcon, this.label});
}
