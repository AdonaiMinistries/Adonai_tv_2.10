// @dart=2.9
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/bloc.dart';
import 'blocs/event.dart';
// ignore: import_of_legacy_library_into_null_safe, depend_on_referenced_packages
import 'package:http/http.dart' as http;

import 'screens/home_screen.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(const AdonaiTVApp());
}

class AdonaiTVApp extends StatelessWidget {
  const AdonaiTVApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Gotham'),
      home: BlocProvider(
        create: (context) =>
            AppBloc(httpClient: http.Client())..add(FetchAppConfigEvent()),
        child: Scaffold(
            // ignore: avoid_unnecessary_containers
            body: Container(color: Colors.black, child: const HomeScreen())),
      ),
    );
  }
}
