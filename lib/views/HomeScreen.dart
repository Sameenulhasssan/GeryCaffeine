import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/modals/CartItems.dart';
import 'package:food_delivery/modals/Categories.dart';
import 'package:food_delivery/modals/SelectedCategory.dart';
import 'package:food_delivery/modals/Toppings.dart';
import 'package:food_delivery/notificationHelper.dart';
import 'package:food_delivery/views/CartPage.dart';
import 'package:food_delivery/views/DetailsPage.dart';
import 'package:food_delivery/views/OrderProgress.dart';
import 'package:food_delivery/views/SideMenu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../AllText.dart';
import 'BookOrder.dart';
import 'DeliveryBoy/DeliveryBoyOrderDetails.dart';
import 'ErrorWidget.dart';
import 'SplashScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int selectedItemIndex = 0;
  List<bool> isSelected = List<bool>();
  AnimationController controller;
  Animation<Offset> slideAnimation;
  bool isDrawerOpen = false;
  List<Categories> categories = List<Categories>();
  List<SubCategory> selectedCat = List<SubCategory>();
  List<SubCategory> carousalCat = List<SubCategory>();
  bool isCategoryLoaded = false;
  bool isSelectedCategoryLoaded = false;
  bool isCarousalFetchDone = false;
  int categoryLength = 0;
  CartITems cartITems = CartITems();
  int totalCartItems = 0;
  String cartImage1 = "";
  String cartImage2 = "";
  String cartImage3 = "";
  String deliveryCharges = "0";
  String categorySelectedName = "";
  NotificationHelper notificationHelper = NotificationHelper();
  List<Future> categoriesImage = List();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  bool isErrorInLoading = false;
  final CarouselController _controller = CarouselController();
  List<Widget> imageSliders;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    //slideAnimation = Tween<Offset>(begin: Offset(100,100), end: Offset(0,0)).animate(controller);

    fetchCategory();

    readCart();
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

    //getMessages();
  }

  // void getMessages(){
  //   FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  //   NotificationHelper notificationHelper;
  //   _firebaseMessaging.configure(
  //     onMessage: (msg) async{
  //       print('On Message : $msg');
  //       setState(() {
  //         //message = msg["notification"]['title'];
  //         final jsonResponse  = convert.jsonDecode(msg.toString());
  //         print(jsonResponse);
  //         notificationHelper = NotificationHelper(msg["notification"]['title'], msg["notification"]['body'], msg['data']['status'], "Food Explorer");
  //         notificationHelper.initialize();
  //       });
  //     },
  //     onResume: (msg) async{
  //       print('On Resume : $msg');
  //       setState(() {
  //         notificationHelper = NotificationHelper(msg["notification"]['title'], msg["notification"]['body'], msg['data']['status'], "Food Explorer");
  //         notificationHelper.initialize();
  //         //message = msg["notification"]['title'];
  //       });
  //     },
  //     onLaunch: (msg) async{
  //       print('On Launch : $msg');
  //       setState(() {
  //         notificationHelper = NotificationHelper(msg["notification"]['title'], msg["notification"]['body'], msg['data']['status'], "Food Explorer");
  //         notificationHelper.initialize();
  //         //message = msg["notification"]['title'];
  //       });
  //     },
  //   );
  //
  //   print(_firebaseMessaging.toString());
  //
  // }

  readCart() async {
    List<CartITems> list = List();
    await cartITems.readingCart().then((value) {
      setState(() {
        cartImage1 = "";
        cartImage2 = "";
        cartImage3 = "";
        list.addAll(value);
        totalCartItems = list.length;
        if (list.length != 0) {
          cartImage1 = list.length > 0 ? list[0].image : "";
          cartImage2 = list.length > 1 ? list[1].image : "";
          cartImage3 = list.length > 2 ? list[2].image : "";
          //cartImage2 = list[1].image;
        }
      });
    });
  }

  fetchCategory() async {
    String url = "$SERVER_ADDRESS/api/menu_category";
    var response = await http.get(url).catchError((e) {
      setState(() {
        isErrorInLoading = true;
      });
    });
    try {
      if (response.statusCode == 200) {
        if (response.body != null) {
          var jsonResponse = convert.jsonDecode(response.body);
          setState(() {
            categoryLength = jsonResponse['menu_category'].length;
            print(jsonResponse['menu_category'].length);
          });
          for (int i = 0; i < jsonResponse['menu_category'].length; i++) {
            categories.add(Categories(
                jsonResponse['menu_category'][i]['id'],
                jsonResponse['menu_category'][i]['cat_icon'],
                jsonResponse['menu_category'][i]['cat_name']));
            if (i == 0) {
              setState(() {
                categorySelectedName =
                    jsonResponse['menu_category'][i]['cat_name'];
              });
            }
          }
          sliderListFiller();
          print(jsonResponse);
          categorySelected(categories[0].id);
          setState(() {
            isCategoryLoaded = true;
            deliveryCharges = '0';
            STRIPE_KEY = jsonResponse['stripe_key'];
          });
        }
        makeListEmpty();
      }
    } catch (e) {
      setState(() {
        isErrorInLoading = true;
      });
    }
  }

  sliderListFiller() async {
    print('length of categories');
    print(categories.length);
    for (int i = 0; i < categories.length; i++) {
      int a = categories[i].id;
      String url = "$SERVER_ADDRESS/api/subcategory?category=$a";
      var response = await http.get(url).catchError((e) {
        setState(() {
          isErrorInLoading = true;
        });
      });
      try {
        var jsonResponse = convert.jsonDecode(response.body);
        if (response.statusCode == 200 && jsonResponse["success"] == "1") {
          if (response.body != null) {
            print('abcd');
            for (int i = 0;
                (i < 3) && (i < jsonResponse['subcategory'].length);
                i++) {
              int j = Random().nextInt(jsonResponse['subcategory'].length);
              print('j');
              print(j);
              carousalCat.add(SubCategory(
                jsonResponse['subcategory'][j]['id'],
                jsonResponse['subcategory'][j]['category'],
                jsonResponse['subcategory'][j]['menu_image'],
                jsonResponse['subcategory'][j]['menu_name'],
                jsonResponse['subcategory'][j]['price'],
                jsonResponse['subcategory'][j]['description'],
              ));
              print(
                jsonResponse['subcategory'][i]['menu_name'],
              );
            }
            /*for (int i = 0; i < jsonResponse['subcategory'].length; i++) {
              carousalCat.add(SubCategory(
                jsonResponse['subcategory'][i]['id'],
                jsonResponse['subcategory'][i]['category'],
                jsonResponse['subcategory'][i]['menu_image'],
                jsonResponse['subcategory'][i]['menu_name'],
                jsonResponse['subcategory'][i]['price'],
                jsonResponse['subcategory'][i]['description'],
              ));
              print(
                jsonResponse['subcategory'][i]['menu_name'],
              );
            }*/
            setState(() {
              //isSelectedCategoryLoaded = true;
            });
          }
        } else {
          setState(() {
            //isSelectedCategoryLoaded = true;
          });
        }
      } catch (e) {
        setState(() {
          //isErrorInLoading = true;
          //isSelectedCategoryLoaded = true;
        });
      }
    }
    setState(() {
      carousalCat = carousalCat..shuffle();

      isCarousalFetchDone = true;
    });
    print('Carousal Cat');
    print(carousalCat);
  }

  categorySelected(int category) async {
    setState(() {
      selectedCat.clear();
      isSelectedCategoryLoaded = false;
    });
    String url = "$SERVER_ADDRESS/api/subcategory?category=$category";
    print("SELECTED CATEGORY : " + url);
    var response = await http.get(url).catchError((e) {
      setState(() {
        isErrorInLoading = true;
      });
    });
    try {
      var jsonResponse = convert.jsonDecode(response.body);
      if (response.statusCode == 200 && jsonResponse["success"] == "1") {
        if (response.body != null) {
          for (int i = 0; i < jsonResponse['subcategory'].length; i++) {
            selectedCat.add(SubCategory(
              jsonResponse['subcategory'][i]['id'],
              jsonResponse['subcategory'][i]['category'],
              jsonResponse['subcategory'][i]['menu_image'],
              jsonResponse['subcategory'][i]['menu_name'],
              jsonResponse['subcategory'][i]['price'],
              jsonResponse['subcategory'][i]['description'],
            ));
          }
          setState(() {
            isSelectedCategoryLoaded = true;
          });
        }
      } else {
        setState(() {
          isSelectedCategoryLoaded = true;
        });
      }
    } catch (e) {
      setState(() {
        isErrorInLoading = true;
        isSelectedCategoryLoaded = true;
      });
    }
  }

  Future<void> makeListEmpty() async {
    for (int i = 0; i < categoryLength; i++) {
      isSelected.add(false);
    }
    setState(() {
      isSelected[0] = !isSelected[0];
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose called");
    //notificationHelper.cancel();
    //controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    readCart();
    return Scaffold(
      backgroundColor: WHITE,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                Stack(
                  children: [
                    Image.asset("assets/icons/home_start.png",
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Container(
                        height: 170,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 70),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Здравей!',
                                style: TextStyle(
                                    fontFamily: 'Bergen',
                                    fontSize: 12,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Какво ще',
                                style: TextStyle(
                                    fontFamily: 'Bergen',
                                    fontSize: 25,
                                    color: RED,
                                    fontWeight: FontWeight.w900),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 3),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: BLACK, width: 3))),
                                child: Text(
                                  'желаеш днес?',
                                  style: TextStyle(
                                      fontFamily: 'Bergen',
                                      fontSize: 25,
                                      color: RED,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),

                              //Text('Здравей!'), // 393939 //12 // regular
                              //Text('Какво ще желаеш днес?'), //red //30 //bold
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: OFFWHITE,
                            child: Container(
                              decoration: BoxDecoration(
                                  //borderRadius: BorderRadius.circular(20),

                                  ),
                              child: Image.asset(
                                "assets/icons/user.png",
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          InkWell(
                            child: Image.asset(
                              "assets/icons/menu.png",
                              width: 40,
                              height: 40,
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
                  ],
                ),
                (categories.length) == 0 || (carousalCat.length == 0)
                    ? Expanded(
                        child: Container(
                          color: WHITE,
                          child: Center(
                            child: isErrorInLoading
                                ? MyErrorWidget()
                                : CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            height: 630,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: WHITE,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    height: 85,
                                    child: ListView.builder(
                                      itemCount: categories.length,
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return category(
                                            categories[index]
                                                .cat_icon
                                                .replaceAll("\\", ""),
                                            categories[index].cat_name,
                                            index,
                                            categories[index].id);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      categorySelectedName,
                                      style: TextStyle(
                                          fontFamily: 'Bergen',
                                          fontSize: 15,
                                          color: BLACK,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  !isSelectedCategoryLoaded
                                      ? Expanded(
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()))
                                      : Expanded(
                                          child: GridView.count(
                                          scrollDirection: Axis.horizontal,
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 2,
                                          shrinkWrap: true,
                                          //childAspectRatio: 0.8,
                                          physics: ClampingScrollPhysics(),
                                          children: List.generate(
                                              selectedCat.length, (index) {
                                            return subCategoryCard(
                                              selectedCat[index].id,
                                              selectedCat[index].menu_name,
                                              selectedCat[index].menu_image,
                                              selectedCat[index].price,
                                              selectedCat[index].description,
                                            );
                                          }),
                                        )),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      'Популярни днес…',
                                      style: TextStyle(
                                          fontFamily: 'Bergen',
                                          fontSize: 15,
                                          color: BLACK,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //

                                  //
                                  SingleChildScrollView(
                                    child: Container(
                                      height: 155,
                                      child: Stack(
                                        children: <Widget>[
                                          CarouselSlider(
                                            items: List.generate(
                                                carousalCat.length, (index) {
                                              return subCategoryCard(
                                                carousalCat[index].id,
                                                carousalCat[index].menu_name,
                                                carousalCat[index].menu_image,
                                                carousalCat[index].price,
                                                carousalCat[index].description,
                                              );
                                            }),
                                            options: CarouselOptions(
                                                enlargeCenterPage: true,
                                                height: 150),
                                            carouselController: _controller,
                                          ),
                                          Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Flexible(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: RED,
                                                            shape:
                                                                CircleBorder()),
                                                    onPressed: () => _controller
                                                        .previousPage(),
                                                    child: Text('←'),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: RED,
                                                            shape:
                                                                CircleBorder()),
                                                    onPressed: () =>
                                                        _controller.nextPage(),
                                                    child: Text('→'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )

                                  /*Container(
                                    height: 100,
                                    child: ListView.builder(
                                      itemCount: categories.length,
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return category(
                                            categories[index]
                                                .cat_icon
                                                .replaceAll("\\", ""),
                                            categories[index].cat_name,
                                            index,
                                            categories[index].id);
                                      },
                                    ),
                                  ),*/
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: BLACK,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              CART,
                              style: TextStyle(
                                fontFamily: 'Bergen',
                                color: WHITE,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                cartImage1 == ""
                                    ? Container()
                                    : Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: LIGHT_GREY,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: CachedNetworkImage(
                                                imageUrl: cartImage1,
                                                height: 40,
                                                width: 40,
                                                placeholder: (context, url) =>
                                                    Icon(
                                                  Icons.image,
                                                  color: LIGHT_GREY,
                                                  size: 35,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(
                                                  Icons.error,
                                                  color: LIGHT_GREY,
                                                  size: 35,
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  width: 5,
                                ),
                                cartImage2 == ""
                                    ? Container()
                                    : Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: LIGHT_GREY,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: CachedNetworkImage(
                                                imageUrl: cartImage2,
                                                height: 40,
                                                width: 40,
                                                placeholder: (context, url) =>
                                                    Icon(
                                                  Icons.image,
                                                  color: LIGHT_GREY,
                                                  size: 35,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(
                                                  Icons.error,
                                                  color: LIGHT_GREY,
                                                  size: 35,
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  width: 5,
                                ),
                                cartImage3 == ""
                                    ? Container()
                                    : Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: LIGHT_GREY,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: CachedNetworkImage(
                                                  imageUrl: cartImage3,
                                                  height: 40,
                                                  width: 40,
                                                  placeholder: (context, url) =>
                                                      Icon(
                                                    Icons.image,
                                                    color: LIGHT_GREY,
                                                    size: 35,
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(
                                                    Icons.error,
                                                    color: LIGHT_GREY,
                                                    size: 35,
                                                  ),
                                                  fit: BoxFit.fill,
                                                )),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: WHITE,
                                  ),
                                  child: Center(
                                    child: Text(
                                      totalCartItems.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Bergen',
                                        fontWeight: FontWeight.w900,
                                        color: BLACK,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CartPage(
                                                int.parse(deliveryCharges))));
                                    //readCart();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: WHITE,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: BLACK,
                                        size: 17,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      drawer: Container(
          child: SideMenu(int.parse(
              deliveryCharges.isEmpty ? 0.toString() : deliveryCharges))),
    );
  }

  closeDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  Widget subCategoryCard(
      int id, String name, String image, String price, String description) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailsPage("", "", "", "", id, int.parse(deliveryCharges)),
          ),
        );
      },
      child: Container(
        height: 200,
        width: 150,
        child: Card(
          color: OFFWHITE,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: image.replaceAll("\\", ""),
                                fit: BoxFit.fill,
                                width: 150,
                                height: 150,
                                placeholder: (context, url) => Container(
                                    color: WHITE,
                                    child: Center(
                                        child: Icon(
                                      Icons.image,
                                      color: LIGHT_GREY,
                                      size: 35,
                                    ))),
                                errorWidget: (context, url, error) => Container(
                                    color: WHITE,
                                    child: Center(
                                        child: Icon(
                                      Icons.error,
                                      color: LIGHT_GREY,
                                      size: 35,
                                    ))),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                //
                                //
                                //
                                // For the red button
                                //
                                //
                                //
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: RED, shape: BoxShape.circle),
                                child: Icon(
                                  Icons.add,
                                  color: WHITE,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Bergen',
                          color: BLACK,
                          fontSize: 12,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${(double.parse(price).toStringAsFixed(2)).replaceAll('.', ',')} $CURRENCY",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Bergen',
                        fontSize: 16,
                        color: BLACK,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget category(String imagePath, String name, int index, int id) {
    return isCategoryLoaded
        ? InkWell(
            onTap: () {
              setState(() {
                categorySelectedName = name;
                if (selectedItemIndex != index && isSelectedCategoryLoaded) {
                  isSelected[selectedItemIndex] = false;
                  selectedItemIndex = index;
                  isSelected[index] = !isSelected[index];
                  categorySelected(id);
                }
              });
            },
            child: Container(
              margin: EdgeInsets.all(5),
              child: Stack(
                children: [
                  /*Center(
              child: Image.asset(
                isSelected[index]
                    ? "assets/icons/active.png"
                    : "assets/icons/un_active.png",
                height: 120,
                width: 70,
                //color: isSelected[index] ? THEME_COLOR : Colors.transparent,
              ),
            ),*/
                  Container(
                    height: 55,
                    width: 130,
                    decoration: BoxDecoration(
                      color: isSelected[index] ? RED : WHITE,
                      border: Border.all(color: GREY),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: imagePath,
                              height: 25,
                              width: 25,
                              placeholder: (context, url) => Icon(
                                Icons.image,
                                color: LIGHT_GREY,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            Expanded(
                              child: Text(
                                name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Bergen',
                                    color: isSelected[index] ? WHITE : BLACK,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
