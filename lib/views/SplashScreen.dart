import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/modals/AddedLocations.dart';
import 'package:food_delivery/modals/CartItems.dart';
import 'package:food_delivery/modals/Toppings.dart';
import 'package:food_delivery/views/DeliveryBoy/DeliveryBoyProfile.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'BookOrder.dart';
import 'HomeScreen.dart';
//import 'NewHome.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String token;
  bool isTokenAvailable = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("stepAA");
    Hive.registerAdapter(CartITemsAdapter());
    Hive.registerAdapter(ToppingsAdapter());
    Hive.registerAdapter(AddedLocationsAdapter());

    getToken();
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final String pagechooser = message['status'];
    print("\n\n" + pagechooser);
    Navigator.pushNamed(context, pagechooser);
  }

  getToken() async {
    print("step1");
    SharedPreferences.getInstance().then((pref) async {
      print("step2");
      isTokenAvailable = pref.getBool('tokenExist') ?? false;
      print("GETTING TOKEN : $isTokenAvailable");
      if (isTokenAvailable) {
        Timer(Duration(seconds: 3), () {
          SharedPreferences.getInstance().then((pref) {
            pref.getString('vehicle_no') == null
                ? Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  )
                : Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeliveryBoyProfile()),
                  );
          });
        });
      } else {
        print("step3");
        try {
          print("GETTING TOKEN : in try block");
          await FirebaseMessaging().getToken().then((value) {
            //Toast.show(value, context, duration: 2);
            print("step4");
            print("GETTING TOKEN : $value");
            setState(() {
              token = value;
            });
          });
        } catch (e) {
          print("GETTING TOKEN : ${e.toString()}");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }

        if (token != null) {
          final response = await post("$SERVER_ADDRESS/api/tokan_data", body: {
            'token': token,
            'type': 'Android',
          }).catchError((e) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          });
          try {
            final jsonResponse = jsonDecode(response.body);
            print(response.body);
            if (response.statusCode == 200 &&
                jsonResponse['data']['success'] == "1") {
              Timer(Duration(seconds: 1), () {
                SharedPreferences.getInstance().then((pref) {
                  pref.setBool('tokenExist', true);
                  pref.getString('vehicle_no') == null
                      ? Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        )
                      : Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeliveryBoyProfile()),
                        );
                });
              });
            } else {
              Toast.show("Network connection error", context, duration: 3);
            }
          } catch (e) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      }
    });
  }

  // void getMessages(){
  //   _firebaseMessaging.configure(
  //     onMessage: (msg) async{
  //       print('On Message : $msg');
  //       setState(() {
  //         //message = msg["notification"]['title'];
  //       });
  //     },
  //     onResume: (msg) async{
  //       print('On Resume : $msg');
  //       setState(() {
  //         //message = msg["notification"]['title'];
  //       });
  //     },
  //     onLaunch: (msg) async{
  //       print('On Launch : $msg');
  //       setState(() {
  //         //message = msg["notification"]['title'];
  //       });
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Image.asset(
              "assets/icons/splash_bg.png",
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          /*Center(
            child: Padding(
              padding: const EdgeInsets.all(60),
              child: Image.asset('assets/icons/splash_icon.png', fit: BoxFit.contain,),
            ),
          ),*/
        ],
      ),
    );
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print(notification);
  }
  // Or do other work.
}
