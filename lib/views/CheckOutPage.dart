import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/AllText.dart';
import 'package:food_delivery/jsonobjects/FoodDescription.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/modals/AddedLocations.dart';
import 'package:food_delivery/modals/CartItems.dart';
import 'package:food_delivery/views/AllLocations.dart';
import 'package:food_delivery/views/BookOrder.dart';
import 'package:food_delivery/views/ErrorWidget.dart';
import 'package:food_delivery/views/HomeScreen.dart';
import 'package:food_delivery/views/MyCardDetails.dart';
import 'package:food_delivery/views/OrderProgress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
//import 'package:stripe_payment/stripe_payment.dart';
import 'dart:convert' as convert;

import 'package:toast/toast.dart';

import '../AllText.dart';
import '../AllText.dart';

class CheckOutPage extends StatefulWidget {
  double price;
  List<CartITems> list;
  int deliveryCharges;
  CheckOutPage(this.price, this.list, this.deliveryCharges);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  bool isHomeDeliverySelected = false;
  bool isPickUpSelected = false;
  String name = "";
  String email = "";
  String phone = "";
  String address = "";
  String note = "";
  String userId = "";
  String langLat = "";
  String floorAddress = '';
  bool isNameError = false;
  bool isEmailError = false;
  bool isPhoneError = false;
  bool isAddressError = false;
  String food_desc = "";
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  FoodDescription foodDescription = FoodDescription.defaultc();
  CartITems cartITems = CartITems();
  AddedLocations addedLocations = AddedLocations();
  List<String> cities = List();
  String selectedCity = "";
  String order_id = "";
  String token = "";
  //Source _source;
  String stripeToken = "";
  String paymentId = "";
  bool isCashSelected = true; // Changed from false to true
  bool isStripeSelected = false;
  bool isPaypalSelected = false;
  bool isErrorInLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    getUserDetails();
    food_desc = foodDescription.jEncoder(widget.list);
    getCities();
    /*StripePayment.setOptions(StripeOptions(
        publishableKey: STRIPE_KEY,
        merchantId: STRIPE_MERCHANT_ID,
        androidPayMode: STRIPE_MERCHANT_ID));*/
  }

  Future<String> doPayment(
      {String clientId,
      String amount,
      bool callDoPayment,
      String currency}) async {
    String x;
    if (Platform.isAndroid) {
      var methodChannel = MethodChannel("paypal_payment");
      //String link =
      x = await methodChannel.invokeMethod("doPayment", {
        "clientId": clientId,
        "amount": amount,
        "callDoPayment": callDoPayment,
        "currency": currency,
      });
      print("X is ----------> $x");
      if (x != null) {
        proceed(x.split('"')[27]);
      }
    }
    return x;
  }

  getToken() async {
    await FirebaseMessaging().getToken().then((value) {
      //Toast.show(value, context, duration: 2);
      print(value);
      setState(() {
        token = value;
      });
    }).catchError((e) {
      messageDialog(ERROR, SOMETHING_WENT_WRONG, context);
    });
  }

  getCities() async {
    String url = "$SERVER_ADDRESS/api/getcity";
    final response = await http.get(url).catchError((e) {
      setState(() {
        isErrorInLoading = true;
      });
    });
    try {
      print(response.body);
      final jsonResponse = await convert.jsonDecode(response.body);
      for (int i = 0; i < jsonResponse['data']['city'].length; i++) {
        cities.add(jsonResponse['data']['city'][i]['city_name']);
      }
      setState(() {
        selectedCity = cities[0];
      });
      print(cities);
    } catch (e) {
      setState(() {
        isErrorInLoading = true;
      });
    }
  }

  /*showBottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context){
          return MyCardDetails();
        });
  }*/

  proceed(String tokenId) async {
    showdialog(true);
    String url = "$SERVER_ADDRESS/api/food_order";

    final response = isHomeDeliverySelected
        ? await http.post(url, body: {
            "user_id": userId,
            "name": name,
            "email": email,
            "payment_type": isCashSelected
                ? "Cash"
                : isStripeSelected
                    ? "Stripe"
                    : "Paypal",
            "pay_pal_paymentId": isPaypalSelected ? tokenId : "",
            "notes": note,
            "stripeToken": isStripeSelected ? tokenId : "",
            "food_desc": food_desc,
            "total_price": (widget.price + widget.deliveryCharges).toString(), //(widget.price + widget.deliveryCharges).toString(),
            "latlong": langLat.toString(),
            "token": token,
            "delivery_charges": "0",
            "delivery_mode": "0",
            "phone_no": phone,
            "address": address.toString(),
            "city": selectedCity,
            "subtotal": "1"
          }).catchError((e) {
            Navigator.pop(context);
            messageDialog(ERROR, SOMETHING_WENT_WRONG, context);
          })
        : await http.post(url, body: {
            "user_id": userId,
            "name": name,
            "email": email,
            "stripeToken": isStripeSelected ? tokenId : "",
            "payment_type": isCashSelected
                ? "Cash"
                : isStripeSelected
                    ? "Stripe"
                    : "Paypal",
            "pay_pal_paymentId": isPaypalSelected ? tokenId : "",
            "notes": note,
            "food_desc": food_desc,
            "total_price": widget.price.toString(),
            "latlong": "null",
            "token": token,
            "delivery_charges": "0",
            "delivery_mode": "1",
            "phone_no": phone,
            "pickup_order_time":
                "${DateTime.now().toUtc().add(Duration(hours: 3)).hour.toString()}:${DateTime.now().toUtc().add(Duration(hours: 3)).minute.toString()}",
            "city": selectedCity,
            "subtotal": widget.price.toString()
          }).catchError((e) {
            Navigator.pop(context);
            messageDialog(ERROR, SOMETHING_WENT_WRONG, context);
          });
    try {
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['success'] == "0") {
          Toast.show(jsonResponse["msg"].toString(), context, duration: 2);
          Navigator.pop(context);
        } else {
          //Toast.show("Order Placed Successfully", context,duration: 2);
          setState(() {
            order_id = jsonResponse['order_id'].toString();
          });
          await cartITems.deleteDatabase();
          Navigator.pop(context);
          showdialog(false);
        }
      }
    } catch (e) {
      Navigator.pop(context);
      messageDialog(ERROR, SOMETHING_WENT_WRONG, context);
    }
  }

  getUserDetails() async {
    await SharedPreferences.getInstance().then((pref) {
      setState(() {
        name = pref.getString("name");
        email = pref.getString("email");
        phone = pref.getString("phone");
        userId = pref.getString("userId");
        print(name);
        print(email);
        print(phone);
        controllerName.text = name;
        controllerEmail.text = email;
        controllerPhone.text = phone;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              isErrorInLoading
                  ? MyErrorWidget()
                  : Column(children: [
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/icons/checkout.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  child: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    size: 17,
                                    color: WHITE,
                                  ),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: RED, shape: BoxShape.circle),
                                ),
                              ),
                              InkWell(
                                child: Image.asset(
                                  "assets/icons/menu.png",
                                  width: 35,
                                  height: 25,
                                  color: RED,
                                  fit: BoxFit.contain,
                                ),
                                onTap: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: RED,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            /*Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  SUB_TOTAL,
                                                  style: TextStyle(
                                                      fontFamily: 'Bergen',
                                                      color: WHITE,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '${widget.price.toStringAsFixed(2)}$CURRENCY',
                                                  style: TextStyle(
                                                      fontFamily: 'Bergen',
                                                      color: WHITE,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),*/
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  DELIVERY_CHARGES,
                                                  style: TextStyle(
                                                      fontFamily: 'Bergen',
                                                      color: WHITE,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  isHomeDeliverySelected
                                                      ? '${widget.deliveryCharges.toStringAsFixed(2)} $CURRENCY'
                                                      : '$CURRENCY 0',
                                                  style: TextStyle(
                                                      fontFamily: 'Bergen',
                                                      color: WHITE,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  TOTAL_AMOUNT,
                                                  style: TextStyle(
                                                      fontFamily: 'Bergen',
                                                      color: WHITE,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                                Text(
                                                  isHomeDeliverySelected
                                                      ? '${(widget.price + widget.deliveryCharges).toStringAsFixed(2)} $CURRENCY'
                                                      : '${widget.price.toStringAsFixed(2)} $CURRENCY',
                                                  style: TextStyle(
                                                      fontFamily: 'Bergen',
                                                      color: WHITE,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      PERSONAL_DATA,
                                      style: TextStyle(
                                          fontFamily: 'Bergen',
                                          color: RED,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextField(
                                      controller: controllerName,
                                      decoration: InputDecoration(
                                        labelText: YOUR_NAME,
                                        labelStyle: TextStyle(
                                            fontFamily: 'Bergen',
                                            color: GREY,
                                            fontWeight: FontWeight.bold),
                                        border: UnderlineInputBorder(),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: GREY)),
                                        //errorText: isNameError ? "Enter your name" : null,
                                      ),
                                      style: TextStyle(
                                          fontFamily: 'Bergen',
                                          color: BLACK,
                                          fontWeight: FontWeight.bold),
                                      onChanged: (val) {
                                        // setState(() {
                                        //   name = val;
                                        //   isNameError = false;
                                        // });
                                      },
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    TextField(
                                      controller: controllerEmail,
                                      decoration: InputDecoration(
                                        labelText: 'E-mail',
                                        labelStyle: TextStyle(
                                            fontFamily: 'Bergen',
                                            color: GREY,
                                            fontWeight: FontWeight.bold),
                                        border: UnderlineInputBorder(),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: GREY)),
                                        //errorText: isNameError ? "Enter your name" : null,
                                      ),
                                      style: TextStyle(
                                          fontFamily: 'Bergen',
                                          color: BLACK,
                                          fontWeight: FontWeight.bold),
                                      onChanged: (val) {
                                        // setState(() {
                                        //   name = val;
                                        //   isNameError = false;
                                        // });
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextField(
                                      controller: controllerPhone,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        labelText: PHONE,
                                        labelStyle: TextStyle(
                                            fontFamily: 'Bergen',
                                            color: GREY,
                                            fontWeight: FontWeight.bold),
                                        border: UnderlineInputBorder(),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: GREY)),
                                        //errorText: isNameError ? "Enter your name" : null,
                                      ),
                                      style: TextStyle(
                                          fontFamily: 'Bergen',
                                          color: GREY,
                                          fontWeight: FontWeight.bold),
                                      onChanged: (val) {
                                        // setState(() {
                                        //   name = val;
                                        //   isNameError = false;
                                        // });
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DELIVERY_DETAILS,
                                          style: TextStyle(
                                              fontFamily: 'Bergen',
                                              color: RED,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isHomeDeliverySelected =
                                                        true;
                                                    isPickUpSelected = false;
                                                  });
                                                },
                                                child: Container(
                                                  height: 50,
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 10, 0),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        !isHomeDeliverySelected
                                                            ? OFFWHITE
                                                            : RED,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    border: Border.all(
                                                        color: GREY
                                                            .withOpacity(0.5),
                                                        width: 1),
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        /*SizedBox(
                                                      width: 15,
                                                    ),
                                                    Image.asset(
                                                      !isHomeDeliverySelected
                                                          ? OFFWHITE
                                                          : RED,
                                                      height: 15,
                                                      width: 15,
                                                      fit: BoxFit.contain,
                                                      color:
                                                          !isHomeDeliverySelected
                                                              ? BLACK
                                                              : DEEP_ORANGE_COLOR,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),*/
                                                        Text(
                                                          DELIVERY_TO_ADDRESS,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Bergen',
                                                              color:
                                                                  !isHomeDeliverySelected
                                                                      ? BLACK
                                                                      : WHITE,
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isHomeDeliverySelected =
                                                        false;
                                                    isPickUpSelected = true;
                                                  });
                                                },
                                                child: Container(
                                                  height: 50,
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 10, 0),
                                                  decoration: BoxDecoration(
                                                    color: !isPickUpSelected
                                                        ? OFFWHITE
                                                        : RED,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    border: Border.all(
                                                        color: GREY
                                                            .withOpacity(0.5),
                                                        width: 1),
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        /*SizedBox(
                                                      width: 15,
                                                    ),
                                                    Image.asset(
                                                      !isPickUpSelected
                                                          ? "assets/detailsPageIcons/radio.png"
                                                          : "assets/detailsPageIcons/radio_active.png",
                                                      height: 15,
                                                      width: 15,
                                                      fit: BoxFit.contain,
                                                      color: !isPickUpSelected
                                                          ? BLACK
                                                          : DEEP_ORANGE_COLOR,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),*/
                                                        Text(
                                                          PICKING_UP,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Bergen',
                                                              color:
                                                                  !isPickUpSelected
                                                                      ? BLACK
                                                                      : WHITE,
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Visibility(
                                          visible: isHomeDeliverySelected,
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton.icon(
                                                      onPressed: () async {
                                                        addedLocations =
                                                            await Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            AllLocations()));
                                                        print(addedLocations
                                                            .addressLine);
                                                        setState(() {
                                                          address =
                                                              addedLocations
                                                                  .addressLine;
                                                          langLat =
                                                              "${addedLocations.lat},${addedLocations.long}";
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.add,
                                                        size: 17,
                                                        color: BLACK,
                                                      ),
                                                      label: Text(
                                                        SELECT_ADDRESS,
                                                        style: TextStyle(
                                                          fontFamily: 'Bergen',
                                                          color: BLACK,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    addedLocations =
                                                        await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AllLocations()));
                                                    print(addedLocations
                                                        .addressLine);
                                                    setState(() {
                                                      address = addedLocations
                                                          .addressLine;
                                                      langLat =
                                                          "${addedLocations.lat},${addedLocations.long}";
                                                    });
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        address == ""
                                                            ? ENTER_ADDRESS
                                                            : address,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Bergen',
                                                            color: GREY,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Divider(
                                                        height: 25,
                                                        thickness: 1,
                                                        color: GREY,
                                                      ),
                                                      TextField(
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: STAGE,
                                                          labelStyle: TextStyle(
                                                              fontFamily:
                                                                  'Bergen',
                                                              color: GREY,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          border:
                                                              UnderlineInputBorder(),
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              GREY)),
                                                          //errorText: isNameError ? "Enter your name" : null,
                                                        ),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Bergen',
                                                            color: GREY,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            floorAddress = val;
                                                            //   isNameError = false;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      INSTRUCTIONS_FOR_THE_ORDER,
                                      style: TextStyle(
                                          fontFamily: 'Bergen',
                                          color: RED,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: COMMENT_ORDER_NOTE,
                                        labelStyle: TextStyle(
                                            fontFamily: 'Bergen',
                                            color: GREY,
                                            fontWeight: FontWeight.bold),
                                        border: UnderlineInputBorder(),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: GREY)),
                                        //errorText: isNameError ? "Enter your name" : null,
                                      ),
                                      style: TextStyle(
                                          fontFamily: 'Bergen',
                                          color: BLACK,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                      onChanged: (val) {
                                        setState(() {
                                          note = val;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      PAYMENT_METHOD,
                                      style: TextStyle(
                                          fontFamily: 'Bergen',
                                          color: RED,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              /*
                                          setState(() {
                                            isCashSelected = true;
                                            isStripeSelected = false;
                                            isPaypalSelected = false;
                                          });*/
                                            },
                                            child: Container(
                                              height: 50,
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 10, 0),
                                              decoration: BoxDecoration(
                                                color: !isCashSelected
                                                    ? OFFWHITE
                                                    : RED,
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                border: Border.all(
                                                    color:
                                                        GREY.withOpacity(0.5),
                                                    width: 1),
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      PAYMENT_CASH,
                                                      style: TextStyle(
                                                          fontFamily: 'Bergen',
                                                          color: !isCashSelected
                                                              ? BLACK
                                                              : WHITE,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        /*Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isCashSelected = false;
                                            isStripeSelected = true;
                                            isPaypalSelected = false;
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            border: Border.all(
                                                color: GREY.withOpacity(0.5),
                                                width: 1),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Image.asset(
                                                  !isStripeSelected
                                                      ? "assets/detailsPageIcons/radio.png"
                                                      : "assets/detailsPageIcons/radio_active.png",
                                                  height: 15,
                                                  width: 15,
                                                  fit: BoxFit.contain,
                                                  color: !isStripeSelected
                                                      ? BLACK
                                                      : DEEP_ORANGE_COLOR,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  STRIPE,
                                                  style: TextStyle(
                                                      fontFamily: 'Bergen',
                                                      color: BLACK,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),*/
                                        // Expanded(
                                        //   child: InkWell(
                                        //     onTap: (){
                                        //       setState(() {
                                        //         isPaypalSelected = true;
                                        //         isCashSelected = false;
                                        //         isStripeSelected =  false;
                                        //       });
                                        //     },
                                        //     child: Container(
                                        //       height: 50,
                                        //       margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        //       decoration: BoxDecoration(
                                        //         borderRadius: BorderRadius.circular(25),
                                        //         border: Border.all(color: GREY.withOpacity(0.5), width: 1),
                                        //       ),
                                        //       child: Center(
                                        //         child: Row(
                                        //           mainAxisAlignment: MainAxisAlignment.start,
                                        //           children: [
                                        //             SizedBox(width: 15,),
                                        //             Image.asset(
                                        //               !isPaypalSelected
                                        //                   ? "assets/detailsPageIcons/radio.png"
                                        //                   : "assets/detailsPageIcons/radio_active.png" ,height: 15, width: 15, fit: BoxFit.contain,),
                                        //             SizedBox(width: 5,),
                                        //             Text(
                                        //               PAYPAL,
                                        //               style:  TextStyle(
                                        //                   fontFamily: 'Bergen',
                                        //                   color: BLACK,
                                        //                   fontSize: 12
                                        //               ),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RaisedButton(
                                            elevation: 0,
                                            padding: EdgeInsets.all(12),
                                            onPressed: () async {
                                              if (isCashSelected) {
                                                setState(() {
                                                  address = address +
                                                      ' ' +
                                                      floorAddress;
                                                });
                                                proceed("");
                                              } else if (isStripeSelected) {
                                                /*String x = "";
                                x = await Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => MyCardDetails())
                                );
                                setState(() {
                                  stripeToken = x;
                                });
                                if (stripeToken != null) {
                                  Toast.show(PROCESSING, context);
                                  proceed(stripeToken);
                                }*/
                                              }
                                              // else if(isPaypalSelected){
                                              //   await doPayment(
                                              //       clientId: PAYPAL_CLIENT_ID,
                                              //       amount: widget.price.toString(),
                                              //       callDoPayment: true,
                                              //       currency: PAYPAL_PAYMENT_CURRENCY,
                                              //   );
                                              // }
                                              else {
                                                Toast.show(
                                                    PLEASE_SELECT_PAYMENT_METHOD,
                                                    context,
                                                    duration: 2);
                                              }
                                              //proceed();
                                              //Toast.show("${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}", context);
                                            },
                                            child: Text(ORDER_NOW,
                                                style: TextStyle(
                                                  fontFamily: 'Bergen',
                                                  color: WHITE,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                )),
                                            color: RED,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                45,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ])),
                        ),
                      ),
                    ]),
            ],
          )),
    );
  }

  showdialog(bool isProcessing) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () {},
            child: AlertDialog(
              title: Text(
                isProcessing ? PROCESSING : 'Done',
                style: TextStyle(
                  fontFamily: 'Bergen',
                  color: BLACK,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: isProcessing
                  ? Container(
                      height: 150,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          YOUR_ORDER_HAS_BEEN_PLACED_SUCCESSFULLY_WOULD_YOU_LIKE_CHECK_ORDER_PROGRESS,
                          style: TextStyle(
                            fontFamily: 'Bergen',
                            color: BLACK,
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
              actions: isProcessing
                  ? null
                  : [
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                        },
                        //color: Colors.deepOrange.shade100,
                        child: Text(
                          NO,
                          style: TextStyle(
                            fontFamily: 'Bergen',
                            color: THEME_COLOR,
                            //fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OrderProgress(order_id)));
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
            ),
          );
        });
  }
}
