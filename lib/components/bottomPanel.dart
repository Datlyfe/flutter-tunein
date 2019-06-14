import 'dart:io';

import 'package:Tunein/blocs/music_player.dart';
import 'package:Tunein/blocs/themeService.dart';
import 'package:Tunein/store/locator.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Tunein/models/playerstate.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../globals.dart';

class BottomPanel extends StatelessWidget {
  final PanelController _controller;
  final musicService = locator<MusicService>();
  final themeService = locator<ThemeService>();

  BottomPanel({@required PanelController controller})
      : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MapEntry<PlayerState, Song>>(
      stream: musicService.playerState$,
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: MyTheme.bgBottomBar,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.bottomCenter,
          );
        }

        final Song _currentSong = snapshot.data.value;

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

        return StreamBuilder<List<dynamic>>(
            stream: themeService.colors$,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  color: MyTheme.bgBottomBar,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.bottomCenter,
                );
              }

              final colors = snapshot.data;

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

  String getArtists(Song song) {
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
                  child: Image.file(File(_currentSong.albumArt))),
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
                          fontSize: 16,
                          color: Color(colors[1]),
                        ),
                      ),
                    ),
                    Text(
                      _artists,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(colors[1]),
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
                          color: Color(colors[1]),
                        )
                      : Icon(
                          Icons.play_arrow,
                          color: Color(colors[1]),
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
