import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'blocs/global.dart';
import 'components/splash.dart';
import 'home.dart';

class Root extends StatelessWidget {
  final GlobalBloc _globalBloc = GlobalBloc();

  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>(
      builder: (BuildContext context) {
        _globalBloc.permissionsBloc.storagePermissionStatus$.listen(
          (data) {
            if (data == PermissionStatus.granted) {
              _globalBloc.musicPlayerBloc.fetchSongs().then(
                (_) {
                  _globalBloc.musicPlayerBloc.retrieveFavorites();
                },
              );
            }
          },
        );
        return _globalBloc;
      },
      dispose: (BuildContext context, GlobalBloc value) => value.dispose(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<PermissionStatus>(
          stream: _globalBloc.permissionsBloc.storagePermissionStatus$,
          builder:
              (BuildContext context, AsyncSnapshot<PermissionStatus> snapshot) {
            if (!snapshot.hasData) {
              return Splash();
            }
            final PermissionStatus _status = snapshot.data;
            if (_status == PermissionStatus.denied) {
              _globalBloc.permissionsBloc.requestStoragePermission();
              return Splash();
            } else {
              return HomePage();
            }
          },
        ),
      ),
    );
  }
}
