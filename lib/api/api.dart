import 'dart:convert';

import 'package:yellowclass/modals/movie.dart';
import 'package:http/http.dart' as http;

Future<List<Movie>> searchMovies(String searchQuery) async {
  final moviesListAPIUrl =
      'https://api.themoviedb.org/3/search/movie?api_key=bb058074a670ad43d29e1d396c92ef1f&language=en-US&query=${searchQuery}&page=1&include_adult=false';
  final response = await http.get(Uri.parse(moviesListAPIUrl));
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    List data = jsonResponse['results'];
    return data.map((movie) => new Movie.fromJson(movie)).toList();
  } else {
    throw Exception('Error');
  }
}
