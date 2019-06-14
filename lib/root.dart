import 'dart:async';

import 'package:Tunein/blocs/music_player.dart';
import 'package:flutter/material.dart';
import 'package:Tunein/components/playing.dart';
import 'package:Tunein/home.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'components/appbar.dart';
import 'components/bottomPanel.dart';
import 'globals.dart';
import 'package:Tunein/store/locator.dart';

enum StartupState { Busy, Success, Error }

class Root extends StatefulWidget {
  RootState createState() => RootState();
}

class RootState extends State<Root> with TickerProviderStateMixin {
  final musicService = locator<MusicService>();

  PanelController _panelController;
  PageController _pageController;
  final StreamController<StartupState> _startupStatus =
      StreamController<StartupState>();
  final _androidAppRetain = MethodChannel("android_app_retain");
  @override
  void initState() {
    _panelController = PanelController();
    _pageController = PageController();
    _startupStatus.add(StartupState.Busy);
    loadFiles();
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
    if (data.length == 0) {
      await musicService.fetchSongs();
      musicService.saveFiles();
      musicService.retrieveFavorites();
      _startupStatus.add(StartupState.Success);
    } else {
      _startupStatus.add(StartupState.Success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!_panelController.isPanelClosed()) {
          _panelController.close();
        } else {
          _androidAppRetain.invokeMethod("sendToBackground");
          return Future.value(false);
        }
      },
      child: Scaffold(
        appBar: MyAppBar(0),
        backgroundColor: MyTheme.darkBlack,
        body: StreamBuilder<StartupState>(
          stream: _startupStatus.stream,
          builder: (BuildContext context, AsyncSnapshot<StartupState> snap) {
            if (!snap.hasData || snap.data == StartupState.Busy) {
              return Container(
                child: Center(
                  child: Text(
                    "Loading Tracks...",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              );
            }

            return SlidingUpPanel(
              panel: NowPlayingScreen(),
              controller: _panelController,
              maxHeight: MediaQuery.of(context).size.height,
              minHeight: 60,
              backdropEnabled: true,
              backdropOpacity: 0.5,
              parallaxEnabled: true,
              collapsed: BottomPanel(controller: _panelController),
              body: Theme(
                data: Theme.of(context).copyWith(accentColor: MyTheme.darkRed),
                child: PageView(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _pageController,
                  children: <Widget>[
                    HomePage(),
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: MyTheme.darkBlack,
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
