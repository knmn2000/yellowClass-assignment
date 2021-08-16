import 'package:hive/hive.dart';

part 'movie.g.dart';

@HiveType(typeId: 0)
class Movie extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  // final String genre;
  // final int rating;
  @HiveField(2)
  final String director;
  @HiveField(3)
  final String poster;

  Movie({this.title, this.id, this.director, this.poster});
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      // THE API DOES NOT RETURN DIRECTOR's NAME
      director: 'director',
      poster: json['poster_path'],
    );
  }
}
