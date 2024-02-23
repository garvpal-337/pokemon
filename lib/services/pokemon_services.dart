import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pokemon/models/pokemon_model.dart';
import 'package:http/http.dart' as http;

class PokemonService{
  
  
  Future<List<Pokemon>> fetchAllPokemon({int offset = 0,int limit = 20}) async {
  String baseUrl = dotenv.env['POKEMON_API']!; 
  String url = '${baseUrl}pokemon?offset=$offset&limit=$limit';
  
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    
    final pokemonList = (data['results'] as List<dynamic>).cast<Map<String, dynamic>>();
    
    final List<Pokemon> pokemonData = [];
     

    final responses =  await  Future.wait(pokemonList.map((pokemon) {
      return http.get(Uri.parse(pokemon['url']));
    }).toList());

    for (final pokemon in responses) { 
      final pokemonbody = jsonDecode(pokemon.body); 
      final newPokemon = Pokemon.fromJson(pokemonbody);
      pokemonData.add(newPokemon);
    }
  
   return pokemonData;
  } else {
    
    throw Exception('Failed to fetch Pokemon. Status code: ${response.statusCode}');
  }
  }

  
  Future<List<Pokemon>> fetchPokemonByType(String type) async {
    final List<Pokemon> pokemonData = [];
    String baseUrl = dotenv.env['POKEMON_API']!; 
    String url = '${baseUrl}type/${type.toLowerCase()}';  
    
    final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final List<dynamic> pokemonList = data['pokemon'];

    final responses =  await  Future.wait(pokemonList.map((pokemon) {
      return http.get(Uri.parse(pokemon['pokemon']['url']));
    }).toList().take(20));

    
    for(var pokemon in responses){
       final pokemonbody = jsonDecode(pokemon.body); 
      final newPokemon = Pokemon.fromJson(pokemonbody);
      pokemonData.add(newPokemon);
    }
    
    return pokemonData;

  } else {
    throw Exception('Failed to fetch Pokemon by type. Status code: ${response.statusCode}');
  }
  }


  Future<Pokemon> searchPokemonByNameOrId(String name) async {
    String baseUrl = dotenv.env['POKEMON_API']!; 

    String url = '${baseUrl}pokemon/$name';

    final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final pokemonbody = jsonDecode(response.body) as Map<String, dynamic>;
    final pokemonData = Pokemon.fromJson(pokemonbody);
    return pokemonData;
  } else {
    throw Exception('Failed to search Pokemon by name. Status code: ${response.statusCode}');
  }
 }
 
 // it will give return the about of the pokemon 
 // using it to fetch the description of pokemon and showing it on details screen
 Future<About> getAboutPokemon({required String pokemonId})async{
    String baseUrl = dotenv.env['POKEMON_API']!; 
    String url = '${baseUrl}pokemon-species/$pokemonId';
    final speciesResponse = await http.get(Uri.parse(url));
    if (speciesResponse.statusCode == 200) {
      final speciesData = jsonDecode(speciesResponse.body) as Map<String, dynamic>;
      
      return About.fromJson(speciesData);
    } else {
      throw Exception('Failed to fetch species data. Status code: ${speciesResponse.statusCode}');
    }
 }
 
// this is to get eveolution chain of a perticular pokemon...
Future<List<Pokemon>> getPokemonEvolutionChain(String url)async {

  // getting evolution chain from the evolutionc chain url...
   final evolutionChainResponse = await http.get(Uri.parse(url));
      if (evolutionChainResponse.statusCode == 200) {
        final evolutionChainData = jsonDecode(evolutionChainResponse.body) as Map<String, dynamic>;
        
       

       // extracking data from the evolition chain in the Evolution(model in pokemon) format
       // with the help of recursion...
       // it will make it make it easy to read
       final result =  extractEvolutionChain(evolutionChainData['chain']);
      
       

       // now fetching the pokemon of each species by the name of pokemon
       final responses = await Future.wait(result.map((e) {
        debugPrint("strge : ${e.stage} : ${e.name}");
        return searchPokemonByNameOrId(e.name);
       }));
      
    
       // returning the pokemon list of the from the chain...   
       return responses;
      } else {
        throw Exception('Failed to fetch evolution chain data. Status code: ${evolutionChainResponse.statusCode}');
      }
}




List<Evolution> extractEvolutionChain(Map<String, dynamic> chain, [int stage = 1]) {
  List<Evolution> result = [];
  result.add(Evolution.fromJson(chain['species'], stage)); // Add current species as an Evolution object

  if (chain['evolves_to'] != null && chain['evolves_to'].isNotEmpty) {
   
    List<dynamic> evolvesTo = chain['evolves_to'];
    result.addAll(extractEvolutionChain(evolvesTo[0], stage + 1)); // Recursively extract evolution chain for the first evolves_to element
     
  }
 
  return result;
}
}


