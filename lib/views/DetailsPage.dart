import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/AllText.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/modals/CartItems.dart';
import 'package:food_delivery/modals/DetailsPageClass.dart';
import 'package:food_delivery/modals/Favourite.dart';
import 'package:food_delivery/modals/Toppings.dart';
import 'package:food_delivery/views/CartPage.dart';
import 'package:food_delivery/views/ErrorWidget.dart';
import 'package:dotted_line/dotted_line.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert' as convert;

import 'package:share/share.dart';
import 'package:toast/toast.dart';

class DetailsPage extends StatefulWidget {
  String name;
  String image;
  String price;
  String description;
  int id;
  int deliveryCharges;

  DetailsPage(this.name, this.image, this.price, this.description, this.id,
      this.deliveryCharges);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List<bool> options = List<bool>();
  List<Toppings> toppingData = List<Toppings>();
  List<Toppings> toppingTitle = List<Toppings>();
  bool isLoadingToppings = true;
  int titleLength = 0;
  List<int> toppingLength = List<int>();
  int quantity = 1;
  double actualPrice;
  bool downloadingError = false;
  double _progress = 0.0;
  String imagePath = "";
  Favourites favourites = Favourites();
  bool isLiked = false;
  CartITems cartITems = CartITems();
  List<Toppings> addedToppings = List();
  DetailsPageClass detailsPageClass;
  bool isDeleted = false;
  bool isLoading = true;
  bool isErrorInLoading = false;
  String cartImage1 = "";
  String cartImage2 = "";
  String cartImage3 = "";
  int totalCartItems = 0;

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

  fetchToppings() async {
    toppingData.clear();
    toppingTitle.clear();
    isLoadingToppings = true;
    print(widget.id);
    String url = "$SERVER_ADDRESS/api/gettopping?menu_id=${widget.id}";
    var response = await http.get(url).catchError((e) {
      setState(() {
        isErrorInLoading = true;
      });
    });
    try {
      if (response.statusCode == 200) {
        final jsonRespone = convert.jsonDecode(response.body);
        if (response.body != null) {
          var jsonResponse = convert.jsonDecode(response.body);
          setState(() {
            titleLength = jsonResponse['data'].length;
          });
          for (int i = 0; i < jsonResponse['data'].length; i++) {
            setState(() {
              toppingTitle.add(Toppings.title(jsonResponse['data'][i]['name']));
              toppingLength.add(jsonResponse['data'][i]['topping'].length);
            });
            for (int j = 0;
            j < jsonResponse['data'][i]['topping'].length;
            j++) {
              toppingData.add(
                Toppings(
                  jsonResponse['data'][i]['topping'][j]['id'].toString(),
                  jsonResponse['data'][i]['topping'][j]['top_cat_id']
                      .toString(),
                  jsonResponse['data'][i]['topping'][j]['name'],
                  jsonResponse['data'][i]['topping'][j]['price'],
                ),
              );
              //print(toppingData[j].toppingName);
              options.add(false);
            }
          }
          setState(() {
            isLoadingToppings = false;
          });
          for (int i = 0; i < toppingData.length; i++) {
            print(toppingData[i].toppingName);
          }
          print(jsonResponse['data'][0]['topping'].length);
        } else {
          print("\n\n\nError : $isDeleted\n\n\n");
        }
      }
    } catch (e) {
      setState(() {
        isErrorInLoading = true;
      });
    }
  }

