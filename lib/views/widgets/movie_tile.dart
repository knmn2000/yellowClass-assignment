import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:yellowclass/views/heroDialog.dart';
import 'package:octo_image/octo_image.dart';

var path = 'https://image.tmdb.org/t/p/original';
Container movieTile(
        BuildContext context,
        int key,
        String title,
        String subtitle,
        String poster,
        int index,
        Function deleteMovie,
        Function editViewSheet) =>
    Container(
      child: Slidable(
        child: ListTile(
          leading: Hero(
            tag: key + index,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    HeroDialogRoute(builder: (BuildContext context) {
                  return Center(
                    child: AlertDialog(
                      title: Text(title),
                      content: Container(
                        child: Hero(
                            tag: key + index,
                            child: Container(
                              child: OctoImage(
                                image: NetworkImage(path + poster),
                                progressIndicatorBuilder: (context, progress) {
                                  double value;
                                  var expectedBytes =
                                      progress?.expectedTotalBytes;
                                  if (progress != null &&
                                      expectedBytes != null) {
                                    value = progress.cumulativeBytesLoaded /
                                        expectedBytes;
                                  }
                                  return CircularProgressIndicator(
                                      value: value);
                                },
                                errorBuilder: (context, error, stacktrace) =>
                                    Icon(Icons.error),
                              ),
                            )),
                      ),
                    ),
                  );
                }));
              },
              child: Container(
                child: OctoImage(
                  image: NetworkImage(path + poster),
                  progressIndicatorBuilder: (context, progress) {
                    double value;
                    var expectedBytes = progress?.expectedTotalBytes;
                    if (progress != null && expectedBytes != null) {
                      value = progress.cumulativeBytesLoaded / expectedBytes;
                    }
                    return CircularProgressIndicator(value: value);
                  },
                  errorBuilder: (context, error, stacktrace) =>
                      Icon(Icons.error),
                ),
              ),
            ),
          ),
          title: Text(title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              )),
          subtitle: Text(subtitle),
        ),
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.5,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => deleteMovie(key),
          ),
          IconSlideAction(
            caption: 'Update',
            color: Colors.yellow,
            icon: Icons.edit,
            // onTap: () => editMovie(key),
            onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return editViewSheet(context, key);
                }),
          ),
        ],
      ),
    );
