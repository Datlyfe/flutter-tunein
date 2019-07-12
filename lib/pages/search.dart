import 'package:Tunein/globals.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: MyTheme.darkBlack,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Color(0xff0E0E0E), boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.4),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(0, 2))
              ]),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              height: 65,
              child: Container(
                decoration: BoxDecoration(
                    // color: MyTheme.darkRed,
                    // borderRadius: BorderRadius.circular(6),
                    ),
                child: TextField(
                  cursorColor: MyTheme.darkRed,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    filled: true,
                    fillColor: MyTheme.darkBlack,
                    hintText: "TRACK, ALBUM, ARTIST",
                    // contentPadding: EdgeInsets.all(16),
                    hintStyle: TextStyle(color: Colors.white54),
                    border:InputBorder.none
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
