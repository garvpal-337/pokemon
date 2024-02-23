
import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon_model.dart';
import 'package:pokemon/themes/app_theme.dart';

class StatsView extends StatelessWidget {
  const StatsView({
    required this.pokemon,
    required this.color,
    super.key});
  final Pokemon pokemon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
        child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
     children: [
           
      Text("Stats",style: AppTheme.textTheme(context).headlineSmall?.copyWith(fontWeight: FontWeight.bold),),
      const  SizedBox(height: 20,),
      ...pokemon.stats!.map((stat) {
        return SizedBox(
          height: 30,
          child: Row(children: [
          Expanded(
            flex: 2,
            child: Text(stat.name.toString().toUpperCase(),style: AppTheme.textTheme(context).bodyMedium?.copyWith(fontWeight: FontWeight.bold),)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(stat.value.toString(),style: AppTheme.textTheme(context).bodyMedium?.copyWith(fontWeight: FontWeight.bold),)),  
          Expanded(
            flex: 3,
            child: Container(
              width: 150,
              height: 10,
              color: Colors.grey,
              alignment: Alignment.bottomLeft,
              child: FractionallySizedBox(
                
                widthFactor: stat.value!/100,
                child: Container(color: color.withOpacity(1),),
              )),
          )
        ],),);
      }).toList()
      ],
        )
        );
  }
}

