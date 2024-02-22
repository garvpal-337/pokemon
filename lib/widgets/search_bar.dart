import 'package:flutter/material.dart';
import 'package:pokemon/providers/pokemon_provider.dart';
import 'package:pokemon/themes/app_theme.dart';
import 'package:provider/provider.dart';

class MySearchBar extends StatefulWidget {
   const MySearchBar({
    
    Key? key}) : super(key: key);

  

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  TextEditingController searchController = TextEditingController();
  String searchText= '';
  @override
  Widget build(BuildContext context) {
    return Consumer<PokemonProvider>(
      builder:(context, pokemonProv, child) {
        return Container(
          height: 45,
          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          padding: const EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade300,
          ),
          
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search by name or id",
                  hintStyle: TextStyle(color: Colors.black87)
                      
                  ),
                 
                ),
              ),
              Container(
                width: 70,
                height: 45,
                decoration: BoxDecoration(
                  color: AppTheme.appBarTheme(context).backgroundColor,
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
                  
                ),
                child: IconButton(
                        onPressed: ()async {
                           await pokemonProv.searchPokemonByNameOrId(context,searchController.text);
                        },
                        icon: Icon(Icons.search,size: 28,color: AppTheme.appBarTheme(context).foregroundColor),
                      ),
              ),
            ],
          ),
        );
      }
    );
  }
}