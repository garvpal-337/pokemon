
import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon_model.dart';
import 'package:pokemon/services/pokemon_services.dart';
import 'package:pokemon/widgets/widget_components.dart';


class PokemonProvider extends ChangeNotifier{

// it will contain all pokemons and the item will increase as user scroll down
List<Pokemon> _pokemons = [];

List<Pokemon> get pokemons {
  return [..._pokemons];
}


// it will contain filteres pokemon,
// ex. if we click on any type like fire, gass it will store in it
// searched pokemons will also add in this
List<Pokemon> _filteredPokemon = [];

List<Pokemon> get filteredPokemon {
  return [..._filteredPokemon];
}

// it will contains pokemons with there types
// {"fire":[pokemon1 , pokemon2]}.. and so on...
// I make this so that i dont have to fetch data again and again
// it will store pokemon with type fire and if 
// i again click on fire then it will give the same list 
Map<String,List<Pokemon>> _pokemonByType = {};

Map<String,List<Pokemon>> get pokemonByType {
  return {..._pokemonByType};
}

// it is a selected pokemon type if will change when user click on any type 
String selectedType = "All";

// it is a limit to fetch only limited pokemon every time to imporve app performance and user experience
int limit = 20;




// loadin for fetching pokemons..
bool getAllLoading =  false;  

// it will fetch first $limit(20) pokemon on home initialization..
void getAllPokemon() async {
  fetchLoadingToggle(true);
  try{
    List<Pokemon> pokemonData = await PokemonService().fetchAllPokemon();
   _pokemons = pokemonData;
   fetchLoadingToggle(false);
   notifyListeners();
  }catch(e){
   fetchLoadingToggle(false);

    debugPrint('error found while getAllPokemon()\nerror : $e');
    rethrow;
  }
}

bool fetchMoreLoading = false;

// This function will call when user scroll down to and reach the end of the list
// then it will fetch more $limit pokemon and so on
Future<void> fetchMorePokemons()async{
  
  fetchMoreLoadingToggle(true);
 
  try{
    List<Pokemon> pokemonData = await PokemonService().fetchAllPokemon(offset: _pokemons.length,limit: limit);
   _pokemons.addAll(pokemonData);
   fetchMoreLoadingToggle(false);
   notifyListeners();
  }catch(e){
   fetchMoreLoadingToggle(false);

    debugPrint('error found while getAllPokemon()\nerror : $e');
    rethrow;
  }
}

bool filteringLoading = false;
// it will fetch pokemon by their type and add it to _filteredPokemon to show filteres data on screen 
Future<void> getPokemonByType(String type) async {
  selectedType = type;
  if(type == 'All'){
    // if user select all then we dont need to filter anyv data 
    _filteredPokemon = [];
    notifyListeners();
  }else if(_pokemonByType[type] != null){
    // if we already fetched the type then we dont have to fetch it again 
   _filteredPokemon = _pokemonByType[type] ?? [];
   notifyListeners();
  }else{
    // if we dont have this type of pokemon then we have to fetch it ...
  filteringLoadingToggle(true);
   try{
   final pokemonData =  await PokemonService().fetchPokemonByType(type);
    
    _pokemonByType[type] = pokemonData;

    _filteredPokemon = pokemonData;

    filteringLoadingToggle(false);

   }catch(e){
    filteringLoadingToggle(false);
    
    debugPrint('error found while getPokemonByType()\nerror : $e');
    rethrow;
   }
  }
  
  }
 // it will search pokemon by its name or id, used in search bar
  Future<void> searchPokemonByNameOrId(context,String search)async {
    try{

     if(search.isNotEmpty){
             filteringLoadingToggle(true);
     final pokemonData = await PokemonService().searchPokemonByNameOrId(search);
    
     _filteredPokemon = [pokemonData];
            filteringLoadingToggle(false);
     notifyListeners();
     }else{
       getPokemonByType(selectedType);
     }
    }catch(e){
    filteringLoadingToggle(false);
    mySnackBar(context, 'No search result found...');
    debugPrint('error found while searchPokemonByNameOrId()\nerror : $e');
    rethrow;
    }
  }
  



 

 // these are the loading handlers to handle UI if the data is loading...
 void fetchLoadingToggle(bool value) {
   getAllLoading = value;
   notifyListeners();
 } 

 void filteringLoadingToggle(bool value) {
   filteringLoading = value;
   notifyListeners();
 } 

 void fetchMoreLoadingToggle(bool value) {
   fetchMoreLoading = value;
   notifyListeners();
 } 



}