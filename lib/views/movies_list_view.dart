import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yellowclass/modals/movie.dart';
import 'package:http/http.dart' as http;

class MoviesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchMovies(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> data = snapshot.data;
          return _moviesListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  // Future<List<Movie>> _fetchMovies() async {
  Future<Map<String, dynamic>> _fetchMovies() async {
    final moviesListAPIUrl =
        'https://api.themoviedb.org/3/discover/movie?api_key=bb058074a670ad43d29e1d396c92ef1f&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate';
    final response = await http.get(Uri.parse(moviesListAPIUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      // jsonResponse.
      return jsonResponse
          .forEach((movie, idx) => new Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Error');
    }
  }

  ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(subtitle),
        leading: Icon(icon, color: Colors.blue[500]),
      );

  ListView _moviesListView(data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _tile(
            data[index].title, data[index].director, data[index].poster);
      },
    );
  }
}
