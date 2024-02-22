import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/widgets/show_image.dart';


class FMCService {
  static FirebaseMessaging? _firebaseMessaging;
  static FirebaseMessaging get firebaseMessaging =>
      FMCService._firebaseMessaging ?? FirebaseMessaging.instance;

  static Future<void> initializeMessaging(context) async {
    FMCService._firebaseMessaging = FirebaseMessaging.instance;
    await onMessageOpenApp(context);
    await onMessage(context);
    await onBackgroundMsg();
  }

  
  static Future<void> onMessage(context) async {
    debugPrint('FCM onMessage called .....');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('FCM onMessage called again.....');

      var data = message.toMap();

      debugPrint('message data : $data');

      String title = data['notification']['title'];
      String body = data['notification']['body'];
      String image = data['notification']['android']['imageUrl'];
     
      showNotificationPopUp(context,title: title,body: body,image: image);
      });

  }

  
  static Future<void> backgroundHandler(RemoteMessage message) async {
    debugPrint(
        "FCM background message helper called ..... \nmessage : ${message.toMap()}");
  }

  static Future<void> onBackgroundMsg() async {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  }

  static Future<void> onMessageOpenApp(context) async {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      debugPrint("Firebase Service on Message open App called .....");
    });
  }
}




void showNotificationPopUp(context,{title,body,image}){
  showDialog(context: context, builder: (context) {
    return Dialog(
      
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(child: Text(title,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close))
              ],
            ),
            const SizedBox(height: 10,),
            Text(body,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            const SizedBox(height: 10,),
            
            ShowImage(imagelink: image,height: 150, width: double.infinity,)
          ],
        ),
      ),
    );
  },);
}

