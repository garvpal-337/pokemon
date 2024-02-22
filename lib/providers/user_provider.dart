import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pokemon/services/pokemon_services.dart';
import 'package:pokemon/widgets/widget_components.dart';
import 'package:uuid/uuid.dart';


class UserProv extends ChangeNotifier{
  
  String currentUserId = "";

  List<int> _myPokemonId = [];
  List<int> get myPokemonId {
    return [..._myPokemonId];
  }

  List<Pokemon> _myPokemons = [];
  List<Pokemon> get myPokemons {
    return [..._myPokemons];
  }


  // to add and remove pokemons from my collection
  // it will only add and remove id or pokemon from firebase 
  Future<void> addAndRemoveToMyPokemons(context,
      {required Pokemon pokemon, required bool addPokemon}) async {
    if (addPokemon) {
      _myPokemonId.insert(0, pokemon.id!);
      _myPokemons.insert(0, pokemon);
      mySnackBar(context, '${pokemon.name} captured...');
    } else {
      _myPokemonId.remove(pokemon.id!);
      _myPokemons.removeWhere((element) => element.id == pokemon.id);
      mySnackBar(context, '${pokemon.name} released...');

    }
    notifyListeners();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('pokemons')
        .doc('ids')
        .set({'ids': _myPokemonId});
  }
 

 // to get pokemons from my collection..
 // if getPokemonsToo is false then it will fetch the id of the pokemon in my collection
 // it will help to manage whether the pokemon is captured or not..
 // if getPokemonsToo is true then it will also fetch the pokemon details ..
 bool getMyPokemonLoading = true;
  Future<void> getmyPokemonsIds({bool getPokemonsToo = false}) async {
   

    List<int> pokeData = [];
    try{

    getMyPokemonLoadingToggle(true);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('pokemons')
        .doc('ids')
        .get()
        .then((value) {
      if (value.exists) {
        List ids = value.data()!['ids'];
       
        for (var item in ids) {
          pokeData.add(item);
        }
        _myPokemonId = pokeData;
        notifyListeners();
      }
    });
    if(getPokemonsToo){
    final myPokemonData = await Future.wait(_myPokemonId.map((e) {
      return  PokemonService().searchPokemonByNameOrId(e.toString());
    }).toList());
    _myPokemons = myPokemonData;
    }
    getMyPokemonLoadingToggle(false);
    notifyListeners();
    }catch (e){
    getMyPokemonLoadingToggle(false);

      debugPrint('error found while getting getmyPokemons()\nerror : $e');
      rethrow;
    }
  }
  
// getting user details for checking that current device token is available or not
Future<void> getuserDetails() async {
    final docRef = FirebaseFirestore.instance.collection("users").doc(currentUserId);
    await docRef.get().then(
      (DocumentSnapshot doc) {
        if(doc.exists){
         var data  = doc.data()! as Map;
        
         uploadDeviceToken(availbleTokens:  data['deviceTokens']);
        }
      },
      onError: (e) => debugPrint("Error getting document: $e"),
    );
  }


// to upload divice token for notification..
  Future<void> uploadDeviceToken({List? availbleTokens}) async {
    availbleTokens ??= [];
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();
      
      debugPrint('Added Tokens : ${availbleTokens.toList()}');
      debugPrint('Device Token: $token');

      // if current device token is not available in data base then it will add that....
      if (!availbleTokens.contains(token)) {
        availbleTokens.add(token);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .set({'deviceTokens': availbleTokens}, SetOptions(merge: true));
      }
    }
  }
  // initialinzing user when user first time opens app
  // it will store uid in EncryptedSharedPreferences so that we can get data from uid later
  Future<void> initializeUser() async {
    final prefs =  EncryptedSharedPreferences();
    String uid = await prefs.getString('uid');
   
    if(uid.isEmpty){
      uid = const Uuid().v4();
      currentUserId = uid;
      notifyListeners();
      await prefs.setString('uid', uid); 
      await uploadDeviceToken();
    }else{
      currentUserId = uid;
      notifyListeners();
    }
  }
  
  // it will return true if _myPokemon id contains this pokemon id...
  bool isSelected(int pokemonId){
    return _myPokemonId.contains(pokemonId);
  }
  
  // to change the loading status so that we can manage ui according to this
  getMyPokemonLoadingToggle(bool value){
    getMyPokemonLoading = value;
    notifyListeners();
  }
}