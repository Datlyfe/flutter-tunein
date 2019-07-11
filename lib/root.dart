import 'dart:async';
import 'package:Tunein/components/pagenavheader.dart';
import 'package:Tunein/pages/favorites.dart';
import 'package:Tunein/pages/home.dart';
import 'package:Tunein/services/layout.dart';
import 'package:Tunein/services/locator.dart';
import 'package:Tunein/services/musicService.dart';
import 'package:Tunein/values/lists.dart';
import 'package:flutter/material.dart';
import 'package:Tunein/components/playing.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'components/bottomPanel.dart';
import 'components/bottomnavbar.dart';
import 'globals.dart';
import 'dart:math' as math;

enum StartupState { Busy, Success, Error }

class Root extends StatefulWidget {
  RootState createState() => RootState();
}

class RootState extends State<Root> with TickerProviderStateMixin {
  final musicService = locator<MusicService>();
  final layoutService = locator<LayoutService>();
  final _androidAppRetain = MethodChannel("android_app_retain");

  PanelController _panelController;

  final StreamController<StartupState> _startupStatus =
      StreamController<StartupState>();
  @override
  void initState() {
    _panelController = PanelController();

    loadFiles();
    super.initState();
  }

  @override
  void dispose() {
    _panelController.close();
    _startupStatus.close();
    super.dispose();
  }

  Future loadFiles() async {
    _startupStatus.add(StartupState.Busy);
    final data = await musicService.retrieveFiles();
    if (data.length == 0) {
      await musicService.fetchSongs();
      musicService.saveFiles();
      musicService.retrieveFavorites();
      _startupStatus.add(StartupState.Success);
    } else {
      musicService.retrieveFavorites();
      _startupStatus.add(StartupState.Success);
    }
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
          builder:
              (BuildContext context, AsyncSnapshot<StartupState> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            if (snapshot.data == StartupState.Busy) {
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
                      padding: MediaQuery.of(context).padding,
                    ),
                    Expanded(
                      child: PageView(
                        controller: layoutService.globalPageController,
                        // physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: getPagelayout(),
                      ),
                    ),
                    BottomNavBar(),
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

  List<Widget> getPagelayout() {
    return [
      Column(
        children: <Widget>[
          PageNavHeader(
            pageIndex: 0,
          ),
          Flexible(
            child: PageView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: layoutService.pageServices[0].pageViewController,
              children: [HomePage(), FavoritesPage()],
            ),
          )
        ],
      ),
      Column(
        children: <Widget>[
          PageNavHeader(
            pageIndex: 1,
          ),
          Flexible(
            child: PageView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: layoutService.pageServices[1].pageViewController,
              children: [HomePage(), FavoritesPage()],
            ),
          )
        ],
      ),
      Text(
        "SEARCH PAGE",
        style: TextStyle(color: Colors.white),
      ),
      Column(),
      Column(),
    ];
  }
}
