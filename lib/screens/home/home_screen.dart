import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon_model.dart';
import 'package:pokemon/providers/pokemon_provider.dart';
import 'package:pokemon/providers/theme_provider.dart';
import 'package:pokemon/screens/home/header.dart';
import 'package:pokemon/widgets/pokemon_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const route = '/homescreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  ScrollController _scrollController = ScrollController();
  
  

  void getData()async{

    final pokemonProv = Provider.of<PokemonProvider>(context,listen: false);
    if(pokemonProv.pokemons.isEmpty){
     pokemonProv.getAllPokemon();
     }
    
  }

  void scrollListener(){
    _scrollController.addListener(() async {
      final pokemonProv = Provider.of<PokemonProvider>(context, listen: false);
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double threshold = 80.0; // Adjust this threshold as needed

      if ((maxScroll - currentScroll <= threshold) && pokemonProv.selectedType == 'All') {
        
        if (pokemonProv.getAllLoading) {
          _scrollController.jumpTo(maxScroll);
        } else {
          pokemonProv.fetchMorePokemons();
        }
      }
    });
  }


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){

    getData();
    scrollListener();
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final pokemonProv = Provider.of<PokemonProvider>(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    var size = MediaQuery.of(context).size;
    final List<Pokemon> pokemons = pokemonProv.filteredPokemon.isEmpty ? pokemonProv.pokemons : pokemonProv.filteredPokemon;
    int gridCount = themeProv.gridCount;
   
    return Scaffold(
      body: Column(
        children: [
          const HomeHeader(), 
        
          Expanded(
            child: SingleChildScrollView(
               controller: _scrollController,
              child: Column(
                children: [
                  
                  GridView.builder(
                    shrinkWrap: true,
                    physics:const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCount,
                    mainAxisSpacing: 10,
                    mainAxisExtent: gridCount == 2 ? size.height * 0.25 :size.height * 0.17 
                    ), 
                  itemCount: pokemonProv.getAllLoading ? 8 : pokemons.length,
                  itemBuilder: (context, index) {
                    if(pokemonProv.getAllLoading || pokemonProv.filteringLoading){
                    return  PokemonCardShimmer(gridCount: gridCount);
                    }else{
                    var item = pokemons[index];
                    return PokemonCard(item: item,index: index,gridCount: gridCount,);
                    }
                  },),
              
                 if(pokemonProv.fetchMoreLoading)
                GridView.builder(
                shrinkWrap: true,
                physics:const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridCount,
                mainAxisSpacing: 10,
                mainAxisExtent: gridCount == 2 ? size.height * 0.25 :size.height * 0.17 
                ), 
              itemCount: gridCount,
              itemBuilder: (context, index) {
                
                return  PokemonCardShimmer(gridCount: gridCount,);
                
              },),
                ],
              ),
            ),
          ),
        
        ],
      ),
    );
  }
}
