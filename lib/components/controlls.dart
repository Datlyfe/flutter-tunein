import 'package:Tunein/blocs/music_player.dart';
import 'package:Tunein/models/songplus.dart';
import 'package:Tunein/store/locator.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:Tunein/models/playerstate.dart';
import 'package:rxdart/rxdart.dart';

class MusicBoardControls extends StatelessWidget {
  final List<int> colors;
  MusicBoardControls(this.colors);

  @override
  Widget build(BuildContext context) {
    final musicService = locator<MusicService>();

    return Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
        width: double.infinity,
        child: StreamBuilder<
            MapEntry<MapEntry<PlayerState, Song>, List<SongPlus>>>(
          stream: Observable.combineLatest2(
            musicService.playerState$,
            musicService.favorites$,
            (a, b) => MapEntry(a, b),
          ),
          builder: (BuildContext context,
              AsyncSnapshot<
                      MapEntry<MapEntry<PlayerState, Song>, List<SongPlus>>>
                  snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            final _state = snapshot.data.key.key;
            final _currentSong = snapshot.data.key.value;
            final List<SongPlus> _favorites = snapshot.data.value;
            SongPlus songPlus = SongPlus(_currentSong, colors);

            final int index =
                _favorites.indexWhere((song) => song.id == _currentSong.id);
            final bool _isFavorited = index == -1 ? false : true;

            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Icon(
                    Icons.loop,
                    color: new Color(colors[1]).withOpacity(.7),
                    size: 30,
                  ),
                  onTap: () => musicService.playNextSong(),
                ),
                InkWell(
                  child: Icon(
                    IconData(0xeb21, fontFamily: 'boxicons'),
                    color: new Color(colors[1]).withOpacity(.7),
                    size: 40,
                  ),
                  onTap: () => musicService.playPreviousSong(),
                ),
                InkWell(
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
                    child: Container(
                        decoration: BoxDecoration(
                            color: new Color(colors[1]).withOpacity(.7),
                            borderRadius: BorderRadius.circular(30)),
                        height: 50,
                        width: 50,
                        child: Center(
                          child: AnimatedCrossFade(
                            duration: Duration(milliseconds: 200),
                            crossFadeState: _state == PlayerState.playing
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild: Icon(
                              Icons.pause,
                              color: Color(colors[0]),
                              size: 30,
                            ),
                            secondChild: Icon(
                              Icons.play_arrow,
                              color: Color(colors[0]),
                              size: 30,
                            ),
                          ),
                        ))),
                InkWell(
                  child: Icon(
                    IconData(0xea8d, fontFamily: 'boxicons'),
                    color: new Color(colors[1]).withOpacity(.7),
                    size: 40,
                  ),
                  onTap: () => musicService.playNextSong(),
                ),
                InkWell(
                    child: Icon(
                      _isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: new Color(colors[1]).withOpacity(.7),
                      size: 30,
                    ),
                    onTap: () {
                      if (_isFavorited) {
                        musicService.removeFromFavorites(songPlus);
                      } else {
                        musicService.addToFavorites(songPlus);
                      }
                    }),
              ],
            );
          },
        ));
  }
}
