import 'package:Tunein/pages/search.dart';
import 'package:Tunein/services/layout.dart';
import 'package:Tunein/services/locator.dart';
import 'package:Tunein/values/lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../globals.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key key}) : super(key: key);

  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  final layoutService = locator<LayoutService>();
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _handleTap,
      backgroundColor: MyTheme.bgBottomBar,
      unselectedItemColor: Colors.white54,
      selectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      iconSize: 22,
      items: bottomNavBarItems
          .map((item) => BottomNavigationBarItem(
              backgroundColor: MyTheme.bgBottomBar,
              icon: item.value,
              title: Padding(
                padding: const EdgeInsets.only(top :5.0),
                child: Text(
                  item.key.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              )))
          .toList(),
    );
  }

  _setBarIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _navigate() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchPage(),
      ),
    );
  }

  _handleTap(int index) {
    switch (index) {
      case 0:
        layoutService.changeGlobalPage(index);
        _setBarIndex(index);
        break;
      case 1:
        layoutService.changeGlobalPage(index);
        _setBarIndex(index);
        break;
      case 2:
        _navigate();
        break;
      case 3:
        _navigate();
        break;
      case 4:
        _navigate();
        break;
    }
  }
}
