import 'package:flutter/material.dart';
import 'package:b_to_do/UI/HomePage.dart';
import "package:b_to_do/UI/taskView.dart";

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "minimalist to do",
      home: HomePage(),
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
