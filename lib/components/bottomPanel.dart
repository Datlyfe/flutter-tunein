import 'package:Tunein/blocs/music_player.dart';
import 'package:Tunein/store/locator.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:Tunein/models/playerstate.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../globals.dart';

class BottomPanel extends StatelessWidget {
  final PanelController _controller;
  final musicService = locator<MusicService>();

  BottomPanel({@required PanelController controller})
      : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyTheme.bgBottomBar,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.bottomCenter,
      child: StreamBuilder<MapEntry<PlayerState, Song>>(
        stream: musicService.playerState$,
        builder: (BuildContext context,
            AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final Song _currentSong = snapshot.data.value;

          if (_currentSong.id == null) {
            return Container();
          }

          final PlayerState _state = snapshot.data.key;
          final String _artists = getArtists(_currentSong);

          return Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: FadeInImage(
                        fadeInDuration: Duration(milliseconds: 50),
                        fadeOutDuration: Duration(milliseconds: 50),
                        image: AssetImage(_currentSong.albumArt),
                        placeholder: AssetImage("images/default_track.png"),
                        fit: BoxFit.fitHeight,
                      ),
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
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: MyTheme.grey700,
                              ),
                            ),
                          ),
                          Text(
                            _artists,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white54,
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
                                color: Colors.white54,
                              )
                            : Icon(
                                Icons.play_arrow,
                                color: Colors.white54,
                              ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  String getArtists(Song song) {
    return song.artist.split(";").reduce((String a, String b) {
      return a + " & " + b;
    });
  }
}
