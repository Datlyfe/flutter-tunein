import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'components/button.dart';
import 'components/appbar.dart';
import 'globals.dart';
import 'components/card.dart';
import 'package:music/musicplayer.dart' as musicplayer;
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'dart:async';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new MyAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: MyTheme.bgBottomBar,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedItemColor: MyTheme.darkRed,
        unselectedItemColor: Colors.white54,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              IconData(0xebf0, fontFamily: "Boxicons"),
            ),
            title: Text('Library'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              IconData(0xec7d, fontFamily: "Boxicons"),
            ),
            title: Text('For You'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              IconData(0xecb4, fontFamily: "Boxicons"),
            ),
            title: Text('Music'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              IconData(0xebdf, fontFamily: "Boxicons"),
            ),
            title: Text('Radio'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              IconData(0xeb2e, fontFamily: "Boxicons"),
            ),
            title: Text('Search'),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        // color: Colors.white,
        color: MyTheme.darkBlack,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Column(
                children: <Widget>[
                  TextField(
                    cursorColor: Colors.white,
                    enabled: false,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.white30,
                        ),
                        icon: Icon(
                          IconData(0xeb2e, fontFamily: "Boxicons"),
                          color: Colors.white30,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        hintText: 'Track, Album, Artsit'),
                  ),
                  SizedBox(
                    height: 30.0,
                    child: Divider(
                      height: 2.0,
                      color: MyTheme.bgdivider,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: getSongListView(context),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getSongListView(context) {
  var items = musicplayer.allMetaData;
  items.sort((a, b) {
    return a[0].toLowerCase().compareTo(b[0].toLowerCase());
  });
  final myScrollController = ScrollController();

  var listView = ListView.builder(
    shrinkWrap: true,
    itemExtent: 70,
    physics: AlwaysScrollableScrollPhysics(),
    scrollDirection: Axis.vertical,
    controller: myScrollController,
    itemCount: items.length,
    itemBuilder: (context, index) {
      var i = items[index];
      var image =
          (i[2] != null) ? musicplayer.appPath + "/" + i[2] : musicplayer.img;
      return MyCard(i[0], i[1], image);
    },
  );

  return Theme(
      data: Theme.of(context).copyWith(accentColor: MyTheme.darkRed),
      child: listView);
}
