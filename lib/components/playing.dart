import 'dart:io';

import 'package:Tunein/blocs/music_player.dart';
import 'package:Tunein/blocs/themeService.dart';
import 'package:Tunein/store/locator.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:Tunein/components/slider.dart';
import 'package:Tunein/globals.dart';
import 'package:Tunein/models/playerstate.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'controlls.dart';

class NowPlayingScreen extends StatefulWidget {
  @override
  NowPlayingScreenState createState() => NowPlayingScreenState();
}

class NowPlayingScreenState extends State<NowPlayingScreen> {
  final musicService = locator<MusicService>();
  final themeService = locator<ThemeService>();

  final _androidAppRetain = MethodChannel("android_app_retain");

  int maxVol;
  int currentVol;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<MapEntry<PlayerState, Song>>(
      stream: musicService.playerState$,
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
        if (!snapshot.hasData || snapshot.data.value.albumArt == null) {
          return Scaffold(
            backgroundColor: MyTheme.bgBottomBar,
          );
        }

        final Song _currentSong = snapshot.data.value;

        return Scaffold(
            body: StreamBuilder<List<dynamic>>(
                stream: themeService.colors$,
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  final colors = snapshot.data;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.decelerate,
                    color: new Color(colors[0]),
                    child: getPlayinglayout(
                      _currentSong,
                      [Color(colors[0]), Color(colors[1])],
                      _screenHeight,
                    ),
                    // child: getAlternativeLayout(),
                  );
                }));
      },
    );
  }

  String getDuration(Song _song) {
    final double _temp = _song.duration / 1000;
    final int _minutes = (_temp / 60).floor();
    final int _seconds = (((_temp / 60) - _minutes) * 60).round();
    if (_seconds.toString().length != 1) {
      return _minutes.toString() + ":" + _seconds.toString();
    } else {
      return _minutes.toString() + ":0" + _seconds.toString();
    }
  }

  Future<List<dynamic>> updateTheme(path) async {
    final List<dynamic> colors =
        await _androidAppRetain.invokeMethod("getColor", {"path": path});
    themeService.updateTheme(colors);
    return colors;
  }

  getPlayinglayout(_currentSong, List<Color> colors, _screenHeight) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
            constraints: BoxConstraints(
                maxHeight: _screenHeight / 2, minHeight: _screenHeight / 2),
            padding: const EdgeInsets.all(10),
            child: Dismissible(
              key: UniqueKey(),
              // background: Image.asset("images/logo2.png"),
              movementDuration: Duration(milliseconds: 500),
              resizeDuration: Duration(milliseconds: 2),
              dismissThresholds: const {
                DismissDirection.endToStart: 0.3,
                DismissDirection.startToEnd: 0.3
              },
              direction: DismissDirection.horizontal,
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.startToEnd) {
                  musicService.playPreviousSong();
                } else {
                  musicService.playNextSong();
                }
              },
              child: Image.file(File(_currentSong.albumArt)),
            )),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                new BoxShadow(
                    color: colors[0],
                    blurRadius: 80,
                    spreadRadius: 70,
                    offset: new Offset(0, -30)),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            _currentSong.title,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors[1],
                              fontSize: 23,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              MyUtils.getArtists(_currentSong.artist),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colors[1],
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                NowPlayingSlider(colors),
                MusicBoardControls(colors),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
