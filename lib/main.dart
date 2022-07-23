import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:food_delivery/NotificationTest.dart';
import 'package:food_delivery/TestFirebaseNotification.dart';
import 'package:food_delivery/jsonobjects/JsonObjectTesting.dart';
import 'package:food_delivery/modals/CartItems.dart';
import 'package:food_delivery/modals/Favourite.dart';
import 'package:food_delivery/notificationHelper.dart';
import 'package:food_delivery/views/AboutUs.dart';
import 'package:food_delivery/views/AllLocations.dart';
import 'package:food_delivery/views/BookOrder.dart';
import 'package:food_delivery/views/CartPage.dart';
import 'package:food_delivery/views/CheckOutPage.dart';
import 'package:food_delivery/views/ChooseLocation.dart';
import 'package:food_delivery/views/DeliveryBoy/DeliveryBoyOrderDetails.dart';
import 'package:food_delivery/views/DeliveryBoy/DeliveryBoyOrderHistory.dart';
import 'package:food_delivery/views/DeliveryBoy/DeliveryBoyProfile.dart';
import 'package:food_delivery/views/DismissibleTest.dart';
import 'package:food_delivery/views/HomeScreen.dart';

import 'package:food_delivery/views/OrderProgress.dart';
import 'package:food_delivery/views/SplashScreen.dart';
import 'package:food_delivery/views/login/LoginAsDeliveryBoy.dart';

import 'package:hive/hive.dart';
import 'package:intl/intl_standalone.dart';
import 'package:path_provider/path_provider.dart';

String SERVER_ADDRESS = "https://cerbsolar.bg/reze.gerycaffeine.com";
//String SERVER_ADDRESS = "https://dpcfoodtech.com/dpcadminpanel";
//String SERVER_ADDRESS = "https://aunty.qthrust.com";
//const String SERVER_ADDRESS = "https://cherestu.com/restaurant";
String CURRENCY = "лв";
const int PHONE_NUMBER_LENGTH = 7;

String STRIPE_KEY = "pk_test_yFUNiYsEESF7QBY0jcZoYK9j00yHumvXho";
const String STRIPE_MERCHANT_ID = "Test";
const String STRIPE_PAYMENT_MODE = "test";

const Color WHITE = Colors.white;
const Color BLACK = Colors.black;
const Color RED = Color(0xFFb70404);
const Color OFFWHITE = Color(0xFFF6F1E7);

Color THEME_COLOR = Colors.deepOrange.shade100;
Color DEEP_ORANGE_COLOR = Colors.deepOrange;
Color LIGHT_GREY = Colors.grey.shade200;
Color GREY = Colors.grey.shade600;
const TextDirection textDirection = TextDirection.ltr;
bool forceRtl = false;

String MAP_API_KEY = "AIzaSyCjQYZwMRnybJ63XaREdgpGWFdW0IPuZcc";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //initializeMessages("dk").then(printSomeMessages);
  NotificationHelper notificationHelper = NotificationHelper();
  notificationHelper.initialize();
  final path = await getApplicationDocumentsDirectory();
  Hive.init(path.path);
  Hive.registerAdapter(FavouritesAdapter());
  findSystemLocale().then((v) {
    print(v);
    runApp(
      MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepOrange.shade100,
            primaryColor: Colors.deepOrange,
            fontFamily: 'Bergen'),
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // English, no country code
          const Locale('he', ''), // Hebrew, no country code
          const Locale('ar', ''), // Hebrew, no country code
          const Locale.fromSubtags(
              languageCode: 'zh'), // Chinese *See Advanced Locales below*
          // ... other locales the app supports
        ],
      ),
    );
  });
}
