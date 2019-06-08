import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'blocs/global.dart';
import 'permissions.dart';

final GlobalBloc _globalBloc = GlobalBloc();

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>.value(
      value: _globalBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GetPermissions(),
      ),
    );
  }
}
