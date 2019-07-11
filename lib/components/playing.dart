import 'dart:io';

import 'package:Tunein/plugins/nano.dart';
import 'package:Tunein/services/locator.dart';
import 'package:Tunein/services/musicService.dart';
import 'package:Tunein/services/themeService.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:Tunein/components/slider.dart';
import 'package:Tunein/globals.dart';
import 'package:Tunein/models/playerstate.dart';
import 'package:flutter/widgets.dart';

import 'controlls.dart';

class NowPlayingScreen extends StatefulWidget {
  @override
  NowPlayingScreenState createState() => NowPlayingScreenState();
}

class NowPlayingScreenState extends State<NowPlayingScreen> {
  final musicService = locator<MusicService>();
  final themeService = locator<ThemeService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<MapEntry<PlayerState, Tune>>(
      stream: musicService.playerState$,
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<PlayerState, Tune>> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: MyTheme.bgBottomBar,
          );
        }

        final Tune _currentSong = snapshot.data.value;

        if (_currentSong.id == null) {
          return Scaffold(
            backgroundColor: MyTheme.bgBottomBar,
          );
        }

        return Scaffold(
            body: StreamBuilder<List<int>>(
                stream: themeService.color$,
                builder: (context, AsyncSnapshot<List<int>> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  final List<int> colors = snapshot.data;
                  return AnimatedContainer(
                    padding: MediaQuery.of(context).padding,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.decelerate,
                    color: Color(colors[0]),
                    child: getPlayinglayout(
                      _currentSong,
                      colors,
                      _screenHeight,
                    ),
                  );
                }));
      },
    );
  }

  String getDuration(Tune _song) {
    final double _temp = _song.duration / 1000;
    final int _minutes = (_temp / 60).floor();
    final int _seconds = (((_temp / 60) - _minutes) * 60).round();
    if (_seconds.toString().length != 1) {
      return _minutes.toString() + ":" + _seconds.toString();
    } else {
      return _minutes.toString() + ":0" + _seconds.toString();
    }
  }

  getPlayinglayout(Tune _currentSong, List<int> colors, double _screenHeight) {
    MapEntry<Tune, Tune> songs = musicService.getNextPrevSong(_currentSong);
    if (_currentSong == null || songs == null) {
      return Container();
    }
    
    String image = songs.value.albumArt;
    String image2 = songs.key.albumArt;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
            constraints: BoxConstraints(
                maxHeight: _screenHeight / 2, minHeight: _screenHeight / 2),
            padding: const EdgeInsets.all(10),
            child: Dismissible(
              key: UniqueKey(),
              background: image == null
                  ? Image.asset("images/cover.png")
                  : Image.file(File(image)),
              secondaryBackground: image2 == null
                  ? Image.asset("images/cover.png")
                  : Image.file(File(image2)),
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
              child: _currentSong.albumArt == null
                  ? Image.asset("images/cover.png")
                  : Image.file(File(_currentSong.albumArt)),
            )),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                new BoxShadow(
                    color: Color(colors[0]),
                    blurRadius: 50,
                    spreadRadius: 50,
                    offset: new Offset(0, -20)),
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
                              color: Color(colors[1]).withOpacity(.7),
                              fontSize: 18,
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
                                color: Color(colors[1]).withOpacity(.7),
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
