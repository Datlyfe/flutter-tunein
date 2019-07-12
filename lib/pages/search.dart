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
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: MediaQuery.of(context).padding,
          ),
          Material(
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Color(0xff0E0E0E),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.5),
                    spreadRadius: 10,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      iconSize: 18,
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        autofocus: false,
                        cursorColor: MyTheme.darkRed,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: MyTheme.darkBlack,
                          hintText: "TRACK, ALBUM, ARTIST",
                          hintStyle:
                              TextStyle(color: Colors.white54, fontSize: 18),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      iconSize: 18,
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(color: MyTheme.darkBlack),
          ),
        ],
      ),
    );
  }
}
