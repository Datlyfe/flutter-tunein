import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageSate createState() => _SearchPageSate();
}

class _SearchPageSate extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "SEARCH",
          style: TextStyle(
              color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
