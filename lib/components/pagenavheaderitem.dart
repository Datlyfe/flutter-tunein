import 'package:Tunein/services/layout.dart';
import 'package:Tunein/services/locator.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class PageTitle extends StatelessWidget {
  final layoutService = locator<LayoutService>();
  final String title;
  final int index;
  final int pageIndex;
  PageTitle({
    Key key,
    this.pageIndex,
    this.title,
    this.index,
  }) : super(key: key);

  onAfterBuild(context) {
    layoutService.pageServices[pageIndex].setSize(index);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: layoutService.pageServices[pageIndex].pageIndex$,
      builder: (context, AsyncSnapshot<double> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final double pageValue = snapshot.data;

        double opacity = 0.24;
        int floor = pageValue.floor();
        int ceil = pageValue.ceil();

        if (index == ceil && index == floor) {
          opacity = 1;
        } else {
          double dx = (ceil - pageValue);

          if (index == floor) {
            opacity = math.max(dx, 0.24);
          }
          if (index == ceil) {
            opacity = math.max(1 - dx, 0.24);
          }
        }

        WidgetsBinding.instance
            .addPostFrameCallback((_) => onAfterBuild(context));
        return Container(
          // width: 116,
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(opacity),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
