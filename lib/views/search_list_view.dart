import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:yellowclass/api/api.dart';

import '../modals/movie.dart';

class SearchListView extends StatefulWidget {
  SearchListView({Key key, this.searchQuery}) : super(key: key);
  final String searchQuery;

  @override
  _SearchListViewState createState() => _SearchListViewState();
}

class _SearchListViewState extends State<SearchListView> {
  Box<dynamic> movieBox;
  Future<List<Movie>> _future;
  @override
  void initState() {
    super.initState();
    movieBox = Hive.box('user_movies');
    _future = searchMovies(widget.searchQuery);
  }

  void addMovie(Movie movie) {
    movieBox.add(movie);
    // REFRESH LIST
    setState(() {
      movieBox = Hive.box('user_movies');
    });
  }

  ListTile _tile(String title, String subtitle, String poster, Movie movie) =>
      ListTile(
        onTap: () {
          addMovie(movie);
        },
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(subtitle),
      );

  ListView _moviesListView(List<Movie> data) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _tile(data[index].title, data[index].director,
            data[index].poster, data[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // BUILD LIST VIEW OUT OF API RESPONSE
      child: FutureBuilder<List<Movie>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Movie> data = snapshot.data;
            return _moviesListView(data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
