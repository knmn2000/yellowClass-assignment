import 'package:flutter/material.dart';
import 'package:yellowclass/views/search_list_view.dart';

final _searchQueryController = TextEditingController();
Widget bottomSheetView(BuildContext context) {
  bool isSearching = false;
  return StatefulBuilder(
    builder: (BuildContext context, setState) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        )),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                // TEXT FIELD
                children: [
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: TextField(
                          textInputAction: TextInputAction.search,
                          onEditingComplete: () {
                            setState(() {
                              isSearching = true;
                            });
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
                    // SEARCH BUTTON
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
              // SEARCH RESULTS
              isSearching
                  ? SizedBox(
                      height: 500,
                      child: SearchListView(
                        searchQuery: _searchQueryController.text,
                      ))
                  : Container(child: Text("- - - ")),
            ],
          ),
        ),
      );
    },
  );
}
