import 'package:Tunein/services/pageService.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LayoutService {
  // Main PageView
  PageController _globalPageController;
  PageController get globalPageController => _globalPageController;

  List<PageService> _pageServices;
  List<PageService> get pageServices => _pageServices;

  // PAGES
  BehaviorSubject<List<Widget>> _page$;
  BehaviorSubject<List<Widget>> get page$ => _page$;

  List<int> _navigationStack;
  List<int> get navigationStack => _navigationStack;

  void pushtoStack(int index) {
    _navigationStack.add(index);
  }

  void popStack() {
    _navigationStack.removeLast();
  }

  LayoutService() {
    _navigationStack = List<int>();
    _navigationStack.add(0);
    _pageServices = List<PageService>(5);
    for (var i = 0; i < _pageServices.length; i++) {
      _pageServices[i] = PageService(i);
    }
    _initGlobalPageView();
  }

  void _initGlobalPageView() {
    _globalPageController = PageController();
  }

  void updateGlobalPageIndex(int index) {}

  void changeGlobalPage(int pageIndex) {
    _globalPageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }
}
