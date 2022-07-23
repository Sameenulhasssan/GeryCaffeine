import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/views/BookOrder.dart';
import 'package:http/http.dart' as http;


Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("\n\n"+data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print("\n\n"+notification);
  }
  // Or do other work.
}


class FCMTesting extends StatefulWidget {
  @override
  _FCMTestingState createState() => _FCMTestingState();
}

class _FCMTestingState extends State<FCMTesting> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          sendAndRetrieveMessage();
        },
      ),
    );
  }


  final String serverToken = 'AAAAYImwfMA:APA91bHkCHkXf46hJ-09ctX2dKLTRf10dTmYBlgLvPnoHOYalCsPwNzg1xhIFefN4p-McHaMIXzWsTWDqBbSMckWUbhM_qT7JfVKYKGEDNdUBstVgJdoVOwYqnFhz3afwsszzryxK4kg';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    await firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings()
    );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'this is a body',
            'title': 'this is a title'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': await firebaseMessaging.getToken(),
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }

}
