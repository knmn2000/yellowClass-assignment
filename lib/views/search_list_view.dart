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

  // List data;
  // Future<List<Movie>> _searchMovies() async {
  //   if (data == null) {
  //     final moviesListAPIUrl =
  //         'https://api.themoviedb.org/3/search/movie?api_key=bb058074a670ad43d29e1d396c92ef1f&language=en-US&query=${widget.searchQuery}&page=1&include_adult=false';
  //     final response = await http.get(Uri.parse(moviesListAPIUrl));
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> jsonResponse = json.decode(response.body);
  //       data = jsonResponse['results'];
  //       return data.map((movie) => new Movie.fromJson(movie)).toList();
  //     } else {
  //       throw Exception('Error');
  //     }
  //   }
  //   return data;
  // }

  void addMovie(Movie movie) {
    movieBox.add(movie);
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
      child: FutureBuilder<List<Movie>>(
        // future: _searchMovies(),
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Map<String, dynamic> data = snapshot.data;
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
