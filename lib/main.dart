import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pokemon/providers/pokemon_provider.dart';
import 'package:pokemon/providers/theme_provider.dart';
import 'package:pokemon/providers/user_provider.dart';
import 'package:pokemon/routes/app_routs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pokemon/screens/splash%20screen/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyAnbLl52aL94p4eCmiYUjxzzlmrQBnxvr4', 
        appId: '1:1012576249992:android:6a720962cb0bf68464173d',   
        messagingSenderId: '1012576249992', 
        projectId: 'pokemon-7e947',  ),
  );
  
  // using dotenv for the safety pusposes...
  // added POKEMON_API in assets/.env and loading it to dotenv
  await dotenv.load(fileName: 'assets/.env');

  runApp(
    ChangeNotifierProvider(create: (ctx) => ThemeProvider(),
    child: const MyApp(),
    ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PokemonProvider(),),
        ChangeNotifierProvider(create: (context) => UserProv(),)  
      ],
      child: MaterialApp(
        title: 'Pokémon',
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).themeData,
        routes: Routes.getAll(),
        home: const MySplashScreen(),
      ),
    );
  }
}
