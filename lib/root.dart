import 'package:flutter/material.dart';
import 'package:Tunein/components/playing.dart';
import 'package:Tunein/home.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'components/appbar.dart';
import 'components/bottomPanel.dart';
import 'globals.dart';

class Root extends StatefulWidget {
  RootState createState() => RootState();
}

class RootState extends State<Root> with TickerProviderStateMixin {
  PanelController _panelController;
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    _panelController = PanelController();
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _panelController.close();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (!_panelController.isPanelClosed()) {
          _panelController.close();
        } else {
          ;
        }
      },
      child: Scaffold(
        appBar: MyAppBar(0),
        backgroundColor: MyTheme.darkBlack,
        body: SlidingUpPanel(
            panel: NowPlayingScreen(),
            controller: _panelController,
            maxHeight: MediaQuery.of(context).size.height,
            minHeight: 60,
            backdropEnabled: true,
            backdropOpacity: 0.5,
            parallaxEnabled: true,
            collapsed: BottomPanel(controller: _panelController),
            body: Theme(
              data: Theme.of(context).copyWith(accentColor: MyTheme.darkRed),
              child: PageView(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _pageController,
                children: <Widget>[
                  HomePage(),
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: MyTheme.darkBlack,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