  fetchItemDetails() async {
    print("CALLED 1");
    setState(() {
      isLoading = true;
    });
    final response = await http
        .get("$SERVER_ADDRESS/api/viewitem/${widget.id}")
        .catchError((e) {
      setState(() {
        isErrorInLoading = true;
      });
    });
    try {
      final jsonResponse = convert.jsonDecode(response.body);

      print(response.body);

      if (response.statusCode == 200 && jsonResponse["success"] == "1") {
        detailsPageClass = DetailsPageClass.fromJson(jsonResponse);
        if (detailsPageClass.success == "1") {
          setState(() {
            widget.name = detailsPageClass.order.menuName;
            widget.image = detailsPageClass.order.menuImage;
            widget.price = detailsPageClass.order.price;
            widget.description = detailsPageClass.order.description;
            isLoading = false;
            isDeleted = false;
          });
          actualPrice = double.parse(widget.price);
          fetchToppings();
          chkFavourite();
          downloadImage();
        }
      } else {
        setState(() {
          isDeleted = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print("CALLED Error");
      setState(() {
        isErrorInLoading = true;
      });
    }
    print("CALLED 2");
  }

  // fetchOrderDetails() async{
  //   final response = await http.get("https://freaktemplate.com/fooddelivery_app/api/subcategory?category=${widget.id}");
  //   if(response.statusCode == 200){
  //     final jsonResponse = convert.jsonDecode(response.body);
  //     detailsPageClass = DetailsPageClass.fromJson(jsonResponse);
  //     if(detailsPageClass.success == "1"){
  //
  //     }
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchItemDetails();
    readCart();
  }

  chkFavourite() async {
    await favourites.chkIfAlreadyInDatabase(widget.id).then((value) {
      setState(() {
        isLiked = value;
      });
    });
  }

  downloadImage() async {
    //downloadingError ? null :Toast.show("Loading...", context, duration: 2);
    try {
      setState(() {
        downloadingError = false;
      });
      String dir =
          (await getExternalStorageDirectory()).path + "/shareimage" + ".png";
      print("path is: $dir");
      setState(() {
        imagePath = dir;
      });
      File file = File(dir);
      await Dio().download(widget.image.replaceAll("\\", ""), dir,
          onReceiveProgress: showDownloadProgress);
    } catch (e) {
      setState(() {
        downloadingError = true;
      });
      Toast.show("Slow internet connection", context, duration: 1);
    }
  }

  showDownloadProgress(received, total) {
    if (total != -1) {
      var percentage = (received / total * 100);
      if (percentage < 100) {
        setState(() {
          _progress = percentage;
          //print(_progress);
        });
      } else {
        setState(() {
          _progress = percentage;
        });
        print("Downloaded Successfully");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? isErrorInLoading
          ? MyErrorWidget()
          : Center(
        child: CircularProgressIndicator(),
      )
          : SafeArea(
        child: isDeleted
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "!",
                style: TextStyle(
                    fontFamily: 'Bergen',
                    color: BLACK,
                    fontSize: 150),
              ),
              Text(REQUESTED_ITEM_NOT_AVAILABLE,
                  style: TextStyle(
                    fontFamily: 'Bergen',
                    color: BLACK,
                  )),
            ],
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      //height: 250,
                      child: Column(
                        children: [
                          Container(
                            margin:
                            EdgeInsets.fromLTRB(0, 10, 10, 0),
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: widget.image
                                    .replaceAll("\\", ""),
                                height: 200,
                                width: double.infinity,
                                placeholder: (context, url) => Icon(
                                  Icons.image,
                                  color: OFFWHITE,
                                ),
                                errorWidget:
                                    (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DottedLine(
                            dashColor: RED,
                            dashGapLength: 20,
                            dashLength: 14,
                            lineThickness: 5,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.name,
                                      style: TextStyle(
                                        fontFamily: 'Bergen',
                                        color: RED,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.description,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'Bergen',
                                      color: GREY,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      height: 1.5),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(
                                            20),
                                        border: Border.all(
                                            color: GREY
                                                .withOpacity(0.5),
                                            width: 1)),
                                    child: Row(
                                      children: [
                                        IconButton(
                                            padding:
                                            EdgeInsets.zero,
                                            icon: Image.asset(
                                              "assets/detailsPageIcons/Minus.png",
                                              height: 12,
                                              width: 12,
                                              fit: BoxFit.contain,
                                              color: BLACK,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (quantity > 1) {
                                                  quantity -= 1;
                                                  widget
                                                      .price = (double.parse(
                                                      widget
                                                          .price) -
                                                      double.parse(widget
                                                          .price) /
                                                          (quantity +
                                                              1))
                                                      .toString();
                                                }
                                              });
                                            }),
                                        Text(
                                          quantity.toString(),
                                          style: TextStyle(
                                            fontFamily: 'Bergen',
                                            color: BLACK,
                                            fontSize: 17,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                            padding:
                                            EdgeInsets.zero,
                                            icon: Image.asset(
                                              "assets/detailsPageIcons/Plus.png",
                                              height: 12,
                                              width: 12,
                                              fit: BoxFit.contain,
                                              color: BLACK,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                quantity += 1;
                                                widget
                                                    .price = (double
                                                    .parse(widget
                                                    .price) +
                                                    double.parse(widget
                                                        .price) /
                                                        (quantity -
                                                            1))
                                                    .toString();
                                              });
                                            }),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "${double.parse(widget.price).toStringAsFixed(2)} $CURRENCY",
                                    style: TextStyle(
                                      fontFamily: 'Bergen',
                                      color: BLACK,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Visibility(
                                visible: isLoadingToppings,
                                child: Row(
                                  children: [
                                    Text(
                                      EXTRA_CHOOSE_A_TOPPING,
                                      style: TextStyle(
                                        fontFamily: 'Bergen',
                                        color: BLACK,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              !isLoadingToppings
                                  ? Column(
                                children: List.generate(
                                    titleLength, (i) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            toppingTitle[i]
                                                .title,
                                            style: TextStyle(
                                              fontFamily:
                                              'Bergen',
                                              color: RED,
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight
                                                  .bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: GridView.count(
                                          shrinkWrap: true,
                                          physics:
                                          ClampingScrollPhysics(),
                                          crossAxisCount: 2,
                                          childAspectRatio: 3,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 10,
                                          children:
                                          List.generate(
                                              toppingLength[
                                              i],
                                                  (index) {
                                                //print(toppingData[index+(i==0?0:toppingLength[i-1])].toppingName);
                                                int toppingIndex =
                                                0;
                                                for (int x = 0;
                                                x < i;
                                                x++) {
                                                  toppingIndex =
                                                      toppingIndex +
                                                          toppingLength[
                                                          x];
                                                }
                                                return optionsMenu(
                                                    toppingData[index +
                                                        toppingIndex]
                                                        .toppingName,
                                                    toppingData[index +
                                                        toppingIndex]
                                                        .toppingPrice,
                                                    index +
                                                        toppingIndex);
                                              }),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  );
                                }),
                              )
                                  : Container(
                                child:
                                CircularProgressIndicator(
                                  valueColor:
                                  AlwaysStoppedAnimation(
                                      THEME_COLOR),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isDeleted
                ? Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                color: WHITE,
                child: Padding(
                  padding:
                  const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await favourites
                                .removeFromFavourites(
                                widget.id);
                            Navigator.pop(context, true);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: WHITE,
                              borderRadius:
                              BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                REMOVE_FROM_FAVOURITES,
                                style: TextStyle(
                                  fontFamily: 'Bergen',
                                  color: BLACK,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
                : Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                color: LIGHT_GREY,
                child: Padding(
                  padding:
                  const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Row(
                    children: [
                      /*InkWell(
                      onTap: () {
                        isLiked
                            ? favourites
                            .removeFromFavourites(widget.id)
                            .then((value) {
                          setState(() {
                            isLiked = value;
                          });
                        })
                            : favourites
                            .addToDataBase(
                          Favourites.constuctor(
                              widget.id,
                              widget.name,
                              widget.price,
                              widget.image,
                              widget.description),
                        )
                            .then((value) {
                          Toast.show(
                              ADDED_TO_FAVOURITES, context,
                              duration: 1);
                          setState(() {
                            isLiked = value;
                          });
                        });
                      },
                      child: isLiked
                          ? Image.asset(
                          "assets/detailsPageIcons/Like.png",
                          color: DEEP_ORANGE_COLOR)
                          : Image.asset(
                          "assets/detailsPageIcons/Like.png")),
                  SizedBox(
                    width: 10,
                  ),*/
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
                              BorderRadius.circular(
                                  30),
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                const EdgeInsets
                                    .all(3),
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius
                                      .circular(20),
                                  child:
                                  CachedNetworkImage(
                                    imageUrl:
                                    cartImage1,
                                    height: 40,
                                    width: 40,
                                    placeholder:
                                        (context,
                                        url) =>
                                        Icon(
                                          Icons.image,
                                          color: LIGHT_GREY,
                                          size: 35,
                                        ),
                                    errorWidget:
                                        (context, url,
                                        error) =>
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
                              BorderRadius.circular(
                                  30),
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                const EdgeInsets
                                    .all(3),
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius
                                      .circular(20),
                                  child:
                                  CachedNetworkImage(
                                    imageUrl:
                                    cartImage2,
                                    height: 40,
                                    width: 40,
                                    placeholder:
                                        (context,
                                        url) =>
                                        Icon(
                                          Icons.image,
                                          color: LIGHT_GREY,
                                          size: 35,
                                        ),
                                    errorWidget:
                                        (context, url,
                                        error) =>
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
                              BorderRadius.circular(
                                  30),
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                const EdgeInsets
                                    .all(3),
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        20),
                                    child:
                                    CachedNetworkImage(
                                      imageUrl:
                                      cartImage3,
                                      height: 40,
                                      width: 40,
                                      placeholder:
                                          (context,
                                          url) =>
                                          Icon(
                                            Icons.image,
                                            color:
                                            LIGHT_GREY,
                                            size: 35,
                                          ),
                                      errorWidget:
                                          (context, url,
                                          error) =>
                                          Icon(
                                            Icons.error,
                                            color:
                                            LIGHT_GREY,
                                            size: 35,
                                          ),
                                      fit: BoxFit.fill,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        // Add to Cart button
                        child: InkWell(
                          onTap: () {
                            String toppingString = "";
                            // for(int i=0; i<addedToppings.length; i++) {
                            //   toppingString = toppingString + addedToppings[i].toppingName + "*";
                            // }
                            print(toppingString);
                            showdialog(false);
                            cartITems
                                .addToCart(
                                CartITems.constructor(
                                  quantity.toString(),
                                  widget.name,
                                  widget.price,
                                  widget.image
                                      .replaceAll("\\", ""),
                                  addedToppings,
                                  actualPrice.toString(),
                                  widget.id.toString(),
                                ))
                                .then((value) {
                              Navigator.pop(context);
                              showdialog(true);
                              //Toast.show('Added to cart', context, duration: 2);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: WHITE,
                              borderRadius:
                              BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                ADD_TO_CART,
                                style: TextStyle(
                                  fontFamily: 'Bergen',
                                  color: BLACK,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
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
    );
  }

  optionsMenu(String option, String price, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          options[index] = !options[index];
          if (options[index]) {
            addedToppings.add(Toppings(
              toppingData[index].id,
              toppingData[index].top_cat_id,
              toppingData[index].toppingName,
              toppingData[index].toppingPrice,
            ));
            print('added\n $addedToppings');
            for (int i = 0; i < addedToppings.length; i++) {
              print(addedToppings[i].toppingName);
            }
          } else {
            print(addedToppings.length);
            print("index : $index");
            for (int i = 0; i < addedToppings.length; i++) {
              if (addedToppings[i].id == toppingData[index].id) {
                addedToppings.removeAt(i);
                print('removed');
              }
            }
          }
          options[index]
              ? widget.price = (double.parse(widget.price) +
              (quantity *
                  double.parse(toppingData[index].toppingPrice)))
              .toString()
              : widget.price = (double.parse(widget.price) -
              (quantity *
                  double.parse(toppingData[index].toppingPrice)))
              .toString();
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 30,
        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
        decoration: BoxDecoration(
          color: !options[index] ? OFFWHITE : RED,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 25,
              ),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                      fontFamily: 'Bergen',
                      color: !options[index] ? BLACK : WHITE,
                      fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  children: [
                    Text(
                      '+ ',
                      style: TextStyle(
                          fontFamily: 'Bergen',
                          color: !options[index] ? BLACK : WHITE,
                          fontSize: 12),
                    ),
                    Text(
                      (double.parse(price)).toStringAsFixed(2),
                      style: TextStyle(
                          fontFamily: 'Bergen',
                          color: !options[index] ? BLACK : WHITE,
                          fontSize: 12),
                    ),
                    Text(
                      '$CURRENCY',
                      style: TextStyle(
                          fontFamily: 'Bergen',
                          color: !options[index] ? BLACK : WHITE,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showdialog(bool isAdded) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () {},
            child: AlertDialog(
              title: Text(
                isAdded ? ADDED : PROCESSING,
                style: TextStyle(
                  fontFamily: 'Bergen',
                  color: BLACK,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: isAdded
                  ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$quantity ${widget.name}, $SUCCESSFULLY_ADDED_TO_CART_FOR_PRICE ${widget.price} $CURRENCY'
                        ' $CLICK_CHECKOUT_TO_GO_TO_CART',
                    style: TextStyle(
                      fontFamily: 'Bergen',
                      color: BLACK,
                      fontSize: 15,
                    ),
                  )
                ],
              )
                  : Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              actions: isAdded
                  ? [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    ADD_MORE,
                    style: TextStyle(
                      fontFamily: 'Bergen',
                      color: THEME_COLOR,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CartPage(widget.deliveryCharges)));
                  },
                  color: THEME_COLOR,
                  child: Text(
                    CHECKOUT,
                    style: TextStyle(
                      fontFamily: 'Bergen',
                      color: BLACK,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ]
                  : null,
            ),
          );
        });
  }
}
