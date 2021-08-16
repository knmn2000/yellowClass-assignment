import 'package:flutter/material.dart';
import 'package:yellowclass/constants/colors.dart';
import 'package:yellowclass/views/bottom_sheet.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';
import 'views/movies_list_view.dart';
import 'modals/movie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter<Movie>(MovieAdapter());
  await Hive.openBox('saved_movies');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(offwhite),
      ),
      home: LandingPage(title: 'Yellow Class DB'),
    );
  }
}

class LandingPage extends StatefulWidget {
  LandingPage({this.title});
  final String title;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = BottomSheet.createAnimationController(this);
    controller.duration = Duration(seconds: 1);
  }

  @override
  void dispose() {
    // or close the specific box
    Hive.close();
    controller.dispose();
    super.dispose();
  }

  final movieBox = Hive.box('saved_movies');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(offwhite),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(offwhite),
        elevation: 0,
      ),
      body: Center(
        child: FutureBuilder(
          future: Hive.openBox('saved_movies'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError)
                return Text(snapshot.error.toString());
              else {
                if (movieBox.length > 0) {
                  return MoviesListView();
                } else {
                  return Text('no movies');
                }
              }
            } else
              return Scaffold();
          },
        ),
        // child: MoviesListView(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          label: Text("Add movie"),
          icon: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet<dynamic>(
              transitionAnimationController: controller,
              isScrollControlled: true,
              context: context,
              // backgroundColor: Colors.transparent,
              builder: bottomSheetView,
            ).whenComplete(() {
              controller = BottomSheet.createAnimationController(this);
              setState(() {});
            });
          },
        ),
      ),
    );
  }
}
