import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LayoutService {
  BehaviorSubject<double> _pageIndex$;
  BehaviorSubject<double> get pageIndex$ => _pageIndex$;

  List<MapEntry<String, GlobalKey>> _mainNavItems$;
  List<MapEntry<String, GlobalKey>> get mainNavitems => _mainNavItems$;

  List<double> _navSizes;
  List<double> _cumulativeNavSizes;
  bool _isSet;
  int sizenumber;
  List<double> get navSizes => _navSizes;
  List<double> get cumulativeNavSizes => _cumulativeNavSizes;

  LayoutService() {
    _initStreams();
  }

  setSize(int index) {
    if (_isSet) {
      return;
    }
    GlobalKey key = _mainNavItems$[index].value;
    RenderBox renderBoxRed = key.currentContext.findRenderObject();
    double width = renderBoxRed.size.width;
    _navSizes[index] = width;
    sizenumber = sizenumber + 1;
    _checkSet();
  }

  void _checkSet() {
    if (sizenumber == _mainNavItems$.length) {
      _isSet = true;
      _constructCumulative();
    }
  }

  _constructCumulative() {
    _cumulativeNavSizes.add(0);
    _cumulativeNavSizes.add(_navSizes[0]);
    _navSizes.reduce((a, b) {
      _cumulativeNavSizes.add(a + b);
      return a + b;
    });
  }

  void _initStreams() {
    List<MapEntry<String, GlobalKey>> defaultNav = [
      MapEntry("Tracks", GlobalKey()),
      MapEntry("Favorites", GlobalKey()),
    ];

    _pageIndex$ = BehaviorSubject<double>.seeded(0);
    _mainNavItems$ = defaultNav;
    _isSet = false;
    sizenumber = 0;
    _navSizes = List<double>(_mainNavItems$.length);
    _cumulativeNavSizes = List<double>();
  }

  void updatePageIndex(double value) async {
    _pageIndex$.add(value);
  }
}
