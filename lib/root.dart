import 'dart:async';
import 'package:Tunein/pages/collection/collection.page.dart';
import 'package:Tunein/pages/library/library.page.dart';
import 'package:Tunein/services/layout.dart';
import 'package:Tunein/services/locator.dart';
import 'package:Tunein/services/musicService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/bottomnavbar.dart';
import 'globals.dart';

enum StartupState { Busy, Success, Error }

class Root extends StatefulWidget {
  RootState createState() => RootState();
}

class RootState extends State<Root> with TickerProviderStateMixin {
  final musicService = locator<MusicService>();
  final layoutService = locator<LayoutService>();
  final _androidAppRetain = MethodChannel("android_app_retain");

  final StreamController<StartupState> _startupStatus =
      StreamController<StartupState>();
  @override
  void initState() {
    loadFiles();
    super.initState();
  }

  @override
  void dispose() {
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
        if (!layoutService.globalPanelController.isPanelClosed()) {
          layoutService.globalPanelController.close();
        } else {
          _androidAppRetain.invokeMethod("sendToBackground");
          return Future.value(false);
        }
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(),
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

            return Theme(
              data: Theme.of(context).copyWith(accentColor: MyTheme.darkRed),
              child: Padding(
                padding: MediaQuery.of(context).padding,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Expanded(
                                child: PageView(
                                  controller:
                                      layoutService.globalPageController,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    LibraryPage(),
                                    CollectionPage(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              alignment: Alignment.center,
                              color: MyTheme.darkBlack,
                              height: 50,
                              width: 53,
                              child: InkWell(
                                onTap: () {},
                                child: Icon(
                                  IconData(0xeae9, fontFamily: 'boxicons'),
                                  size: 22,
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
