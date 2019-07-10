import 'dart:async';

import 'package:Tunein/components/appbar.dart';
import 'package:Tunein/components/pageheader.dart';
import 'package:Tunein/pages/favorites.dart';
import 'package:Tunein/pages/home.dart';
import 'package:Tunein/services/layout.dart';
import 'package:Tunein/services/locator.dart';
import 'package:Tunein/services/musicService.dart';
import 'package:flutter/material.dart';
import 'package:Tunein/components/playing.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'components/bottomPanel.dart';
import 'globals.dart';
import 'dart:math' as math;

enum StartupState { Busy, Success, Error }

class Root extends StatefulWidget {
  RootState createState() => RootState();
}

class RootState extends State<Root> with TickerProviderStateMixin {
  final musicService = locator<MusicService>();
  final layoutService = locator<LayoutService>();

  PanelController _panelController;
  PageController _pageController;
  ScrollController _headerController;
  double offset;
  double width;

  List<double> navSizes = [];

  final StreamController<StartupState> _startupStatus =
      StreamController<StartupState>();
  final _androidAppRetain = MethodChannel("android_app_retain");
  @override
  void initState() {
    _panelController = PanelController();
    _pageController = PageController();
    _headerController = ScrollController();
    offset = 0;
    width = 0;

    _startupStatus.add(StartupState.Busy);
    loadFiles();

    _pageController.addListener(() {
      int floor = (_pageController.page).floor();

      layoutService.updatePageIndex(_pageController.page);

      offset = layoutService.cumulativeNavSizes[floor];

      width = layoutService.navSizes[floor];

      _headerController
          .jumpTo((_pageController.page - floor).abs() * width + offset);
    });

    super.initState();
  }

  @override
  void dispose() {
    _panelController.close();
    _pageController.dispose();
    _startupStatus.close();
    super.dispose();
  }

  Future loadFiles() async {
    _startupStatus.add(StartupState.Busy);
    final data = await musicService.retrieveFiles();
    print(data.length);
    if (data.length == 0) {
      await musicService.fetchSongs();
      musicService.saveFiles();
      musicService.retrieveFavorites();
      _startupStatus.add(StartupState.Success);
    } else {
      musicService.retrieveFavorites();
      _startupStatus.add(StartupState.Success);
    }

    print(musicService.songs$.value.length);
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
        body: StreamBuilder<StartupState>(
          stream: _startupStatus.stream,
          builder: (BuildContext context, AsyncSnapshot<StartupState> snap) {
            if (!snap.hasData || snap.data == StartupState.Busy) {
              return Container();
            }

            return SlidingUpPanel(
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
                    Container(
                      margin: MediaQuery.of(context).padding,
                    ),
                    Container(
                        height: 60,
                        child: Row(
                          children: <Widget>[
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    IconData(0xeaea, fontFamily: 'boxicons'),
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                )),
                            Expanded(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                controller: _headerController,
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    layoutService.mainNavitems.length + 1,
                                itemBuilder: (context, int index) {
                                  var items = layoutService.mainNavitems;
                                  if (index ==
                                      layoutService.mainNavitems.length) {
                                    return Container(
                                      width: 1000,
                                    );
                                  }
                                  return PageTitle(
                                    index: index,
                                    key: items[index].value,
                                    title: items[index].key.toUpperCase(),
                                  );
                                },
                              ),
                            )
                          ],
                        )),
                       
                    Flexible(
                      // fit: FlexFit.tight,
                      child: PageView(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _pageController,
                        children: <Widget>[
                          HomePage(),
                          FavoritesPage(),
                        ],
                      ),
                    ),
                    BottomNavigationBar(
                      backgroundColor: MyTheme.bgBottomBar,
                      unselectedItemColor: Colors.white54,
                      selectedItemColor: Colors.white,
                      type: BottomNavigationBarType.shifting,
                      showUnselectedLabels: false,
                      iconSize: 22,
                      items: layoutService.bottomnavItems
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
                    ),
                    SizedBox(
                      height: 60,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PageTitle extends StatelessWidget {
  final layoutService = locator<LayoutService>();
  final String title;
  final int index;
  PageTitle({
    Key key,
    this.title,
    this.index,
  }) : super(key: key);

  onAfterBuild(context) {
    layoutService.setSize(index);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: layoutService.pageIndex$.stream,
      builder: (context, AsyncSnapshot<double> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final double pageValue = snapshot.data;

        double opacity = 0.24;
        int floor = pageValue.floor();
        int ceil = pageValue.ceil();

        if (index == ceil && index == floor) {
          opacity = 1;
        } else {
          double dx = (ceil - pageValue);

          if (index == floor) {
            opacity = math.max(dx, 0.24);
          }
          if (index == ceil) {
            opacity = math.max(1 - dx, 0.24);
          }
        }

        WidgetsBinding.instance
            .addPostFrameCallback((_) => onAfterBuild(context));
        return Container(
          // width: 116,
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(opacity),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
