import 'dart:async';
import 'package:Tunein/pages/library/library.dart';
import 'package:Tunein/pages/playlists/index.dart';
import 'package:Tunein/pages/search/search.dart';
import 'package:Tunein/values/lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Tunein/components/playing.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'components/bottomPanel.dart';
import 'components/bottomnavbar.dart';
import 'globals.dart';

class Root extends StatefulWidget {
  Root({Key key}) : super(key: key);
  RootState createState() => RootState();
}

class RootState extends State<Root> with TickerProviderStateMixin {
  final _androidAppRetain = MethodChannel("android_app_retain");
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  PanelController _panelController;

  @override
  void initState() {
    _panelController = PanelController();
    super.initState();
  }

  @override
  void dispose() {
    _panelController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (!_panelController.isPanelClosed()) {
          _panelController.close();
        } else {
          _androidAppRetain.invokeMethod("sendToBackground");
          return Future.value(false);
        }
      },
      child: Scaffold(
        backgroundColor: MyTheme.darkBlack,
        body: SlidingUpPanel(
          panel: NowPlayingScreen(),
          controller: _panelController,
          maxHeight: MediaQuery.of(context).size.height,
          minHeight: 60,
          backdropEnabled: true,
          backdropOpacity: 0.5,
          parallaxEnabled: true,
          collapsed: BottomPanel(),
          body: Theme(
            data: Theme.of(context).copyWith(accentColor: MyTheme.darkRed),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: NestedNavigator(
                    navigationKey: navigationKey,
                    initialRoute: '/',
                    routes: {
                      '/': (context) => LibraryPage(),
                      '/p': (context) => PlaylistsPage(),
                      '/s': (context) => SearchPage(),
                      '/e': (context) => SearchPage(),
                      '/g': (context) => SearchPage(),
                    },
                  ),
                ),
                BottomNavBar(navigationKey: navigationKey),
                SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NestedNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigationKey;
  final String initialRoute;
  final Map<String, WidgetBuilder> routes;

  NestedNavigator({
    @required this.navigationKey,
    @required this.initialRoute,
    @required this.routes,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Navigator(
        key: navigationKey,
        initialRoute: initialRoute,
        onGenerateRoute: (RouteSettings routeSettings) {
          WidgetBuilder builder = routes[routeSettings.name];

          return PageRouteBuilder(
            pageBuilder: (context, __, ___) => builder(context),
            settings: routeSettings,
            transitionDuration: Duration(milliseconds: 200),
            maintainState: true,
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return SlideTransition(
                position: new Tween<Offset>(
                  begin: Offset(-1, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: new SlideTransition(
                  position: new Tween<Offset>(
                    begin: Offset.zero,
                    end: Offset(1, 0.0),
                  ).animate(secondaryAnimation),
                  child: child,
                ),
              );
            },
          );
        },
      ),
      onWillPop: () {
        if (navigationKey.currentState.canPop()) {
          navigationKey.currentState.pop();
          return Future<bool>.value(false);
        }
        return Future<bool>.value(true);
      },
    );
  }
}
