import 'package:flutter/material.dart';
import 'package:yellowclass/views/movies_list_view.dart';
import 'package:yellowclass/views/search_list_view.dart';

final _searchQueryController = TextEditingController();
Widget bottomSheetView(BuildContext context) {
  bool isSearching = false;
  return StatefulBuilder(
    builder: (BuildContext context, setState) {
      return Container(
        //TODO: ADD BORDER RADIUS
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: MediaQuery.of(context).size.height * 0.7,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: TextField(
                          onTap: () {
                            isSearching = isSearching;
                          },
                          controller: _searchQueryController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            labelText: 'Search...',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          if (_searchQueryController.text.length == 0) {
                            print('kuch type kar');
                            return;
                          }
                          setState(() {
                            isSearching = true;
                          });
                        }),
                  ),
                ],
              ),
              // TODO: Alternative to sizedbox for flexible heights
              isSearching
                  ? SizedBox(
                      height: 500,
                      child: SearchListView(
                        searchQuery: _searchQueryController.text,
                      ))
                  : Container(child: Text("works")),
            ],
          ),
        ),
      );
    },
  );
}
