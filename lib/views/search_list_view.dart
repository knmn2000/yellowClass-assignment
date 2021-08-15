import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../modals/movie.dart';

class SearchListView extends StatelessWidget {
  SearchListView({Key key, this.searchQuery}) : super(key: key);
  final String searchQuery;

  Future<List<Movie>> _searchMovies() async {
    // Future<Map<String, dynamic>> _fetchMovies() async {
    final moviesListAPIUrl =
        'https://api.themoviedb.org/3/search/movie?api_key=bb058074a670ad43d29e1d396c92ef1f&language=en-US&query=$searchQuery&page=1&include_adult=false';
    final response = await http.get(Uri.parse(moviesListAPIUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List data = jsonResponse['results'];
      print(data);
      // return listView;
      return data.map((movie) => new Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Error');
    }
  }

  ListTile _tile(String title, String subtitle, String poster) => ListTile(
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(subtitle),
        // leading: Icon(icon, color: Colors.blue[500]),
      );

  ListView _moviesListView(data) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _tile(
            data[index].title, data[index].director, data[index].poster);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Movie>>(
        future: _searchMovies(),
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
