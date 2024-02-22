import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon_model.dart';
import 'package:pokemon/services/pokemon_services.dart';
import 'package:pokemon/themes/app_theme.dart';
import 'package:pokemon/widgets/my_listtile.dart';
import 'package:pokemon/widgets/shimmer_container.dart';
import 'package:pokemon/widgets/show_image.dart';

class EvolutionView extends StatelessWidget {
  const EvolutionView({
    required this.evolutionUrl,
    required this.pokemon,
    required this.color,
    super.key});
  final String evolutionUrl;
  final Pokemon pokemon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
         children: [
           
           FutureBuilder(future: PokemonService().getPokemonEvolutionChain(evolutionUrl), 
           builder: (context, snapshot) {
            
            if(snapshot.data != null){
              var data = snapshot.data ?? [];
             return Column(
               children: [
                Text("Evolution",style: AppTheme.textTheme(context).headlineSmall?.copyWith(fontWeight: FontWeight.bold),),
           const  SizedBox(height: 15,),
                 ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  itemCount: data.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                   var item = data[index];
                   return EvolutionTIle(item: item, 
                   color: color, 
                   pokemon: pokemon,
                   showArrow:  index < (data.length -1),
                   );
                 },),
               ],
             );
             }else if(snapshot.connectionState == ConnectionState.waiting){
               return Column(
                 children: [
                  Text("Evolution",style: AppTheme.textTheme(context).headlineSmall?.copyWith(fontWeight: FontWeight.bold),),
           const  SizedBox(height: 15,),
                   ListView.builder(
                                 shrinkWrap: true,
                                 padding: const EdgeInsets.symmetric(vertical: 5),
                                 itemCount: 3,
                                 physics: const NeverScrollableScrollPhysics(),
                                 itemBuilder: (context, index) {
                                 
                   return EvolutionTileShimmer(showArrow: index < 2);
                                },),
                 ],
               );
             }else{
              return const SizedBox();
             }
           },)
         ],
      ),
    );
  }
}

class EvolutionTIle extends StatelessWidget {
  const EvolutionTIle({
    super.key,
    required this.item,
    required this.color,
    required this.pokemon,
     this.showArrow = false
  });

  final Map item;
  final Color color;
  final Pokemon pokemon;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyListTile(title: item['name']!,
            height: 100,
            borderRadius: BorderRadius.circular(10),
            margin: const  EdgeInsets.symmetric(horizontal: 15,vertical: 5),
            nullHeight: true,
            padding: EdgeInsets.zero,
            tileColor: color.withOpacity(0.2),
            leadingHeight: 100,
            leadingWidth: 100,
            leadingchild: Stack(children: [
              Container(),
              Container(
                margin: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                 decoration: BoxDecoration(
                    color:color.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
              ),
            
               Positioned(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    height: 100,
                    width: double.infinity,
                    child: ShowImage(
                         imagelink:  pokemon.svgUrl ?? pokemon.imageUrl ?? '',
                         boxFit: BoxFit.contain,
                         height: 70,
                         width: 70,
                    ),
                  ),
                ),
            ],
            
            ),
            titleStyle: const TextStyle(fontSize: 19,fontWeight: FontWeight.bold),
            subtitle: Text(item['flavor_text_entries'][0]['flavor_text'].toString().replaceAll('\n', ' ')),
            
           
            ),

         if(showArrow)  const Row(
          mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(Icons.arrow_downward_outlined,size: 30,),
             SizedBox(width: 15,),
             Icon(Icons.arrow_downward_outlined,size: 30,),
             SizedBox(width: 15,),
             Icon(Icons.arrow_downward_outlined,size: 30,),
           ],
         )
      ],
    );
  }
}

class EvolutionTileShimmer extends StatelessWidget {
  const EvolutionTileShimmer({
    required this.showArrow,
    super.key});
  final bool showArrow;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyListTile(title: 'null/',
            height: 100,
            borderRadius: BorderRadius.circular(10),
            margin: const  EdgeInsets.symmetric(horizontal: 15,vertical: 5),
            nullHeight: true,
            padding: EdgeInsets.zero,
            tileColor: AppTheme.primaryColor(context).withOpacity(0.3),
            leadingHeight: 100,
            leadingWidth: 100,
            leadingchild: const  ShimmerContainer(height: 90, width: 90),
            subtitle: const ShimmerContainer(height: 20, width: 100)
            ),

         if(showArrow)  const Row(
          mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(Icons.arrow_downward_outlined,size: 30,),
             SizedBox(width: 15,),
             Icon(Icons.arrow_downward_outlined,size: 30,),
             SizedBox(width: 15,),
             Icon(Icons.arrow_downward_outlined,size: 30,),
           ],
         )
      ],
    );
  }
}