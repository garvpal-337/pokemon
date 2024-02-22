import 'package:flutter/material.dart';
import 'package:pokemon/providers/theme_provider.dart';
import 'package:pokemon/screens/home/header.dart';
import 'package:pokemon/themes/app_theme.dart';
import 'package:pokemon/themes/themes.dart';
import 'package:pokemon/widgets/appbar.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: const MyAppBar(title: 'Settings',leading: false,),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 10,),
          NotificationTile(
            title: "Notification",
            subtitle: "Daily Pokemon Notification", 
          
             trailing: Switch(value: themeProv.allowNotification, 
             onChanged: (value) {
                 themeProv.allowNotification = value;
             },),
             ),
        
              NotificationTile(
            title: "App Theme",
            subtitle: "Light Mode", 
           
             trailing: Switch(value: themeProv.themeData == lightTheme, 
             onChanged: (value) {
                 themeProv.themeToggle();
             },),
             ),
        
              NotificationTile(
              title: "Pokemon View",
              subtitle: "Pokemon view type", 
              trailing: viewOptionButton(),
             ),
            
        ],),
      ),
    );

  
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.title,
    required this.subtitle,
   
    this.trailing,
  });

  final String title;
  final String subtitle;
 
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor(context).withOpacity(0.2)
        ,borderRadius: BorderRadius.circular(10)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [           
         Text(title,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        const SizedBox(height: 20,),
        Row(children: [
          const SizedBox(width: 0,),
           Text(subtitle,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
          const Spacer(),
          trailing ?? const SizedBox(),
           
             
        ],)
      ],),
    );
  }
}