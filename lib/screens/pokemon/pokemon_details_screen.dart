import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon_model.dart';
import 'package:pokemon/providers/user_provider.dart';
import 'package:pokemon/screens/pokemon/evelution_view.dart';
import 'package:pokemon/screens/pokemon/stats_view.dart';
import 'package:pokemon/services/pokemon_services.dart';
import 'package:pokemon/themes/app_theme.dart';
import 'package:pokemon/widgets/appbar.dart';
import 'package:pokemon/widgets/capture_release_button.dart';
import 'package:pokemon/widgets/shimmer_container.dart';
import 'package:pokemon/widgets/show_image.dart';
import 'package:provider/provider.dart';

class PokemonDetailsScreen extends StatefulWidget {
  const PokemonDetailsScreen({super.key});
  static const route = '/pokemondetailsscreen';

  @override
  State<PokemonDetailsScreen> createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen> {
  About? aboutPokemon;
  void updateAbout()async{
    final args = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
    Pokemon pokemon = args['pokemon'];
    await  PokemonService().getAboutPokemon(pokemonId: pokemon.id.toString()).then((value) {
    setState(() {
      aboutPokemon = value;
    });
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
    updateAbout();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final args = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
    Pokemon pokemon = args['pokemon'];
    Color color = args['color'];
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        PokemonService().getPokemonEvolutionChain(aboutPokemon!.evolutionUrl!).then((value) {
         
        });
      }),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.45,
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.5),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(100))  
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                       Consumer<UserProv>(
                         builder:(context, userProv, child){
                          bool isSelected = userProv.isSelected(pokemon.id!);
                           return  MyAppBar(title: '',backgroundColor: Colors.transparent,
                           trailing: Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 15),
                             child: CaptureReleaseButton(initialValue: isSelected, onClick: (){
                               if(isSelected){
                                                   userProv.addAndRemoveToMyPokemons(context,pokemon: pokemon, addPokemon: false);
                                                 }else{
                                                   userProv.addAndRemoveToMyPokemons(context,pokemon: pokemon, addPokemon: true);
                             
                                                 }
                             }, value: (value) {
                               
                             },),
                           ),
                           );
                         }
                       ),
                        Hero(
                          tag: pokemon.name!,
                          child: ShowImage(imagelink: pokemon.svgUrl,boxFit: BoxFit.contain,
                          height: size.height * 0.3,
                          )),
                      ],
                    ),
                  ),
        
                 
                ],
              ),
            ),
            
             Padding(
               padding: const EdgeInsets.all(15.0),
               child: Text(pokemon.name?.toUpperCase() ?? '',style: AppTheme.textTheme(context).headlineSmall?.copyWith(fontWeight: FontWeight.bold,color: color.withOpacity(1)),),
             ),
            if(aboutPokemon == null) 
            Padding(
               padding: const EdgeInsets.symmetric(horizontal: 15),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   ShimmerContainer(height: 20, width: size.width * 0.8),
                   const SizedBox(height: 10,),
                   ShimmerContainer(height: 20, width: size.width * 0.5)

                 ],
               ),
             ),
             if(aboutPokemon != null)  Padding(
               padding: const EdgeInsets.symmetric(horizontal: 15),
               child: Text(aboutPokemon?.flavourText ?? '',style: AppTheme.textTheme(context).bodyLarge?.copyWith(fontWeight: FontWeight.bold,color: color.withOpacity(1)),),
             ),
             const Divider(),
             
            Wrap(children: [
                  TitleAndLabel(size: size, color: color, title: "Height",label: "${pokemon.height} Meter",),
                  TitleAndLabel(size: size, color: color, title: "Weight",label: "${pokemon.weight} Kg",),
                  TitleAndLabel(size: size, color: color, title: "Species",label: "${pokemon.species}",),
            ],), 
             const Divider(),

            LabelAndValues(label:  "Types",value:  pokemon.types ?? [],color:  color,size: size,),
            LabelAndValues(label:  "Ability",value:  pokemon.abilities?.map((e) => e.ability as String).toList() ?? [],color:  color,size: size),
            LabelAndValues(label: "Moves", color: color, value: pokemon.moves ?? [],size: size,),
           const Divider(),
           StatsView(pokemon: pokemon, color: color),
           const Divider(),
          if(aboutPokemon?.evolutionUrl != null) EvolutionView(evolutionUrl: aboutPokemon?.evolutionUrl ?? '',
          pokemon: pokemon,
          color: color,
          )
          
        ],),
      ),
    );
  }
}

class TitleAndLabel extends StatelessWidget {
  const TitleAndLabel({
    super.key,
    required this.size,
    required this.color,
    required this.label,
    required this.title
  });

  final Size size;
  final Color color;
  final String title;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
        child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
     children: [
           
      Text(title,style: AppTheme.textTheme(context).bodyMedium?.copyWith(fontWeight: FontWeight.bold),),
      const  SizedBox(height: 4,),
       Container(
          height: 45,
          
          width: size.width * 0.4,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
           border: Border.all(color: color.withOpacity(1))
          ),
          child: Text(label,style: AppTheme.textTheme(context).bodyLarge?.copyWith(fontWeight: FontWeight.bold),)),
         
      ],
        )
        );
  }
}

class LabelAndValues extends StatefulWidget {
  const LabelAndValues({
    super.key,
    required this.label,
    required this.color,
    required this.value,
    required this.size
  });
  final String label;
   final Size size;
  final Color color;
  final List<String> value;

  @override
  State<LabelAndValues> createState() => _LabelAndValuesState();
}

class _LabelAndValuesState extends State<LabelAndValues> {
  bool showMore = false;
  int limit = 6;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(15),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            
       Text(widget.label,style: AppTheme.textTheme(context).bodyLarge?.copyWith(fontWeight: FontWeight.bold),),
        Wrap(children: widget.value.take(limit).map((e) {
         return Container(
           
           width: widget.size.width * 0.27,
           alignment: Alignment.center,
           margin: const EdgeInsets.all(5),
           padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(1),
             color: widget.color.withOpacity(0.5)
           ),
           child: Text(e,style: AppTheme.textTheme(context).bodyMedium?.copyWith(fontWeight: FontWeight.bold),));
        }).toList(),),
        if(widget.value.length > 6) Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: (){
              if(showMore){
                showMore = false;
                limit = 6;
              setState(() {});

              }else{
                showMore = true;
                limit = widget.value.length;
              setState(() {});

              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(showMore? "View less" :'View more',style: AppTheme.textTheme(context).bodySmall?.copyWith(fontWeight: FontWeight.bold,color: widget.color.withOpacity(1)),),
            )),),
      ],
    )
    );
  }
}

