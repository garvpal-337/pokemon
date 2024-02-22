import 'package:flutter/material.dart';
import 'package:pokemon/bottom_nav_bar.dart';
import 'package:pokemon/widgets/show_image.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});
  static const route = '/splashscreen';

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
 

  void navigateScreen(context) async {
    await Future.delayed(const Duration(seconds: 2), () async {
      Navigator.pushNamed(context, BottomNavBar.route);
    });
  }



  @override
  void initState() {
   navigateScreen(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body:  Container(
          height: size.height,
          width: size.width,
          alignment: Alignment.center,
          child:const  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                ShowImage(imagelink: 'assets/icons/poke_ball.png',
              height: 100,
              ),
             
               ShowImage(imagelink: 'assets/icons/pokemon.png',height: 70,),

            
            ],
          ),
        )
    );
  }
}
