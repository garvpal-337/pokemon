
import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon_model.dart';
import 'package:pokemon/providers/theme_provider.dart';
import 'package:pokemon/providers/user_provider.dart';
import 'package:pokemon/screens/pokemon/pokemon_details_screen.dart';
import 'package:pokemon/themes/app_theme.dart';
import 'package:pokemon/themes/themes.dart';
import 'package:pokemon/utils/color_generator.dart';
import 'package:pokemon/widgets/capture_release_button.dart';
import 'package:pokemon/widgets/my_listtile.dart';
import 'package:pokemon/widgets/shimmer_container.dart';
import 'package:pokemon/widgets/show_image.dart';
import 'package:provider/provider.dart';
class PokemonCard extends StatefulWidget {
  const PokemonCard({
    Key? key,
    required this.item,
    required this.index,
    required this.gridCount
  }) : super(key: key);

  final Pokemon item;
  final int index;
  final int gridCount;

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  Color? color;

  void generateColorPlatter(context) async {
    final themeProv = Provider.of<ThemeProvider>(context, listen: false);
    bool isdark = themeProv.themeData == darkTheme;
    await ColorsGenerator().generateCardColor(widget.item.imageUrl ?? '', isdark).then((value) {
      if(mounted){
      setState(() {
        color = value;
      });}
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
    generateColorPlatter(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProv>(context);
    bool isSelected = userProv.isSelected(widget.item.id!);

    return LayoutBuilder(
      builder: (context, constraints) {
        if(widget.gridCount == 1){
          return PokemonListTile(widget: widget, color: color,constraints: constraints,);
        }
        return GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, PokemonDetailsScreen.route,
            arguments: {'pokemon': widget.item,'color':color}
            );
          },
          onDoubleTap: (){
            Provider.of<UserProv>(context,listen: false).addAndRemoveToMyPokemons(context,pokemon: widget.item, addPokemon: true);
          },
          child: Stack(
            children: [
              Container(),
              Container(
                margin: widget.gridCount  == 3? const EdgeInsets.fromLTRB(15, 20, 15, 0) :const EdgeInsets.fromLTRB(20, 28, 20, 0),
                width: double.infinity,
                height: constraints.maxHeight, // Adjust height based on constraints
                decoration: BoxDecoration(
                  color: color ?? AppTheme.primaryColor(context).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Container(height: constraints.maxHeight * 0.53),
                    Text(
                      widget.item.name ?? '',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style:  TextStyle(fontSize:widget.gridCount == 3? 13 :17, fontWeight: FontWeight.bold, color: Colors.white,
                      shadows: const [Shadow(color: Colors.black,blurRadius: 10)]),
                    ),
                   
                  ],
                ),
              ),
              Positioned(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  height: constraints.maxHeight * 0.6,
                  width: double.infinity,
                  child: Hero(
                    tag: widget.index,
                    child: ShowImage(
                      imagelink: widget.item.svgUrl ?? widget.item.imageUrl,
                      boxFit: BoxFit.contain,
                      height: constraints.maxHeight * 0.7,
                      width: constraints.maxHeight * 0.7,
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 5,
                left: 25,
                child:  CaptureReleaseButton(
                  initialValue: isSelected,
                  maxSize: widget.gridCount == 3 ? 15 : 20,
                  onClick: (){
                    if(isSelected){
                      userProv.addAndRemoveToMyPokemons(context,pokemon: widget.item, addPokemon: false);
                    }else{
                      userProv.addAndRemoveToMyPokemons(context,pokemon: widget.item, addPokemon: true);

                    }
                  },
                  value: (value) {
                  
                },)),
               
            ],
          ),
        );
      },
    );
  }
}

class PokemonListTile extends StatelessWidget {
  const PokemonListTile({
    super.key,
    required this.widget,
    required this.color,
    required this.constraints,
   
  });

  final PokemonCard widget;
  final Color? color;
  final BoxConstraints constraints;
  
  

