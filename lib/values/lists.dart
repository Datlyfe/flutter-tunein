import 'package:flutter/material.dart';

final Map<int, List<MapEntry<String, GlobalKey>>> headerItems = {
  0: [
    MapEntry("Tracks", GlobalKey()),
    MapEntry("Albums", GlobalKey()),
    MapEntry("Artists", GlobalKey())
  ],
  1: [MapEntry("Folders", GlobalKey()), MapEntry("Albums", GlobalKey())],
  2: [MapEntry("Artists", GlobalKey()), MapEntry("Done", GlobalKey())],
  3: [
    MapEntry("Equlizer", GlobalKey()),
    MapEntry("Sound Effects", GlobalKey())
  ],
  4: [MapEntry("Settings", GlobalKey()), MapEntry("Other", GlobalKey())]
};

final List<MapEntry<String, Icon>> bottomNavBarItems = [
  MapEntry("Library", Icon(IconData(0xec2f, fontFamily: 'boxicons'))),
  MapEntry("Playlists", Icon(IconData(0xeccd, fontFamily: 'boxicons'))),
  MapEntry("Search", Icon(IconData(0xeb2e, fontFamily: 'boxicons'))),
  MapEntry("Equalizer", Icon(IconData(0xea86, fontFamily: 'boxicons'))),
  MapEntry("Settings", Icon(IconData(0xec2e, fontFamily: 'boxicons'))),
];
