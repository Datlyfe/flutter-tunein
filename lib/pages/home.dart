import 'package:Tunein/components/card.dart';
import 'package:Tunein/components/pageheader.dart';
import 'package:Tunein/globals.dart';
import 'package:Tunein/models/playerstate.dart';
import 'package:Tunein/services/locator.dart';
import 'package:Tunein/services/musicService.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;


class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final musicService = locator<MusicService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 85),
      alignment: Alignment.center,
      color: MyTheme.darkBlack,
      child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: musicService.songs$,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                final _songs = snapshot.data;
                _songs.sort((a, b) {
                  return a.title.toLowerCase().compareTo(b.title.toLowerCase());
                });
                return ListView.builder(
                  shrinkWrap: true,
                  itemExtent: 62,
                  // physics: CustomScrollPhysics(),
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: _songs.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder<MapEntry<PlayerState, Song>>(
                      stream: musicService.playerState$,
                      builder: (BuildContext context,
                          AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        final PlayerState _state = snapshot.data.key;
                        final Song _currentSong = snapshot.data.value;
                        final bool _isSelectedSong =
                            _currentSong == _songs[index];
                        return InkWell(
                          enableFeedback: false,
                          onTap: () {
                            print("Wtf");
                            musicService.updatePlaylist(_songs);
                            switch (_state) {
                              case PlayerState.playing:
                                if (_isSelectedSong) {
                                  musicService.pauseMusic(_currentSong);
                                } else {
                                  musicService.stopMusic();
                                  musicService.playMusic(
                                    _songs[index],
                                  );
                                }
                                break;
                              case PlayerState.paused:
                                if (_isSelectedSong) {
                                  musicService.playMusic(_songs[index]);
                                } else {
                                  musicService.stopMusic();
                                  musicService.playMusic(
                                    _songs[index],
                                  );
                                }
                                break;
                              case PlayerState.stopped:
                                musicService.playMusic(_songs[index]);
                                break;
                              default:
                                break;
                            }
                          },
                          child: MyCard(
                            song: _songs[index],
                          ),
                          // child: Text(_songs[index].title,style:TextStyle(color: Colors.white) ,),
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
    );
  }
}

class CustomSimulation extends Simulation {
  final double initPosition;
  final double velocity;
  final double maxPos;

  CustomSimulation({this.initPosition,this.maxPos,this.velocity});

  @override
  double x(double time) {
    var max =
        math.max(math.min(initPosition, 0.0), math.min(initPosition + velocity * time, maxPos));

    // print(max.toString());

    return max;
  }

  @override
  double dx(double time) {
    // print(velocity.toString());
    return velocity;
  }

  @override
  bool isDone(double time) {
    return false;
  }
}

class CustomScrollPhysics extends ScrollPhysics {

const CustomScrollPhysics({ ScrollPhysics parent }) : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  // @override
  // ScrollPhysics applyTo(ScrollPhysics ancestor) {
  //   return CustomScrollPhysics();
  // }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    return CustomSimulation(
      initPosition: position.pixels,
      maxPos:position.maxScrollExtent,
      velocity: velocity,
    );
  }
}
