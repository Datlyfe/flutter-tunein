import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:Tunein/blocs/global.dart';
import 'package:Tunein/components/slider.dart';
import 'package:Tunein/globals.dart';
import 'package:Tunein/models/playerstate.dart';
import 'package:provider/provider.dart';

import 'controlls.dart';

class NowPlayingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    final double _radius = 25.0;
    final double _screenHeight = MediaQuery.of(context).size.height;
    final double _screenWidth = MediaQuery.of(context).size.width;

    final double _albumArtSize = _screenHeight / 2;

    return Scaffold(
      backgroundColor: MyTheme.darkBlack,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          StreamBuilder<MapEntry<PlayerState, Song>>(
            stream: _globalBloc.musicPlayerBloc.playerState$,
            builder: (BuildContext context,
                AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
              if (!snapshot.hasData || snapshot.data.value.albumArt == null) {
                return Text("No album art");
              }

              final Song _currentSong = snapshot.data.value;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: new BorderRadius.circular(0),
                      child: FadeInImage(
                          fadeInDuration: Duration(milliseconds: 50),
                          fadeOutDuration: Duration(milliseconds: 50),
                          image: AssetImage(_currentSong.albumArt),
                          placeholder: AssetImage("images/note.png"),
                          width: _albumArtSize),
                    ),
                    Container(
                      width: double.infinity,
                      height: _screenHeight - _albumArtSize - 60,
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
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
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
                                          color:
                                              MyTheme.darkRed.withOpacity(0.7),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          NowPlayingSlider(),
                          MusicBoardControls(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
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
}
