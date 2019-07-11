import 'package:Tunein/services/layout.dart';
import 'package:Tunein/services/locator.dart';
import 'package:Tunein/values/lists.dart';
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
      onTap: (int index) {
        layoutService.changeGlobalPage(index);

        setState(() {
          _currentIndex = index;
        });
      },
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
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  item.key.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              )))
          .toList(),
    );
  }
}