  @override
  Widget build(BuildContext context) {
     final userProv = Provider.of<UserProv>(context);
    bool isSelected = userProv.isSelected(widget.item.id!);
    return MyListTile(title: widget.item.name!,
    height: constraints.maxHeight * 0.9,
    borderRadius: BorderRadius.circular(10),
    margin: const  EdgeInsets.symmetric(horizontal: 15,vertical: 5),
    // nullHeight: true,
    padding: EdgeInsets.zero,
    tileColor: color ?? AppTheme.primaryColor(context).withOpacity(0.2),
    leadingHeight: constraints.maxHeight * 0.9,
    leadingWidth: constraints.maxHeight *0.9,
    leadingchild: Stack(children: [
      Container(),
      Container(
        margin: const EdgeInsets.fromLTRB(8, 10, 8, 0),
         decoration: BoxDecoration(
            color: color?.withOpacity(0.9) ?? AppTheme.primaryColor(context).withOpacity(0.2),
            borderRadius: BorderRadius.circular(5),
          ),
      ),
    
       Positioned(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: constraints.maxHeight * 0.8,
            width: double.infinity,
            child: Hero(
              tag: widget.index,
              child: ShowImage(
                imagelink: widget.item.svgUrl ?? widget.item.imageUrl,
                boxFit: BoxFit.contain,
                height: constraints.maxHeight * 0.9,
                width: constraints.maxHeight * 0.9,
              ),
            ),
          ),
        ),
    ],
    
    ),
    titleStyle: const TextStyle(fontSize: 19,fontWeight: FontWeight.bold),
    subtitle:  Text("Height : ${ widget.item.height}  | Weight : ${widget.item.weight}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
    subtitle2: widget.item.types == null ? null: Text("Types : ${ widget.item.types!.join(',')}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
    trailing: Padding(
      padding: const EdgeInsets.all(8.0),
      child: CaptureReleaseButton(
                    initialValue: isSelected,
                    onClick: (){
                      if(isSelected){
                        userProv.addAndRemoveToMyPokemons(context,pokemon: widget.item, addPokemon: false);
                      }else{
                        userProv.addAndRemoveToMyPokemons(context,pokemon: widget.item, addPokemon: true);
      
                      }
                    },
                    value: (value) {
                    
                  },),
    ),
    onTap: (){
      Navigator.pushNamed(context, PokemonDetailsScreen.route,
      arguments: {'pokemon': widget.item,'color':color}
      );
    },
    );
  }
}


class PokemonCardShimmer extends StatelessWidget {
  const PokemonCardShimmer({
    super.key,
   required this.gridCount
  });

  final int gridCount;
  @override
  Widget build(BuildContext context) {
    if(gridCount == 1){
     return const PokemonListTileShimmer();
    }
    return Stack(
      children: [
        Container(),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 28, 20, 0),
          width: double.infinity,
         
          child:  ShimmerContainer(height: double.infinity, width: double.infinity,borderRadius: BorderRadius.circular(5),
           alignment: Alignment.bottomCenter,
          child: const Padding(
            padding:  EdgeInsets.all(8.0),
            child:  ShimmerContainer(height: 20, width: 100),
          ),
          )
        ),  
      ],
    );
  }
}

class PokemonListTileShimmer extends StatelessWidget {
  const PokemonListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints)  {
        return MyListTile(title: 'null/',
        height: constraints.maxHeight * 0.9,
        borderRadius: BorderRadius.circular(10),
        margin: const  EdgeInsets.symmetric(horizontal: 15,vertical: 5),
        tileColor: AppTheme.primaryColor(context).withOpacity(0.2),
        padding: EdgeInsets.zero,
       
        leadingHeight: constraints.maxHeight * 0.9,
        leadingWidth: constraints.maxHeight *0.9,
        leadingchild: ShimmerContainer( height: constraints.maxHeight * 0.9,
                    width: constraints.maxHeight * 0.9,),
        
        subtitle: const ShimmerContainer(height: 15, width: 100),
        subtitle2:  const ShimmerContainer(height: 15, width: 100),
        trailing: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ShimmerContainer(height: 25, width: 25,borderRadius: BorderRadius.circular(20),),
        ),
       
        );
      }
    );
  }
}