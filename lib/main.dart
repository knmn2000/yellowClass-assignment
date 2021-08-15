import 'package:flutter/material.dart';
import 'package:yellowclass/constants/colors.dart';
import 'package:yellowclass/views/bottom_sheet.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';
import 'views/movies_list_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              else
                return MoviesListView();
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
            showModalBottomSheet(
              transitionAnimationController: controller,
              isScrollControlled: true,
              context: context,
              builder: bottomSheetView,
            ).whenComplete(
                () => controller = BottomSheet.createAnimationController(this));
          },
        ),
      ),
    );
  }
}
