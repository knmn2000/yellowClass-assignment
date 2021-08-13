class Movie {
  final int id;
  final String title;
  // final String genre;
  // final int rating;
  final String director;
  final String poster;

  Movie({this.title, this.id, this.director, this.poster});
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      director: 'director',
      poster: json['poster_path'],
    );
  }
}
