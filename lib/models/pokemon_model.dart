
class Pokemon {
  int? id;
  String? imageUrl;
  String? name;
  String? svgUrl;
  List<Ability>? abilities;
  List<String>? moves;
  List<String>? types;
  List<Stats>? stats;
  int? height;
  int? weight;
  
  String? species;
  About? about;

  Pokemon({required this.id, required this.imageUrl, required this.name, required this.svgUrl,
   this.abilities,
   this.height,
   this.moves,
   this.weight,
   this.types,
   this.stats,
   this.species,
   this.about});

  Pokemon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    height = json['height'];
    weight = json['weight'];
    species = json['species']?['name'];
    if(json['types'] != null){
    types = (json['types'] as List).map((move) {
      return move['type']['name'] as String;
    }).toList();
    }
    if(json['moves'] != null){
    moves = (json['moves'] as List).map((move) {
      return move['move']['name'] as String;
    }).toList();}

    if(json['abilities'] != null){
    abilities = (json['abilities'] as List).map((e) {
      return Ability.fromJson(e);
    }).toList();}
    imageUrl = json['sprites']?['front_default'];
    name = json['name'];

    if(json['stats'] != null){
    stats = (json['stats'] as List).map((e) {
      return Stats.fromJson({'name': e['stat']['name'],'value': e['base_stat']});
    }).toList();}
    svgUrl = json['sprites']?['other']?['dream_world']?['front_default'] ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['svgUrl'] = svgUrl;
    return data;
  }
}



class About {
  int? happiness;
  int? capturerate;
  String? flavourText;
  String? habitate;
  String? growthRate;
  String? evolutionUrl;

  About(
      {this.happiness,
      this.capturerate,
      this.flavourText,
      this.habitate,
      this.growthRate,
      this.evolutionUrl,
      });

  About.fromJson(Map<String, dynamic> json) {
    happiness = json['base_happiness'];
    capturerate = json['capture_rate'];
    flavourText = json['flavor_text_entries'][0]['flavor_text'].toString().replaceAll('\n', ' ');
    habitate = json['habitat']['name'];
    growthRate = json['growth_rate']['name'];
    evolutionUrl = json['evolution_chain']['url'];
   

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['happiness'] = happiness;
    data['capturerate'] = capturerate;
    data['flavourText'] = flavourText;
    data['habitate'] = habitate;
    data['growthRate'] = growthRate;
   
    return data;
  }
}


class Ability {
  String? ability;
  bool? isHidden;

  Ability({this.ability, this.isHidden});

  Ability.fromJson(Map<String, dynamic> json) {
    ability = json['ability']['name'];
    isHidden = json['is_hidden'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['ability'] = ability;
    data['is_hidden'] = isHidden;
    return data;
  }
}


class Stats {
  String? name;
  int? value;

  Stats({this.name, this.value});

  Stats.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['value'] = value;
    return data;
  }
}




class Evolution {
  final int stage;
  final String name;
  final String url;

  Evolution({required this.stage, required this.name, required this.url});

  factory Evolution.fromJson(Map<String, dynamic> json, int stage) {
    return Evolution(
      stage: stage,
      name: json['name'],
      url: json['url'],
    );
  }
}