import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/themes/app_theme.dart';


// ignore: must_be_immutable
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  
  final String title;
  final String? subtitle;
  final bool leading;
  final bool centerTitle;
  final Widget? trailing;
  final Color buttonColor;
  final VoidCallback? onBackButton;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final Style? styleType;

  const MyAppBar({
    Key? key,
   
    required this.title,
    this.subtitle,
    this.leading = true,
    this.centerTitle = false,
    this.trailing,
    this.buttonColor = Colors.white,
    this.onBackButton,
    this.backgroundColor ,
    this.foregroundColor ,
    this.elevation = 0,
    this.styleType
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: backgroundColor ?? AppTheme.appBarTheme(context).backgroundColor,
        leadingWidth: leading ? null : 1,
        flexibleSpace: _getStyle(context),
        
        leading: leading
            ? IconButton(
                onPressed: onBackButton ??
                    () {
                      Navigator.pop(context);
                    },
                icon: const Icon(
                  CupertinoIcons.chevron_back,
                ),
                color: foregroundColor ?? AppTheme.appBarTheme(context).foregroundColor,
              )
            : const SizedBox(),
        elevation: elevation,
        actions: [
          Container(
            child: trailing,
          )
        ],
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,style: AppTheme.textTheme(context).headlineSmall?.copyWith(fontSize: 21,fontWeight: FontWeight.bold,color: AppTheme.appBarTheme(context).foregroundColor),),
          if (subtitle != null)
            const SizedBox(
              height: 7,
            ),
          if (subtitle != null)
            Text(
              subtitle!,
             style: AppTheme.textTheme(context).headlineSmall?.copyWith(fontSize: 21,fontWeight: FontWeight.bold,color: AppTheme.appBarTheme(context).foregroundColor),
            )
        ]),
        centerTitle: centerTitle,
        titleTextStyle: const TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      );
  }

  @override
  Size get preferredSize => const Size(
        double.infinity,
        50,
      );
  _getStyle(context) {
    switch (styleType) {
      case Style.bgFillWhiteA700:
        return Container(
          height: 200,
          width: double.maxFinite,
          decoration:  BoxDecoration(
            color: AppTheme.primaryColor(context),
          ),
        );
      default:
        return null;
    }
  }
}

enum Style {
  bgFillWhiteA700,
}

