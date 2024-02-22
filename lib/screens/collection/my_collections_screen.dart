import 'package:flutter/material.dart';
import 'package:pokemon/providers/theme_provider.dart';
import 'package:pokemon/providers/user_provider.dart';
import 'package:pokemon/widgets/appbar.dart';
import 'package:pokemon/widgets/pokemon_card.dart';
import 'package:provider/provider.dart';

class MyCollectionScreen extends StatefulWidget {
  const MyCollectionScreen({super.key});
  static const route = '/mycollectionscree';

  @override
  State<MyCollectionScreen> createState() => _MyCollectionScreenState();
}

class _MyCollectionScreenState extends State<MyCollectionScreen> {

  void getData()async {
    final userProv = Provider.of<UserProv>(context,listen: false);
    if(userProv.myPokemons.length != userProv.myPokemonId.length){
    await userProv.getmyPokemonsIds(getPokemonsToo: true);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){

    getData();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProv>(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    var size = MediaQuery.of(context).size;
    
    return  Scaffold(
      appBar:   const MyAppBar(title: 'My Collection',leading: false,),
      body:  (!userProv.getMyPokemonLoading && userProv.myPokemons.isEmpty) ? 
      const Center(child: Text('No Pokemon found in your collection'),)
      :GridView.builder(         
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: themeProv.gridCount,
                    mainAxisSpacing: 10,
                    mainAxisExtent: themeProv.gridCount == 2 ? size.height * 0.25 :size.height * 0.17 
                    ), 
                    itemCount: userProv.getMyPokemonLoading ?  8 : userProv.myPokemons.length,
                    itemBuilder: (context, index) {
                    if(userProv.getMyPokemonLoading){
                      
                    return  PokemonCardShimmer(gridCount: themeProv.gridCount,);
                    } else{
                    var item = userProv.myPokemons[index];
                    return PokemonCard(item: item,index: index,gridCount: themeProv.gridCount,);
                    }
                  },),
    );
  }
}