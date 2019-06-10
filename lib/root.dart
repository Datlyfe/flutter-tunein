import 'dart:async';

import 'package:Tunein/blocs/music_player.dart';
import 'package:flutter/material.dart';
import 'package:Tunein/components/playing.dart';
import 'package:Tunein/home.dart';
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
  @override
  void initState() {
    _panelController = PanelController();
    _pageController = PageController();
    _startupStatus.add(StartupState.Busy);
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
      print("success should rerender");
      _startupStatus.add(StartupState.Success);
    } else {
      print("success should rerender");

      _startupStatus.add(StartupState.Success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (!_panelController.isPanelClosed()) {
          _panelController.close();
        } else {}
      },
      child: Scaffold(
        appBar: MyAppBar(0),
        backgroundColor: MyTheme.darkBlack,
        body: StatefulWrapper(
          onInit: loadFiles,
          child: StreamBuilder<StartupState>(
            stream: _startupStatus.stream,
            builder: (BuildContext context, AsyncSnapshot<StartupState> snap) {
              print("render ${snap.data}");
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
                  data:
                      Theme.of(context).copyWith(accentColor: MyTheme.darkRed),
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
      ),
    );
  }
}

class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Widget child;
  StatefulWrapper({Key key, this.onInit, this.child}) : super(key: key);

  _StatefulWrapperState createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
