import 'package:Tunein/components/pagenavheaderitem.dart';
import 'package:Tunein/services/layout.dart';
import 'package:Tunein/services/locator.dart';
import 'package:Tunein/values/lists.dart';
import 'package:flutter/material.dart';

class PageNavHeader extends StatefulWidget {
  final int pageIndex;
  PageNavHeader({Key key, this.pageIndex}) : super(key: key);

  _PageNavHeaderState createState() => _PageNavHeaderState();
}

class _PageNavHeaderState extends State<PageNavHeader> {
  final layoutService = locator<LayoutService>();

  @override 
  PageNavHeader get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  IconData(0xeaea, fontFamily: 'boxicons'),
                  size: 30,
                  color: Colors.white,
                ),
              )),
          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: layoutService.pageServices[widget.pageIndex].headerController,
              scrollDirection: Axis.horizontal,
              itemCount: headerItems[widget.pageIndex].length + 1,
              itemBuilder: (context, int index) {
                var items = headerItems[widget.pageIndex];
                if (index == items.length) {
                  return Container(
                    width: 1000,
                  );
                }
                return PageTitle(
                  pageIndex: widget.pageIndex,
                  index: index,
                  key: items[index].value,
                  title: items[index].key.toUpperCase(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
