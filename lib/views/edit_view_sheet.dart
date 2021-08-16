import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:yellowclass/modals/movie.dart';

Widget editViewSheet(BuildContext context, int key) {
  Box<dynamic> movieBox = Hive.box('saved_movies');
  Movie _movie = movieBox.get(key);
  final _titleController = new TextEditingController(text: _movie.title);
  final _posterController = TextEditingController(text: _movie.poster);
  final _directorController = TextEditingController(text: _movie.director);
  void saveEdits() {
    movieBox.put(
        key,
        Movie(
          title: _titleController.text,
          director: _directorController.text,
          poster: _posterController.text,
          id: _movie.id,
        ));
  }

  return StatefulBuilder(
    builder: (BuildContext context, setState) {
      return Container(
        padding: MediaQuery.of(context).viewInsets,
        //TODO: ADD BORDER RADIUS
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: MediaQuery.of(context).size.height * 0.7,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    controller: _titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      labelText: 'Title',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) {
                      print('gg');
                      // setState(() {
                      //   isSearching = true;
                      // });
                    },
                    controller: _posterController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      labelText: 'Poster',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) {
                      print('gg');
                      // setState(() {
                      //   isSearching = true;
                      // });
                    },
                    controller: _directorController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      labelText: 'Director',
                    ),
                  ),
                ),
              ),
              TextButton(onPressed: saveEdits, child: Text("Save"))
            ],
          ),
        ),
      );
    },
  );
}
