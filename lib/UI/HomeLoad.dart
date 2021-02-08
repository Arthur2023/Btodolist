import 'package:b_to_do/UI/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Splash Screen Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return _introScreen();
  }
}

Widget _introScreen() {
  return Stack(
    children: <Widget>[
      SplashScreen(
        seconds: 3,
        gradientBackground: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF000000)],
        ),
        navigateAfterSeconds: HomePage(),
      ),
      Align(
        child: Container(
          height: 150,
          width: 150,

          decoration: BoxDecoration(
            // color: Color(0xFF26C6DA),
            image: DecorationImage(
              image: AssetImage("images/hamster.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ],
  );
}
