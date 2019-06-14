import 'dart:io';

import 'package:Tunein/blocs/music_player.dart';
import 'package:Tunein/store/locator.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:Tunein/components/slider.dart';
import 'package:Tunein/globals.dart';
import 'package:Tunein/models/playerstate.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'controlls.dart';

import 'package:fluttery_seekbar/fluttery_seekbar.dart';
import 'dart:math';

class NowPlayingScreen extends StatefulWidget {
  @override
  NowPlayingScreenState createState() => NowPlayingScreenState();
}

class NowPlayingScreenState extends State<NowPlayingScreen> {
  final musicService = locator<MusicService>();
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
          return Text("No album art");
        }

        final Song _currentSong = snapshot.data.value;

        return Scaffold(
            body: FutureBuilder<List<dynamic>>(
                future: getColor(_currentSong.albumArt),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  final colors = snapshot.data;
                  return Container(
                    color: new Color(colors[0]),
                    child: getPlayinglayout(
                      _currentSong,
                      [Color(snapshot.data[0]), Color(snapshot.data[1])],
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

  Future<List<dynamic>> getColor(path) async {
    final colors =
        await _androidAppRetain.invokeMethod("getColor", {"path": path});
    print(colors);
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
          child: Image.file(File(_currentSong.albumArt)),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                new BoxShadow(
                    color: colors[0].withOpacity(0.8),
                    blurRadius: 70,
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

  getAlternativeLayout() {
    return SizedBox.expand(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 25.0,
          ),
          Center(
            child: Container(
              width: 250.0,
              height: 250.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFFE1483).withOpacity(.5),
                        shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: _buildRadialSeekBar(),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 200.0,
                      height: 200.0,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ClipOval(
                          clipper: MClipper(),
                          child: Image.asset(
                            "images/logo2.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 25.0,
          ),
          Column(
            children: <Widget>[
              Text(
                "Justin Bieber fit. Never say",
                style: TextStyle(
                    color: Color(0xFFFE1483),
                    fontSize: 20.0,
                    fontFamily: "Nexa"),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                "The Weeknd",
                style: TextStyle(
                    color: Color(0xFFFE1483),
                    fontSize: 18.0,
                    fontFamily: "NexaLight"),
              )
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            width: 350.0,
            height: 150.0,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    height: 65.0,
                    width: 290.0,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xFFFE1483), width: 3.0),
                        borderRadius: BorderRadius.circular(40.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.fast_rewind,
                              size: 55.0, color: Color(0xFFFE1483)),
                          Expanded(
                            child: Container(),
                          ),
                          Icon(Icons.fast_forward,
                              size: 55.0, color: Color(0xFFFE1483))
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 92.0,
                    height: 92.0,
                    decoration: BoxDecoration(
                        color: Color(0xFFFE1483), shape: BoxShape.circle),
                    child: IconButton(
                      icon: Icon(
                        Icons.play_arrow,
                        size: 45.0,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 190.0,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: -25,
                  child: Container(
                    width: 50.0,
                    height: 190.0,
                    decoration: BoxDecoration(
                        color: Color(0xFFFE1483),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0))),
                  ),
                ),
                Positioned(
                  right: -25,
                  child: Container(
                    width: 50.0,
                    height: 190.0,
                    decoration: BoxDecoration(
                        color: Color(0xFFFE1483),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0))),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      song("images/logo2.png", "Never say", "Believe 2012"),
                      song("images/logo2.png", "Beauty...", "Believe 2012"),
                      song("images/logo2.png", "Boyfriend", "Believe 2012"),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget song(String image, String title, String subtitle) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          image,
          width: 40.0,
          height: 40.0,
        ),
        SizedBox(
          width: 8.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: TextStyle(color: Color(0xFFFE1483))),
            Text(subtitle, style: TextStyle(color: Color(0xFFFE1483)))
          ],
        )
      ],
    ),
  );
}

class MClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: min(size.width, size.height) / 2);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

Widget _buildRadialSeekBar() {
  return RadialSeekBar(
    trackColor: Colors.red.withOpacity(.5),
    trackWidth: 2.0,
    progressColor: Color(0xFFFE1483),
    progressWidth: 5.0,
    thumbPercent: 0.4,
    thumb: CircleThumb(
      color: Color(0xFFFE1483),
      diameter: 20.0,
    ),
    progress: 0.4,
    onDragUpdate: (double percent) {},
  );
}
