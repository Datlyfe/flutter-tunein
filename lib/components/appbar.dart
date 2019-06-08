import 'package:flutter/material.dart';
import '../globals.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // backgroundColor: Colors.white,
      backgroundColor: MyTheme.darkBlack,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              IconData(0xea49, fontFamily: 'Boxicons'),
              size: 25,
              color: Colors.white54,
            ),
            onPressed: () => {},
          ),
          Text(
            "Library",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          IconButton(
            icon: Icon(
              IconData(0xeaeb, fontFamily: 'Boxicons'),
              size: 25,
              color: Colors.white54,
            ),
            onPressed: () => {},
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
