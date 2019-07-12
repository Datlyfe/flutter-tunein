import 'package:Tunein/services/layout.dart';
import 'package:Tunein/services/locator.dart';
import 'package:Tunein/values/lists.dart';
import 'package:flutter/material.dart';

import '../globals.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key key, this.navigationKey}) : super(key: key);
  final GlobalKey<NavigatorState> navigationKey;
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  BottomNavBar get widget => super.widget;
  int _currentIndex = 0;
  final layoutService = locator<LayoutService>();

  List<String> routes = ['/', '/p', '/s', 'e', 'g'];
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (int index) async {
        String currentRoute = routes[layoutService
            .navigationStack[layoutService.navigationStack.length - 1]];

        String newRoute = routes[index];

        if (newRoute == currentRoute) return;

        print("CURRENT ROUTE $currentRoute");
        print("NEW ROUTE ROUTE $newRoute");

        if (widget.navigationKey.currentState.canPop()) {
          widget.navigationKey.currentState.pop();
          layoutService.popStack();
          currentRoute = routes[layoutService
              .navigationStack[layoutService.navigationStack.length - 1]];
          print("POPPED CURRENT ROUTE $currentRoute");
        }

        if (newRoute != currentRoute) {
          widget.navigationKey.currentState.pushNamed(routes[index]);
          layoutService.pushtoStack(index);

          print("PUSHED NEW ROUTE $newRoute");
        }

        setState(() {
          _currentIndex = index;
        });
      },
      backgroundColor: MyTheme.bgBottomBar,
      unselectedItemColor: Colors.white54,
      selectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      iconSize: 20,
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
                    fontSize: 10,
                  ),
                ),
              )))
          .toList(),
    );
  }
}
