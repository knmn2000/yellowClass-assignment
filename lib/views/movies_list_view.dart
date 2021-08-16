import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:yellowclass/modals/movie.dart';
import 'package:octo_image/octo_image.dart';
import 'package:yellowclass/views/heroDialog.dart';
import 'package:yellowclass/views/widgets/movie_tile.dart';

import 'edit_view_sheet.dart';

class MoviesListView extends StatefulWidget {
  @override
  _MoviesListViewState createState() => _MoviesListViewState();
}

class _MoviesListViewState extends State<MoviesListView> {
  Box<dynamic> movieBox;
  void getDataFromHive() {
    movieBox = Hive.box('saved_movies');
  }

  @override
  void initState() {
    super.initState();
    getDataFromHive();
    setState(() {
      movieBox = Hive.box('saved_movies');
    });
  }

  SlidableController slidableController;
  void deleteMovie(key) async {
    await movieBox.delete(key);
    setState(() {
      movieBox = Hive.box('saved_movies');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (movieBox.length > 0) {
      // TODO: make pretty
      return InfiniteListView.separated(
        itemBuilder: (BuildContext context, int index) {
          final movie = movieBox.getAt(index % movieBox.length) as Movie;
          return movieTile(
            context,
            movie.key,
            movie.title,
            movie.director,
            movie.poster,
            index,
            deleteMovie,
            editViewSheet,
          );
        },
        separatorBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Divider(height: 2.0),
        ),
        anchor: 0.5,
      );
    } else {
      return Text("No movies");
    }
  }
}
