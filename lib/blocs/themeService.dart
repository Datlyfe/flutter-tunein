import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

final _androidAppRetain = MethodChannel("android_app_retain");

class ThemeService {
  BehaviorSubject<List<int>> _colors$;
  BehaviorSubject<List<int>> get colors$ => _colors$;

  ThemeService() {
    _initStreams();
  }

  void _initStreams() {
    _colors$ = BehaviorSubject<List<int>>.seeded([0xff1e1e1e, 0xffffffff]);
  }

  void updateTheme(path) async {
    final colors =
        await _androidAppRetain.invokeMethod("getColor", {"path": path});
    List<int> _colors = List<int>();
    for (var color in colors) {
      _colors.add(color);
    }
    _colors$.add(_colors);
  }
}
