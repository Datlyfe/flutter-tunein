import 'package:Tunein/plugins/nano.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

final _androidAppRetain = MethodChannel("android_app_retain");

class ThemeService {
  BehaviorSubject<List<int>> _color$;
  BehaviorSubject<List<int>> get color$ => _color$;

  Map<String, List<int>> _savedColors;

  ThemeService() {
    _initStreams();
    _savedColors = Map<String, List<int>>();
  }


  void updateTheme(Tune song) async {

    if (_savedColors.containsKey(song.id)) {
      _color$.add(_savedColors[song.id]);
      return;
    }

    String path = song.albumArt;

    if (path == null) {
      _color$.add([0xff111111, 0xffffffff]);
      return;
    }

    print("GETTING COLORS ");
    final colors =
        await _androidAppRetain.invokeMethod("getColor", {"path": path});
    List<int> _colors = List<int>();
    for (var color in colors) {
      _colors.add(color);
    }
    _color$.add(_colors);
    _savedColors[song.id] = _colors;
  }

  void _initStreams() {
    _color$ = BehaviorSubject<List<int>>.seeded([0xff111111, 0xffffffff]);
  }
}
