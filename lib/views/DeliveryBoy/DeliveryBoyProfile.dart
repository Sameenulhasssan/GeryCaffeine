import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/AllText.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/views/DeliveryBoy/DeliveryBoyOrderDetails.dart';
import 'package:food_delivery/views/DeliveryBoy/DeliveryBoyOrderHistory.dart';
import 'package:food_delivery/views/DeliveryBoy/DeliveryBoyOrders.dart';
import 'package:food_delivery/views/DeliveryBoy/Profile.dart';
import 'package:food_delivery/views/ErrorWidget.dart';
import 'package:food_delivery/views/HomeScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../TestFirebaseNotification.dart';
import '../../notificationHelper.dart';
import '../OrderProgress.dart';

class DeliveryBoyProfile extends StatefulWidget {
  @override
  _DeliveryBoyProfileState createState() => _DeliveryBoyProfileState();
}

class _DeliveryBoyProfileState extends State<DeliveryBoyProfile> {
  String id = "";
  String name = "";
  bool isPresent = false;
  bool isLoading = false;
  DeliveryBoyOrders deliveryBoyOrders;
  bool loadingOrders = true;
  bool isErrorInLoading = false;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  NotificationHelper notificationHelper = NotificationHelper();

  Future<void> getDeliveryBoyProfile() async {
    setState(() {
      loadingOrders = true;
    });
    await SharedPreferences.getInstance().then((pref) {
      setState(() {
        id = pref.getString("userId");
      });
    });
    final response =
        await get("$SERVER_ADDRESS/api/deliveryboy_profile?deliverboy_id=$id")
            .catchError((e) {
      setState(() {
        isErrorInLoading = true;
      });
    });
    try {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      setState(() {
        name = jsonResponse['order']['name'];
      });
      assignedOrders();
    } catch (e) {
      setState(() {
        isErrorInLoading = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeliveryBoyProfile();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        isPresent = value.getBool('isPresent') ?? false;
      });
    });

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: ${message}");
        print("\n\n" + message.toString());
        notificationHelper.showNotification(
            title: message['notification']['title'],
            body: message['notification']['body'],
            payload:
                "${message['data']['type']}:${message['data']['order_id']}",
            id: "124",
            context2: context);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        print("\n\n" + message.toString());
        if (message['data']['type'] == "user_id") {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderProgress(message['data']['order_id'].toString())),
          );
        } else if (message['data']['type'] == "delivery_boyid") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DeliveryBoyOrderDetails(
                    message['data']['order_id'].toString())),
          );
        }
        notificationHelper.cancel();
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        print("\n\n" + message['data'].toString());
        if (message['data']['type'] == "user_id") {
          notificationHelper.initialize();
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderProgress(message['data']['order_id'].toString())),
          );
        } else if (message['data']['type'] == "delivery_boyid") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DeliveryBoyOrderDetails(
                    message['data']['order_id'].toString())),
          );
        }
        notificationHelper.cancel();
      },
    );
  }

  setPresence(String s) async {
    setState(() {
      isLoading = true;
    });
    final response =
        await post("$SERVER_ADDRESS/api/deliveryboy_presence", body: {
      'status': s,
      'deliverboy_id': id,
    }).catchError((e) {
      setState(() {
        isErrorInLoading = true;
      });
    });
    try {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['data']['presence'] == 'Yes') {
        setState(() {
          isPresent = true;
        });
      } else {
        setState(() {
          isPresent = false;
        });
      }
      setState(() {
        isLoading = false;
      });
      SharedPreferences.getInstance().then((value) {
        value.setBool('isPresent', isPresent);
      });
    } catch (e) {
      setState(() {
        isErrorInLoading = true;
      });
    }
  }

  assignedOrders() async {
    setState(() {
      loadingOrders = true;
    });
    final response =
        await get("$SERVER_ADDRESS/api/deliveryboy_order?deliverboy_id=$id")
            .catchError((e) {
      setState(() {
        isErrorInLoading = true;
      });
    });
    try {
      final jsonResponse = await jsonDecode(response.body);
      if (jsonResponse["success"] == "0") {
        setState(() {
          loadingOrders = false;
          print(deliveryBoyOrders);
        });
      } else {
        //deliveryBoyOrders = DeliveryBoyOrders(success: jsonResponse['success'],order: jsonResponse['order']);
        print(jsonResponse);
        setState(() {
          deliveryBoyOrders = DeliveryBoyOrders.fromJson(jsonResponse);
          loadingOrders = false;
        });
      }
    } catch (e) {
      setState(() {
        isErrorInLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            loadingOrders
                ? isErrorInLoading
                    ? MyErrorWidget()
                    : Container(
                        child: Padding(
                          padding: const EdgeInsets.all(80),
                          child: Center(
                              child: FlareActor(
                            "assets/Flare/loading.flr",
                            fit: BoxFit.contain,
                            animation: "loading",
                          )),
                        ),
                      )
                : LiquidPullToRefresh(
                    onRefresh: getDeliveryBoyProfile,
                    animSpeedFactor: 20,
                    child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 70,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: LIGHT_GREY,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              23),
                                                      color: LIGHT_GREY),
                                                  child: Icon(
                                                    Icons.account_circle,
                                                    size: 40,
                                                    color: THEME_COLOR,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      name,
                                                      style: TextStyle(
                                                        fontFamily: 'Bergen',
                                                        color: BLACK,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text(
                                                      DELIVERY_BOY,
                                                      style: TextStyle(
                                                        fontFamily: 'Bergen',
                                                        color: GREY,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          showdialog2();
                                                        },
                                                        child: Image.asset(
                                                          'assets/deliveryBoyIcons/logout.png',
                                                          height: 45,
                                                          width: 45,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  SET_YOUR_PRESENCE,
                                                  style: TextStyle(
                                                      fontFamily: 'Bergen',
                                                      color: BLACK,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 13),
                                                ),
                                                isLoading
                                                    ? Container(
                                                        height: 25,
                                                        width: 25,
                                                        child: Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                          strokeWidth: 3,
                                                        )))
                                                    : Container(
                                                        height: 25,
                                                        width: 90,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          border: Border.all(
                                                              color: GREY
                                                                  .withOpacity(
                                                                      0.5),
                                                              width: 0.5),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    setPresence(
                                                                        YES);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: isPresent
                                                                          ? THEME_COLOR
                                                                          : Colors
                                                                              .transparent,
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/deliveryBoyIcons/currect.png',
                                                                        height:
                                                                            10,
                                                                        width:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    setPresence(
                                                                        NO);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: !isPresent
                                                                          ? THEME_COLOR
                                                                          : Colors
                                                                              .transparent,
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/deliveryBoyIcons/cross.png',
                                                                        height:
                                                                            10,
                                                                        width:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      deliveryBoyOrders == null
                                          ? Container(
                                              margin: EdgeInsets.all(50),
                                              child: Center(
                                                child: Text(
                                                  YOU_HAVE_NO_ORDERS_TODAY,
                                                  style: TextStyle(
                                                    fontFamily: 'Bergen',
                                                    color: GREY,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : ListView.builder(
                                              itemCount: deliveryBoyOrders
                                                  .order.length,
                                              shrinkWrap: true,
                                              physics: ClampingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DeliveryBoyOrderDetails(
                                                                    deliveryBoyOrders
                                                                        .order[
                                                                            index]
                                                                        .orderNo
                                                                        .toString())));
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 20, 0, 0),
                                                    decoration: BoxDecoration(
                                                      color: LIGHT_GREY,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    padding: EdgeInsets.all(20),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "$ORDER_NUMBER: " +
                                                                  deliveryBoyOrders
                                                                      .order[
                                                                          index]
                                                                      .orderNo
                                                                      .toString(),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Bergen',
                                                                color: BLACK,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                              ),
                                                            ),
                                                            Text(
                                                              deliveryBoyOrders
                                                                  .order[index]
                                                                  .date
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Bergen',
                                                                color: GREY,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "$CURRENCY${deliveryBoyOrders.order[index].totalAmount}",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Bergen',
                                                                  color: BLACK,
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Container(
                                                              height: 25,
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              13),
                                                                  border: Border.all(
                                                                      color:
                                                                          GREY,
                                                                      width:
                                                                          0.5)),
                                                              child: Center(
                                                                child: Text(
                                                                  deliveryBoyOrders
                                                                      .order[
                                                                          index]
                                                                      .status
                                                                      .substring(
                                                                          9),
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Bergen',
                                                                      color:
                                                                          GREY,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                          deliveryBoyOrders
                                                              .order[index]
                                                              .address,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Bergen',
                                                            color: GREY,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                      SizedBox(
                                        height: 70,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: WHITE,
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.arrow_back_ios_rounded,
                                        size: 17,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      DELIVERY_BOY,
                                      style: TextStyle(
                                          fontFamily: 'Bergen',
                                          color: BLACK,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: WHITE,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            color: THEME_COLOR,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DeliveryBoyOrderHistory()),
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              ORDER_HISTORY,
                              style: TextStyle(
                                  fontFamily: 'Bergen',
                                  color: BLACK,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: FlatButton(
                            color: THEME_COLOR,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Profile()));
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              MY_PROFILE,
                              style: TextStyle(
                                  fontFamily: 'Bergen',
                                  color: BLACK,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  showdialog2() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              LOG_OUT,
              style: TextStyle(
                fontFamily: 'Bergen',
                color: BLACK,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  ARE_YOU_SURE_TO_LOGOUT,
                  style: TextStyle(
                    fontFamily: 'Bergen',
                    color: BLACK,
                    fontSize: 15,
                  ),
                )
              ],
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  NO,
                  style: TextStyle(
                    fontFamily: 'Bergen',
                    color: THEME_COLOR,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  await SharedPreferences.getInstance().then((pref) {
                    pref.setBool("isLoggedIn", false);
                    pref.setString("userId", null);
                    pref.setString("name", null);
                    pref.setString("phone", null);
                    pref.setString("email", null);
                    pref.setString("vehicle_no", null);
                  });
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  // Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                color: THEME_COLOR,
                child: Text(
                  YES,
                  style: TextStyle(
                    fontFamily: 'Bergen',
                    color: BLACK,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
