import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'components/button.dart';
import 'components/appbar.dart';
import 'globals.dart';
import 'components/card.dart';
import 'package:music/musicplayer.dart' as musicplayer;

class Home extends StatelessWidget {
  void log() {
    print(musicplayer.allFilePaths.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new MyAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: MyTheme.bgBottomBar,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedItemColor: MyTheme.darkRed,
        unselectedItemColor: MyTheme.darkgrey,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // mainAxisSize: ,
              children: <Widget>[
                new MyFlatButton(0xeb10, "Play", this.log),
                new MyFlatButton(Icons.shuffle, "Shuffle", () => {}, false)
              ],
            ),
            new LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox(
                height: 30.0,
                width: constraints.maxWidth - 40,
                child: Divider(
                  height: 2.0,
                  color: MyTheme.bgdivider,
                ),
              );
            }),
            Expanded(
              child: getSongListView(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getSongListView() {
  var items = musicplayer.allMetaData;

  var listView = ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        var i = items[index];
        var image =
            (i[2] != null) ? musicplayer.appPath + "/" + i[2] : musicplayer.img;
        return new MyCard(i[0], i[1], image);
      });

  return listView;
}
