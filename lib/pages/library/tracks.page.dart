import 'package:Tunein/components/card.dart';
import 'package:Tunein/components/pageheader.dart';
import 'package:Tunein/components/scrollbar.dart';
import 'package:Tunein/globals.dart';
import 'package:Tunein/models/playerstate.dart';
import 'package:Tunein/plugins/nano.dart';
import 'package:Tunein/services/locator.dart';
import 'package:Tunein/services/musicService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TracksPage extends StatefulWidget {
  _TracksPageState createState() => _TracksPageState();
}

class _TracksPageState extends State<TracksPage>
    with AutomaticKeepAliveClientMixin<TracksPage> {
  final musicService = locator<MusicService>();
  ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: MyTheme.darkBlack,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Flexible(
                  child: StreamBuilder(
                    stream: musicService.songs$,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Tune>> snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }

                      final _songs = snapshot.data;
                      _songs.sort((a, b) {
                        return a.title
                            .toLowerCase()
                            .compareTo(b.title.toLowerCase());
                      });
                      return ListView.builder(
                        padding: EdgeInsets.all(0),
                        controller: controller,
                        shrinkWrap: true,
                        itemExtent: 62,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: _songs.length + 1,
                        itemBuilder: (context, index) {
                          return StreamBuilder<MapEntry<PlayerState, Tune>>(
                            stream: musicService.playerState$,
                            builder: (BuildContext context,
                                AsyncSnapshot<MapEntry<PlayerState, Tune>>
                                    snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              }
                              if (index == 0) {
                                return PageHeader(
                                  "Suffle",
                                  "All Tracks",
                                  MapEntry(
                                      IconData(Icons.shuffle.codePoint,
                                          fontFamily: Icons.shuffle.fontFamily),
                                      Colors.white),
                                );
                              }

                              int newIndex = index - 1;
                              final PlayerState _state = snapshot.data.key;
                              final Tune _currentSong = snapshot.data.value;
                              final bool _isSelectedSong =
                                  _currentSong == _songs[newIndex];

                              return InkWell(
                                enableFeedback: false,
                                onTap: () {
                                  musicService.updatePlaylist(_songs);
                                  switch (_state) {
                                    case PlayerState.playing:
                                      if (_isSelectedSong) {
                                        musicService.pauseMusic(_currentSong);
                                      } else {
                                        musicService.stopMusic();
                                        musicService.playMusic(
                                          _songs[newIndex],
                                        );
                                      }
                                      break;
                                    case PlayerState.paused:
                                      if (_isSelectedSong) {
                                        musicService
                                            .playMusic(_songs[newIndex]);
                                      } else {
                                        musicService.stopMusic();
                                        musicService.playMusic(
                                          _songs[newIndex],
                                        );
                                      }
                                      break;
                                    case PlayerState.stopped:
                                      musicService.playMusic(_songs[newIndex]);
                                      break;
                                    default:
                                      break;
                                  }
                                },
                                child: MyCard(
                                  song: _songs[newIndex],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          MyScrollbar(
            controller: controller,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
