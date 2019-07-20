import 'dart:io';

import 'package:Tunein/plugins/nano.dart';
import 'package:Tunein/services/locator.dart';
import 'package:Tunein/services/musicService.dart';
import 'package:Tunein/services/themeService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Tunein/models/playerstate.dart';

import '../globals.dart';

class BottomPanel extends StatelessWidget {
  final musicService = locator<MusicService>();
  final themeService = locator<ThemeService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MapEntry<PlayerState, Tune>>(
      stream: musicService.playerState$,
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<PlayerState, Tune>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: MyTheme.bgBottomBar,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.bottomCenter,
          );
        }

        final Tune _currentSong = snapshot.data.value;

        if (_currentSong.id == null) {
          return Container(
            color: MyTheme.bgBottomBar,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.bottomCenter,
          );
        }

        final PlayerState _state = snapshot.data.key;
        final String _artists = getArtists(_currentSong);

        return StreamBuilder<List<int>>(
            stream: themeService.color$,
            builder: (context, AsyncSnapshot<List<int>> snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  color: MyTheme.bgBottomBar,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.bottomCenter,
                );
              }

              final List<int> colors = snapshot.data;

              return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                  color: Color(colors[0]),
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.bottomCenter,
                  child: getBottomPanelLayout(
                      _state, _currentSong, _artists, colors));
            });
      },
    );
  }

  String getArtists(Tune song) {
    if(song.artist == null) return "Unknow Artist";
    return song.artist.split(";").reduce((String a, String b) {
      return a + " & " + b;
    });
  }

  getBottomPanelLayout(_state, _currentSong, _artists, colors) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20, left: 5),
                child: _currentSong.albumArt != null
                    ? Image.file(File(_currentSong.albumArt))
                    : Image.asset("images/track.png"),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        _currentSong.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(colors[1]).withOpacity(.7),
                        ),
                      ),
                    ),
                    Text(
                      _artists,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(colors[1]).withOpacity(.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (_currentSong.uri == null) {
                return;
              }
              if (PlayerState.paused == _state) {
                musicService.playMusic(_currentSong);
              } else {
                musicService.pauseMusic(_currentSong);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: _state == PlayerState.playing
                      ? Icon(
                          Icons.pause,
                          color: Color(colors[1]).withOpacity(.7),
                        )
                      : Icon(
                          Icons.play_arrow,
                          color: Color(colors[1]).withOpacity(.7),
                        ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
