import 'package:flutter/material.dart';
import 'package:yellowclass/constants/colors.dart';

import 'views/movies_list_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(offwhite),
      ),
      home: LandingPage(title: 'Yellow Class DB'),
    );
  }
}

class LandingPage extends StatelessWidget {
  LandingPage({this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(offwhite),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(offwhite),
        elevation: 0,
      ),
      body: Center(
        child: MoviesListView(),
      ),
    );
  }
}
