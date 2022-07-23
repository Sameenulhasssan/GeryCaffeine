import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../AllText.dart';
import '../main.dart';

class MyErrorWidget extends StatefulWidget {
  @override
  _MyErrorWidgetState createState() => _MyErrorWidgetState();
}

class _MyErrorWidgetState extends State<MyErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                child: FlareActor("assets/Flare/error.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: "no_network"),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Something went wrong!",
                style: GoogleFonts.comfortaa(
                  color: BLACK,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Make sure your internet is working.",
                style: GoogleFonts.comfortaa(
                  color: GREY,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

messageDialog(String title, String msg, BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Bergen',
              color: BLACK,
            ),
          ),
          content: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline_outlined,
                  size: 50,
                  color: GREY,
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Text(
                    msg,
                    style: TextStyle(
                        fontFamily: 'Bergen', color: BLACK, fontSize: 13),
                  ),
                )
              ],
            ),
          ),
          actions: [
            FlatButton(
              color: THEME_COLOR,
              child: Text(
                OK,
                style: GoogleFonts.comfortaa(
                  color: BLACK,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}
