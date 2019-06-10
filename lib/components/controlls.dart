import 'package:Tunein/blocs/music_player.dart';
import 'package:Tunein/store/locator.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:Tunein/models/playerstate.dart';

class MusicBoardControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final musicService = locator<MusicService>();

    return Container(
        width: double.infinity,
        child: StreamBuilder<MapEntry<PlayerState, Song>>(
          stream: musicService.playerState$,
          builder: (BuildContext context,
              AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            final _currentSong = snapshot.data.value;
            final _state = snapshot.data.key;

            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Icon(
                    IconData(0xeb21, fontFamily: 'boxicons'),
                    color: Colors.white70,
                    size: 50,
                  ),
                  onTap: () => musicService.playPreviousSong(),
                ),
                InkWell(
                  onTap: () {
                    print("hello");
                    if (_currentSong.uri == null) {
                      return;
                    }
                    if (PlayerState.paused == _state) {
                      musicService.playMusic(_currentSong);
                    } else {
                      musicService.pauseMusic(_currentSong);
                    }
                  },
                  child: AnimatedCrossFade(
                    duration: Duration(milliseconds: 200),
                    crossFadeState: _state == PlayerState.playing
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Icon(
                      IconData(0xeb03, fontFamily: 'boxicons'),
                      color: Colors.white,
                      size: 50,
                    ),
                    secondChild: Icon(
                      IconData(0xeb10, fontFamily: 'boxicons'),
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                InkWell(
                  child: Icon(
                    IconData(0xea8d, fontFamily: 'boxicons'),
                    color: Colors.white70,
                    size: 50,
                  ),
                  onTap: () => musicService.playNextSong(),
                ),
              ],
            );
          },
        ));
  }
}
