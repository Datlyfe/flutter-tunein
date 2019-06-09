import 'package:flutter/material.dart';
import '../globals.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  double _appBarHeight;
  MyAppBar(this._appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(backgroundColor: MyTheme.darkBlack, elevation: 0);
  }

  @override
  Size get preferredSize => new Size.fromHeight(_appBarHeight);
}
