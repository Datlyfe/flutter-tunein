import 'package:flutter/material.dart';

import '../globals.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyTheme.bgBottomBar,
      child: Center(
        child: Container(
            margin: EdgeInsets.all(20.0),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    "images/logo5.png",
                    width: 175,
                  ),
                  Text(
                    "Musicly",
                    style: TextStyle(
                      fontFamily: 'pacifico',
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(MyTheme.darkRed),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
