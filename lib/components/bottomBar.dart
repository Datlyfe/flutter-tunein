import 'package:flutter/material.dart';

import '../globals.dart';

class Bottombar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
    );
  }
}
