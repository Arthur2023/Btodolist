import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:b_to_do/UI/HomeLoad.dart';


void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "minimalist to do",
      home: MyApp(),
      theme: ThemeData(
        hintColor: Colors.black,
        primaryColor: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}
