import 'package:flutter/material.dart';
import 'package:yellowclass/api/api.dart';
import 'package:yellowclass/constants/colors.dart';
import 'package:yellowclass/views/bottom_sheet.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';
import 'views/movies_list_view.dart';
import 'modals/movie.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter<Movie>(MovieAdapter());
  await Hive.openBox('user_movies');
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
      home: LandingPage(title: 'Saved Movies'),
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
  GoogleSignInAccount _currentUser;
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    controller = BottomSheet.createAnimationController(this);
    controller.duration = Duration(seconds: 1);
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Signed in!"),
        duration: Duration(milliseconds: 2000),
      ));
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Signed out!"),
      duration: Duration(milliseconds: 2000),
    ));
    return _googleSignIn.disconnect();
  }

  @override
  void dispose() {
    // or close the specific box
    Hive.close();
    controller.dispose();
    super.dispose();
  }

  final movieBox = Hive.box('user_movies');
  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount user = _currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(offwhite),
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(user != null ? Icons.logout : Icons.login),
            color: Colors.black,
            onPressed: () {
              if (user != null) {
                _handleSignOut();
              } else {
                _handleSignIn();
              }
            },
          ),
        ],
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(offwhite),
        elevation: 0,
      ),
      body: Center(
        child: FutureBuilder(
          future: Hive.openBox('user_movies'),
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
              return Text('');
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
            if (user != null) {
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
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Sign in first!"),
                duration: Duration(milliseconds: 2000),
              ));
            }
          },
        ),
      ),
    );
  }
}
